#!/usr/bin/env bash

PIPX=$(which pipx)

if [[ -x "$PIPX" ]]; then
    $PIPX install --force ipython || true
    $PIPX install --force ptpython || true
    $PIPX install --force pygments || true
    $PIPX install --force httpie || true
else
    echo "ERROR: pipx not found!"
fi