#!/usr/bin/env bash
SCRIPT_PATH="$(dirname "${BASH_SOURCE[0]}")"

${EMACS:-emacs} \
    -batch \
    -l "$SCRIPT_PATH/shift-number-tests.el" \
    -f ert-run-tests-batch-and-exit
