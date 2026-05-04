# TRANSFORMACION_ERRORES.md

## Reporte de transformación documental

**Proyecto:** Adquisición de Muebles de Oficina para el HE1 - 2026
**Fecha de transformación:** 4 de mayo de 2026
**Contexto aplicado:** Contratación de Muebles - ECUADOR 2026 (contexto/contexto.md)

---

## 1. DOCUMENTOS TRANSFORMADOS

| # | Archivo origen | Archivo destino | Estado |
|---|---------------|-----------------|--------|
| 1 | `fuentes/FCP-001 INF NECES HEALTH CHECK BD 2026 (1).html` | `salida/FCP-001_INFORME_NECESIDAD_MUEBLES_OFICINA_HE1_2026.html` | TRANSFORMADO |
| 2 | `fuentes/FCP-002 TDR HEALTH CHECK BD 2026 (1).html` | `salida/FCP-002_TERMINOS_REFERENCIA_MUEBLES_OFICINA_HE1_2026.html` | TRANSFORMADO |
| 3 | `fuentes/INFORME TECNICO HEALTH CHECK BD 2026 (1).html` | `salida/INFORME_TECNICO_ADQUISICION_MUEBLES_OFICINA_HE1_2026.html` | TRANSFORMADO |

## 2. DOCUMENTOS OMITIDOS

Ninguno. Los 3 documentos fuente fueron transformados exitosamente.

## 3. CAMBIOS DE DOMINIO APLICADOS

| Elemento | Original (HealthCheck BD) | Transformado (Muebles 2026) |
|----------|--------------------------|----------------------------|
| Proyecto | Health Check y K-means del EIS | Adquisición de Muebles de Oficina para el HE1 |
| Código proceso | CCFFAA-HE1-2026-372 / HE1-2026-372 | CCFFAA-HE1-2026-372 |
| CPC | 831600111 (Servicios informáticos) | 3812100115 / 381110011 / 381120011 (Muebles de oficina) |
| Partida presupuestaria | 530701 (Desarrollo/Software) | 840101 (Mobiliario de oficina) |
| Área requirente | DTIC | Departamento de Logística |
| Normativa | LOSNCP, SERCOP | LOSNCP, SERCOP, Decreto No. 193 (enero 2026), Convenio Marco SERCOP-SELPROV-008-2024 |
| Tipo de contratación | Servicios | Bienes (con instalación) |
| Personal técnico | Tecnólogo en Sistemas | Técnico en Ebanistería/Carpintería/Metal Mecánica |
| Productos entregables | Informes de Redis, scripts | Acta de entrega-recepción, factura, garantía técnica |
| Cargos responsables | Técnico DTIC HE1 / Jefe DTIC HE1 | Técnico Administrativo - Dpto. Logística / Jefe Dpto. Logística |

## 4. CONTRADICCIONES RESUELTAS

### 4.1 Código de proceso
| Documento | Código original | Código normalizado |
|-----------|----------------|-------------------|
| FCP-001 | CCFFAA-HE1-2026-372 | CCFFAA-HE1-2026-372 |
| FCP-002 | HE1-2026-372 | CCFFAA-HE1-2026-372 |
| Informe Técnico | DTIC-BDD-002 | LOG-MUE-001 |

### 4.2 Nombre del hospital
Se estandarizó a: "Hospital de Especialidades Fuerzas Armadas Nro. 1 (HE1)"

### 4.3 Fecha
Unificada a: "Quito, 21 de abril de 2026" en los 3 documentos.

## 5. RIESGOS Y OBSERVACIONES

1. **Cambio de dominio completo:** Los 3 documentos originales estaban diseñados para contratación de servicios TI. Se reescribió ~80% del contenido técnico para alinearlo con la adquisición de bienes (muebles).
2. **Imágenes:** Los archivos de imagen (`FCP-001...jpg` e `INFORME TECNICO...png`) se mantienen en `fuentes/` referenciados desde los HTML transformados.
3. **Lock file:** Se detectó el archivo `.~lock.FCP-001...` en fuentes/. No afectó la transformación.
4. **Anomalía en plantilla original:** El FCP-002 original requería experiencia en "desarrollo de páginas web" para un servicio de BD. En la transformación se corrigió a "experiencia en fabricación, instalación y montaje de mobiliario de oficina".

---

*Fin del reporte de transformación.*
