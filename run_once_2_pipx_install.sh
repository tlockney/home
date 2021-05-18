#!/usr/bin/env bash

PIPX=$(which pipx)

if [[ -x "$PIPX" ]]; then
    $PIPX install --force jupyterlab || true
    $PIPX inject jupyterlab requests pandas numpy matplotlib
    $PIPX inject --include-apps jupyterlab notebook
    $PIPX install --force ptpython || true
    $PIPX install --force pygments || true
    $PIPX install --force httpie || true
else
    echo "ERROR: pipx not found!"
fi