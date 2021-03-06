#!/usr/bin/env bash

PIPX=$(which pipx)

if [[ -x "$PIPX" ]]; then
    $PIPX install ipython || true
    $PIPX install ptpython || true
    $PIPX install pygments || true
    $PIPX install httpie || true
else
    echo "ERROR: pipx not found!"
fi