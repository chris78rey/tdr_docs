---
name: transformar-docs
description: Orquesta la transformación de documentos fuente aplicando un contexto global, usando los agentes planner (solo lectura) y worker (escritura limitada a destino) del proyecto. Usar cuando se necesite reescribir, adaptar o convertir múltiples documentos HTML siguiendo lineamientos consistentes.
---

# Transformar Documentos (HTML)

Orquesta tres fases con subagentes del proyecto para transformar documentos **HTML** de forma segura y coherente.

## Agentes utilizados

| Agente | Ubicación | Rol |
|---|---|---|
| `planner` | `.pi/agents/planner.md` | Solo lectura. Analiza HTML fuente y contexto, produce plan + matriz de coherencia. |
| `worker` | `.pi/agents/worker.md` | Escritura limitada a destino. Lee HTML fuente y genera HTML transformado con consistencia transversal. |

## Formato

**Entrada y salida: HTML5.** Los documentos fuente son archivos `.html` que contienen la estructura semántica del documento original (encabezados, tablas, párrafos, listas). La transformación produce archivos `.html` en la carpeta destino.

## Requisitos del sistema

```bash
sudo apt update
sudo apt install -y pandoc python3-pip
pip install python-docx openpyxl pandas
```

Solo necesario si hay fuentes `.docx`/`.xlsx` sin convertir. Si ya son HTML, no se necesita nada extra.

## Estructura del repositorio

```
.pi/agents/
  planner.md
  worker.md

.agents/skills/transformar-docs/
  SKILL.md

scripts/
  preparar_fuentes.sh    ← convierte .docx/.xlsx a .html

contexto/
  contexto.md

fuentes/
  documentos fuente (.html)

salida/
  documentos transformados (.html)
```

## Regla de cantidad y coherencia

Si la carpeta origen contiene **N** documentos relacionados, la carpeta destino debe contener **N** documentos transformados o **N** documentos justificados entre transformados y omitidos.

Además, todos los documentos generados deben mantener **coherencia transversal** entre sí en:

- nombre del proyecto
- entidad solicitante
- objetivo
- alcance
- fechas
- plazos
- responsables
- terminología
- anexos
- referencias cruzadas
- tono institucional

No se permite generar documentos aislados que se contradigan entre sí.

## 1. Pre-procesamiento (solo si hay binarios)

Si los archivos fuente están en `.docx` o `.xlsx`, conviértelos a HTML:

```bash
./scripts/preparar_fuentes.sh fuentes fuentes_convertidas
```

Esto convierte:
- `.docx` → HTML5 (via pandoc)
- `.xlsx` → HTML tabla (via pandas)
- `.html` → copia directa

Los errores quedan en `fuentes_convertidas/CONVERSION_ERRORES.md`.

Si los archivos ya son `.html`, puedes usar `fuentes/` directamente y omitir este paso.

## 2. Respaldo recomendado

```bash
cp -a .pi .pi_backup_$(date +%Y%m%d_%H%M%S)
cp -a .agents .agents_backup_$(date +%Y%m%d_%H%M%S)
cp -a fuentes fuentes_backup_$(date +%Y%m%d_%H%M%S)

find fuentes -type f -exec sha256sum {} \; | sort > /tmp/fuentes_antes.sha256
```

## 3. Flujo de trabajo: 3 fases

Ejecuta una cadena secuencial de 3 pasos, pasando contexto entre ellos mediante `{previous}`:

```bash
/chain planner "Lee el contexto en contexto/contexto.md y analiza todos los documentos HTML de fuentes/. Construye la matriz global de coherencia y el plan documento por documento. No modifiques archivos." -> worker "Ejecuta el plan anterior usando {previous}. Guarda los resultados HTML únicamente en salida/. Nunca modifiques fuentes/. Usa la matriz global de coherencia para garantizar consistencia transversal." -> planner "Revisa todos los documentos HTML generados en salida/ y compáralos entre sí. Verifica coherencia de nombres, fechas, alcance, terminología, anexos y referencias cruzadas usando la matriz global del primer planner. No modifiques archivos. Devuelve inconsistencias encontradas."
```

### Fase 1: planner — Análisis y matriz global

- Lee el archivo de contexto global (`contexto/contexto.md`)
- Inspecciona los documentos fuente HTML en `fuentes/`
- Extrae contenido semántico: títulos (`<h1>`-`<h6>`), tablas (`<table>`), párrafos (`<p>`), listas
- Construye la **matriz global de coherencia**: proyecto, entidad, objetivo, alcance, fechas, responsables, terminología, elementos compartidos, contradicciones
- Crea el plan de transformación documento por documento
- Detecta riesgos: HTML mal formado, datos faltantes, ambigüedades
- **No modifica archivos**
- Produce `[DONE:planner]` con matriz + plan

### Fase 2: worker — Transformación a HTML con consistencia

- Recibe el plan + matriz vía `{previous}`
- Crea la carpeta `salida/` si no existe
- Lee cada HTML fuente, lo transforma según el plan y la matriz
- Genera HTML5 de salida preservando la estructura semántica
- Garantiza consistencia transversal: proyecto, institución, fechas, responsables, terminología, anexos, referencias cruzadas, tono
- Omite documentos no transformables y registra el motivo
- Genera `TRANSFORMACION_ERRORES.md` con omisiones y contradicciones no resueltas
- **Nunca escribe en la carpeta origen**
- Produce `[DONE:worker]`

### Fase 3: planner/reviewer — Validación de coherencia

- Recibe los documentos HTML generados en `salida/`
- Los compara entre sí usando la matriz de la Fase 1
- Verifica coherencia de: nombres, fechas, alcance, terminología, anexos, referencias cruzadas
- **No modifica archivos**
- Devuelve inconsistencias encontradas

## 4. Verificación posterior

```bash
# Conteo de documentos HTML
echo "Originales HTML:"
find fuentes -name "*.html" -type f | wc -l
echo "Transformados:"
find salida -name "*.html" -type f | wc -l

# Integridad de originales
find fuentes -type f -exec sha256sum {} \; | sort > /tmp/fuentes_post.sha256
diff -u /tmp/fuentes_antes.sha256 /tmp/fuentes_post.sha256 && echo "✅ Originales intactos" || echo "⚠️  Cambios detectados"

# Reporte de errores
cat salida/TRANSFORMACION_ERRORES.md 2>/dev/null || echo "Sin errores reportados"
```

## Plan de reversión

```bash
rm -rf .pi && mv .pi_backup_* .pi
rm -rf .agents && mv .agents_backup_* .agents
rm -rf fuentes && mv fuentes_backup_* fuentes
```
