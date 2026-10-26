#!/usr/bin/env bash
# Crea un par de claves para firmar módulos y pide registrarlo en la MOK (Parte 3).
#
#   ./scripts/crear-clave.sh            # claves en ~/mok
#   MOK_DIR=/otra/ruta ./scripts/crear-clave.sh
#
# Después de correrlo hay que REINICIAR y completar el MOK Manager (pantalla azul).
set -euo pipefail

MOK_DIR=${MOK_DIR:-$HOME/mok}
mkdir -p "$MOK_DIR"
chmod 700 "$MOK_DIR"

if [[ -e $MOK_DIR/MOK.priv ]]; then
    echo "Ya existe $MOK_DIR/MOK.priv: no la piso. Borrala a mano si querés otra." >&2
    exit 1
fi

openssl req -new -x509 -newkey rsa:2048 -nodes -days 36500 -sha256 \
    -subj "/CN=SdeC TP4 $(hostname) module signing key/" \
    -addext "extendedKeyUsage=codeSigning" \
    -keyout "$MOK_DIR/MOK.priv" -outform DER -out "$MOK_DIR/MOK.der"
chmod 600 "$MOK_DIR/MOK.priv"

echo
echo "Clave privada:  $MOK_DIR/MOK.priv  (NO se sube al repo ni se comparte)"
echo "Certificado:    $MOK_DIR/MOK.der   (la parte pública)"
echo
echo "Ahora mokutil va a pedir una contraseña de un solo uso: anotala,"
echo "la vas a escribir en el MOK Manager al reiniciar."
sudo mokutil --import "$MOK_DIR/MOK.der"
echo
echo "Listo. Reiniciá y en la pantalla azul: Enroll MOK -> Continue -> Yes -> contraseña -> Reboot."
