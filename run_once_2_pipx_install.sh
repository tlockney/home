#!/usr/bin/env bash

PIPX=$(which pipx)

if [[ -x "$PIPX" ]]; then
    $PIPX install ipython || true
    $PIPX install ptpython || true
    $PIPX install pygments || true
else
    echo "ERROR: pipx not found!"
fi