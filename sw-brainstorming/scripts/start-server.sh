#!/usr/bin/env bash
# 启动头脑风暴服务器并输出连接信息
# 用法: start-server.sh [--project-dir <路径>] [--host <绑定主机>] [--url-host <显示主机>] [--foreground] [--background]
#
# 在随机高端口启动服务器，输出带 URL 的 JSON。
# 每个会话获得自己的目录以避免冲突。
#
# 选项:
#   --project-dir <路径>  在 <路径>/.superpowers/brainstorm/ 下存储会话文件
#                         而不是 /tmp。服务器停止后文件持久化。
#   --host <绑定主机>    绑定的主机/接口 (默认: 127.0.0.1)。
#                         在远程/容器化环境中使用 0.0.0.0。
#   --url-host <主机>     返回的 URL JSON 中显示的主机名。
#   --foreground          在当前终端运行服务器（不入后台）。
#   --background          强制后台模式（覆盖 Codex 自动前台）。

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 解析参数
PROJECT_DIR=""
FOREGROUND="false"
FORCE_BACKGROUND="false"
BIND_HOST="127.0.0.1"
URL_HOST=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-dir)
      PROJECT_DIR="$2"
      shift 2
      ;;
    --host)
      BIND_HOST="$2"
      shift 2
      ;;
    --url-host)
      URL_HOST="$2"
      shift 2
      ;;
    --foreground|--no-daemon)
      FOREGROUND="true"
      shift
      ;;
    --background|--daemon)
      FORCE_BACKGROUND="true"
      shift
      ;;
    *)
      echo "{\"error\": \"未知参数: $1\"}"
      exit 1
      ;;
  esac
done

if [[ -z "$URL_HOST" ]]; then
  if [[ "$BIND_HOST" == "127.0.0.1" || "$BIND_HOST" == "localhost" ]]; then
    URL_HOST="localhost"
  else
    URL_HOST="$BIND_HOST"
  fi
fi

# 某些环境会回收分离/后台进程。检测到后自动前台。
if [[ -n "${CODEX_CI:-}" && "$FOREGROUND" != "true" && "$FORCE_BACKGROUND" != "true" ]]; then
  FOREGROUND="true"
fi

# Windows/Git Bash 回收 nohup 后台进程。检测到后自动前台。
if [[ "$FOREGROUND" != "true" && "$FORCE_BACKGROUND" != "true" ]]; then
  case "${OSTYPE:-}" in
    msys*|cygwin*|mingw*) FOREGROUND="true" ;;
  esac
  if [[ -n "${MSYSTEM:-}" ]]; then
    FOREGROUND="true"
  fi
fi

# 生成唯一会话目录
SESSION_ID="$$-$(date +%s)"

if [[ -n "$PROJECT_DIR" ]]; then
  SESSION_DIR="${PROJECT_DIR}/.superpowers/brainstorm/${SESSION_ID}"
else
  SESSION_DIR="/tmp/brainstorm-${SESSION_ID}"
fi

STATE_DIR="${SESSION_DIR}/state"
PID_FILE="${STATE_DIR}/server.pid"
LOG_FILE="${STATE_DIR}/server.log"

# 创建带内容和状态对等的新鲜会话目录
mkdir -p "${SESSION_DIR}/content" "$STATE_DIR"

# 终止任何现有服务器
if [[ -f "$PID_FILE" ]]; then
  old_pid=$(cat "$PID_FILE")
  kill "$old_pid" 2>/dev/null
  rm -f "$PID_FILE"
fi

cd "$SCRIPT_DIR"

# 解析 harness PID（此脚本的祖父进程）。
# $PPID 是 harness 生成的临时 shell——当此脚本退出时它会死亡。
# harness 本身是 $PPID 的父进程。
OWNER_PID="$(ps -o ppid= -p "$PPID" 2>/dev/null | tr -d ' ')"
if [[ -z "$OWNER_PID" || "$OWNER_PID" == "1" ]]; then
  OWNER_PID="$PPID"
fi

# 前台模式用于回收分离/后台进程的环境。
if [[ "$FOREGROUND" == "true" ]]; then
  echo "$$" > "$PID_FILE"
  env BRAINSTORM_DIR="$SESSION_DIR" BRAINSTORM_HOST="$BIND_HOST" BRAINSTORM_URL_HOST="$URL_HOST" BRAINSTORM_OWNER_PID="$OWNER_PID" node server.cjs
  exit $?
fi

# 启动服务器，将输出捕获到日志文件
# 使用 nohup 在 shell 退出后存活；disown 从作业表中移除
nohup env BRAINSTORM_DIR="$SESSION_DIR" BRAINSTORM_HOST="$BIND_HOST" BRAINSTORM_URL_HOST="$URL_HOST" BRAINSTORM_OWNER_PID="$OWNER_PID" node server.cjs > "$LOG_FILE" 2>&1 &
SERVER_PID=$!
disown "$SERVER_PID" 2>/dev/null
echo "$SERVER_PID" > "$PID_FILE"

# 等待服务器启动消息（检查日志文件）
for i in {1..50}; do
  if grep -q "server-started" "$LOG_FILE" 2>/dev/null; then
    # 短暂窗口后验证服务器仍然存活（捕获进程回收器）
    alive="true"
    for _ in {1..20}; do
      if ! kill -0 "$SERVER_PID" 2>/dev/null; then
        alive="false"
        break
      fi
      sleep 0.1
    done
    if [[ "$alive" != "true" ]]; then
      echo "{\"error\": \"服务器启动但被终止。在持久终端中重试: $SCRIPT_DIR/start-server.sh${PROJECT_DIR:+ --project-dir $PROJECT_DIR} --host $BIND_HOST --url-host $URL_HOST --foreground\"}"
      exit 1
    fi
    grep "server-started" "$LOG_FILE" | head -1
    exit 0
  fi
  sleep 0.1
done

# 超时——服务器未启动
echo '{"error": "服务器在 5 秒内未能启动"}'
exit 1
