#!/usr/bin/env bash
# Guarda los módulos cargados y los disponibles de esta máquina en salidas/ (pregunta 2 y 3).
# Cada integrante lo corre en su PC y sube los .txt al repo; después se comparan con diff.
#
#   ./scripts/modulos.sh                 # usa el hostname
#   ./scripts/modulos.sh nico            # o un nombre a elección
set -euo pipefail

# Orden por bytes: sin esto, en un Ubuntu en español comm se queja del orden y el diff
# con las salidas de otra máquina da diferencias falsas
export LC_ALL=C

NOMBRE=${1:-$(hostname)}
DIR=$(dirname "$0")/../salidas
mkdir -p "$DIR"
KVER=$(uname -r)

# Cargados: solo los nombres, ordenados, para que el diff compare nombre contra nombre
lsmod | tail -n +2 | awk '{print $1}' | sort > "$DIR/cargados-$NOMBRE.txt"

# Disponibles: todo .ko (comprimido o no) del kernel en uso, con el nombre normalizado
find "/lib/modules/$KVER" -name '*.ko*' -printf '%f\n' \
    | sed -E 's/\.ko(\.(zst|xz|gz))?$//; s/-/_/g' | sort -u > "$DIR/disponibles-$NOMBRE.txt"

# Disponibles pero no cargados
comm -23 "$DIR/disponibles-$NOMBRE.txt" "$DIR/cargados-$NOMBRE.txt" \
    > "$DIR/no-cargados-$NOMBRE.txt"

{
    echo "Equipo:       $(hostname)"
    echo "Kernel:       $KVER"
    echo "Cargados:     $(wc -l < "$DIR/cargados-$NOMBRE.txt")"
    echo "Disponibles:  $(wc -l < "$DIR/disponibles-$NOMBRE.txt")"
    echo "No cargados:  $(wc -l < "$DIR/no-cargados-$NOMBRE.txt")"
} | tee "$DIR/resumen-$NOMBRE.txt"

echo
echo "Archivos en $(realpath "$DIR"). Para comparar con un compañero:"
echo "  diff salidas/cargados-$NOMBRE.txt salidas/cargados-<otro>.txt"
