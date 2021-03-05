#!/usr/bin/env sh

PIPX=$(which pipx)

if [[ -x "$PIPX" ]]; then
    $PIPX install ipython
else
    echo "ERROR: pipx not found!"
fi