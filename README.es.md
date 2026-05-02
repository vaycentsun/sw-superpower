<div align="right">
  <a href="./README.md">🇺🇸 English</a> | <a href="./README.zh.md">🇨🇳 中文</a> | <a href="./README.ja.md">🇯🇵 日本語</a> | <strong>🇪🇸 Español</strong> | <a href="./README.fr.md">🇫🇷 Français</a>
</div>

# sw-superpower 🦸

> Un conjunto de habilidades estilo Superpowers para agentes de codificación AI — flujos de trabajo de ingeniería de software estructurados desde la lluvia de ideas hasta la revisión de código.

Un conjunto completo de habilidades de flujo de trabajo de ingeniería de software que ayuda a los agentes de codificación AI a completar cada paso desde el análisis de requisitos hasta la revisión de código de manera sistemática y reproducible.

---

## 📦 Descripción General

`sw-superpower` es un conjunto de habilidades estilo Superpowers diseñado para [OpenCode](https://opencode.ai) y otras plataformas de codificación AI. Encapsula prácticas maduras de ingeniería de software (TDD, revisión de código, depuración sistemática) en habilidades de agente estructuradas y reutilizables.

### Principios Fundamentales

- **Proceso Impulsado**: Cada habilidad define condiciones de activación claras y flujos de trabajo de ejecución
- **Reglas Primero**: Las reglas innegociables se colocan al frente
- **Probado Bajo Presión**: Las habilidades se crean y validan a través de TDD
- **Entrega Incremental**: Flujo de trabajo completo desde la lluvia de ideas hasta la entrega de código

---

## 🗂️ Estructura del Proyecto

```
sw-superpower/
├── sw-brainstorming/              # Lluvia de ideas y análisis de requisitos
├── sw-writing-specs/              # Escritura de planes de implementación
├── sw-subagent-development/       # Desarrollo impulsado por subagentes
├── sw-test-driven-dev/            # Desarrollo dirigido por pruebas
├── sw-requesting-code-review/     # Solicitar revisión de código
├── sw-receiving-code-review/      # Recibir revisión de código
├── sw-systematic-debugging/       # Depuración sistemática
├── sw-dispatching-parallel-agents/# Despacho paralelo de agentes
├── sw-executing-plans/            # Ejecución de planes
├── sw-verification-before-completion/  # Verificación previa a la finalización
├── sw-finishing-branch/           # Finalización de rama de desarrollo
├── sw-using-superpowers/          # Bootstrap del sistema de habilidades (entrada principal)
└── sw-writing-skills/             # Escritura de nuevas habilidades (meta-habilidad)
```

---

## 🚀 Flujo de Trabajo Principal

El flujo de trabajo completo de desarrollo de software se ejecuta en el siguiente orden:

```
Iniciar Nueva Función
    ↓
sw-brainstorming (Lluvia de Ideas y Diseño)
    ↓ Salida: docs/sw-superpower/specs/YYYY-MM-DD--feature.md
sw-writing-specs (Escritura del Plan de Implementación)
    ↓ Salida: docs/sw-superpower/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (Desarrollo Impulsado por Subagentes)
    ├── sw-test-driven-dev (TDD para cada tarea)
    ├── sw-requesting-code-review (Revisión después de tareas)
    └── sw-receiving-code-review (Manejar feedback de revisión)
    ↓
sw-verification-before-completion (Verificación Previa a la Finalización)
    ↓
sw-finishing-branch (Finalización de Rama)
```

---

## 📋 Resumen de Habilidades

| Habilidad | Propósito | Condición de Activación |
|-----------|-----------|-------------------------|
| **sw-brainstorming** | Transformar ideas en diseño y especificaciones completas | Iniciando desarrollo de nueva función |
| **sw-writing-specs** | Crear planes de implementación detallados | Diseño completado, se necesita plan de ejecución |
| **sw-subagent-development** | Ejecutar planes usando subagentes | Tener plan de implementación, las tareas son independientes |
| **sw-test-driven-dev** | Aplicar ciclo RED-GREEN-REFACTOR | Implementar cualquier función o corregir errores |
| **sw-requesting-code-review** | Despachar subagente revisor de código | Después de tarea, antes de merge |
| **sw-receiving-code-review** | Manejar feedback de revisión externa | Al recibir comentarios de revisión |
| **sw-systematic-debugging** | Investigación sistemática de errores | Errores encontrados o pruebas fallando |
| **sw-dispatching-parallel-agents** | Flujos de trabajo concurrentes de subagentes | 2+ tareas independientes |
| **sw-executing-plans** | Ejecutar planes en lote en misma sesión | Tener plan, no usar subagentes |
| **sw-verification-before-completion** | Verificación previa a la finalización | Listo para marcar tarea como completada |
| **sw-finishing-branch** | Verificar, decidir y limpiar rama | Todas las tareas completadas |
| **sw-writing-skills** | Crear y validar nuevas habilidades | Necesidad de crear una nueva habilidad |
| **sw-using-superpowers** | Bootstrap del sistema de habilidades | Inicio de cada conversación |

---

## 🎯 Inicio Rápido

### Instalación

**Método 1: Plugin de OpenCode (Recomendado)**

Agrega a tu `~/.config/opencode/opencode.json`:

```json
{
  "plugin": [
    "sw-superpower@git+http://192.168.1.100:53000/vaycent/sw-superpower.git#main"
  ],
  "permission": {
    "skill": {
      "*": "allow"
    }
  }
}
```

Reinicia OpenCode. El plugin se instalará automáticamente vía Bun.

**Método 2: Git Submodule**

```bash
cd <tu-proyecto>/skills/
git submodule add https://github.com/vaycentsun/sw-superpower.git
git submodule update --init --recursive
```

Para actualizar el submódulo más tarde:

```bash
cd <tu-proyecto>/skills/sw-superpower
git pull origin main
cd <tu-proyecto>
git add skills/sw-superpower
git commit -m "Update sw-superpower submodule"
```

O clona directamente (no recomendado para proyectos que usan control de versiones):

```bash
cd <tu-proyecto>/skills/
git clone https://github.com/vaycentsun/sw-superpower.git
```

Reinicia OpenCode o recarga las habilidades.

### Ejemplo de Uso

Cuando inicias una nueva función, el agente reconoce automáticamente y aplica la habilidad apropiada:

```
Usuario: Quiero desarrollar una función de autenticación de usuario

Agente: [Aplica automáticamente la Habilidad sw-brainstorming]
      1. Explorar contexto del proyecto...
      2. Hacer preguntas de aclaración...
      3. Proponer 2-3 enfoques...
      4. Presentar diseño en secciones...
      5. Escribir documento de especificación → docs/sw-superpower/specs/2026-04-18--user-auth.md
      6. Invocar sw-writing-specs para crear plan de implementación...
```

---

## 🏗️ Estructura de Habilidades

Cada habilidad es un directorio autocontenido siguiendo una estructura unificada:

```
sw-<skill-name>/
├── SKILL.md                    # Archivo principal de habilidad (requerido)
├── subagent-prompts/           # Prompts de subagentes (opcional)
│   └── <name>-prompt.md

```

### Formato SKILL.md

```markdown
---
name: skill-name
description: "Use when [condición de activación específica]"
---

# Nombre de la Habilidad

## Reglas de Hierro
Reglas clave que no deben violarse

## Proceso
Diagrama de flujo y pasos detallados

## Banderas Rojas - Detener Inmediatamente
Lista de señales de violación

## Tabla de Excusas Comunes
| Excusa | Realidad |
|--------|----------|

## Integración
Habilidades previas y subsiguientes

## Ejemplo de Salida
Formato de salida esperado
```

---

## 🔑 Principios Clave

### Principio YAGNI

> You Aren't Gonna Need It (No lo vas a necesitar)

- No agregar funciones no requeridas por la especificación
- No sobre-ingenierizar
- No asumir requisitos futuros

### Principios de Desarrollo con Subagentes

- Usar un subagente nuevo para cada tarea
- Los subagentes no deben heredar el contexto de sesión
- Proporcionar texto de tarea completo y contexto

### Principios de Revisión

- **Objetivo**: Basado en estándares, no preferencias personales
- **Constructivo**: Proporcionar sugerencias específicas de mejora
- **Priorizado**: Enfocarse en problemas críticos

---

## 🧪 Estrategia de Pruebas

Este proyecto desarrolla habilidades usando TDD:

1. **Primero Pruebas, Segundo Habilidad** - Sin excepciones
2. **Crear Escenarios de Presión** - 3+ pruebas de combinación de presiones
3. **Documentar Fallas Baseline** - Observar comportamiento de falla sin habilidad
4. **Escribir Habilidad para Abordar Fallas** - Apuntar a fallas observadas
5. **Verificar Cumplimiento** - Reprobar con habilidad
6. **Cerrar Escapatorias** - Encontrar nuevas excusas, agregar contramedidas

---

## 🤝 Contribuir

### Crear una Nueva Habilidad

1. Usar la habilidad `sw-writing-skills` para guiar el proceso de creación
2. Seguir enfoque TDD: primero probar, luego escribir
3. Crear 3+ pruebas de escenarios de presión
4. Documentar comportamiento de falla baseline
5. Escribir habilidad para abordar fallas específicas
6. Verificar cumplimiento, cerrar escapatorias

### Convención de Commits

```bash
# Crear nueva habilidad
feat: add sw-<skill-name> for <purpose>

# Actualizar habilidad existente
fix: resolve <issue> in sw-<skill-name>

docs: update <section> in sw-<skill-name>
```

---

## 📄 Licencia

[MIT](./LICENSE)

---

## 🙏 Agradecimientos

- Basado en el formato de habilidades [Superpowers](https://github.com/anthropics/superpowers)
- Inspirado por prácticas maduras de ingeniería de software

---

<div align="center">

**Haciendo la programación AI más sistemática, predecible y de alta calidad** 🚀

</div>
