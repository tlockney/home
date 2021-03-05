#!/usr/bin/env bash

PIPX=$(which pipx)

PACKAGES=$(cat <<EOF
    ipython
    ptpython
    pygments
EOF
)

if [[ -x "$PIPX" ]]; then
    $PIPX install ipython || true
else
    echo "ERROR: pipx not found!"
fi