#!/usr/bin/env bash
# Firma uno o más módulos con la clave creada por crear-clave.sh (Parte 3).
#
#   ./scripts/firmar.sh part1/module/mimodulo.ko
#   MOK_DIR=/otra/ruta ./scripts/firmar.sh modulo.ko
#
# Hay que volver a firmar cada vez que se recompila: `make` genera un .ko nuevo sin firma.
set -euo pipefail

MOK_DIR=${MOK_DIR:-$HOME/mok}
SIGN_FILE=/lib/modules/$(uname -r)/build/scripts/sign-file

if [[ $# -eq 0 ]]; then
    echo "uso: $0 modulo.ko [otro.ko ...]" >&2
    exit 1
fi
for f in "$MOK_DIR/MOK.priv" "$MOK_DIR/MOK.der" "$SIGN_FILE"; do
    [[ -e $f ]] || { echo "No existe $f (¿corriste crear-clave.sh? ¿están los headers?)" >&2; exit 1; }
done

for ko in "$@"; do
    # MOK.priv tiene permisos 600, por eso sign-file corre con sudo
    sudo "$SIGN_FILE" sha256 "$MOK_DIR/MOK.priv" "$MOK_DIR/MOK.der" "$ko"
    echo "== $ko"
    modinfo "$ko" | grep -E '^(signer|sig_key|sig_hashalgo):' || echo "(sin firma)"
done
