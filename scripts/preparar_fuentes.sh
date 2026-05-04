#!/usr/bin/env bash
set -euo pipefail

ORIGEN="${1:-fuentes}"
DESTINO="${2:-fuentes_convertidas}"

mkdir -p "$DESTINO"

echo "Convirtiendo documentos desde: $ORIGEN"
echo "Salida HTML en: $DESTINO"

find "$ORIGEN" -type f ! -name ".*" | while read -r archivo; do
  nombre="$(basename "$archivo")"
  base="${nombre%.*}"
  ext="${nombre##*.}"

  case "${ext,,}" in
    docx)
      echo "DOCX -> HTML: $archivo"
      pandoc "$archivo" -t html5 --wrap=none -o "$DESTINO/$base.html" || {
        echo "ERROR convirtiendo $archivo" >> "$DESTINO/CONVERSION_ERRORES.md"
      }
      ;;

    xlsx)
      echo "XLSX -> HTML: $archivo"
      python3 - "$archivo" "$DESTINO/$base.html" <<'PY'
import sys, pandas as pd

src, dst = sys.argv[1], sys.argv[2]
try:
    sheets = pd.read_excel(src, sheet_name=None)
    with open(dst, "w", encoding="utf-8") as out:
        out.write("<html><body>\n")
        for name, df in sheets.items():
            out.write(f"<h2>Hoja: {name}</h2>\n")
            out.write(df.to_html(index=False))
        out.write("</body></html>\n")
except Exception as e:
    with open(dst + ".error.txt", "w", encoding="utf-8") as err:
        err.write(str(e))
PY
      ;;

    html|htm)
      echo "HTML -> copia directa: $archivo"
      cp "$archivo" "$DESTINO/$nombre"
      ;;

    md|txt|csv)
      echo "Texto plano -> copia directa: $archivo"
      cp "$archivo" "$DESTINO/$nombre"
      ;;

    *)
      echo "Formato no soportado: $archivo" >> "$DESTINO/CONVERSION_ERRORES.md"
      ;;
  esac
done

echo "Conversión terminada."
