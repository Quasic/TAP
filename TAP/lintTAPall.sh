#!/bin/bash
# gives lint.sh all files/subdirectories recursively
# By Quasic
# Report bugs to https://github.com/Quasic/TAP/issues
# Released under Creative Commons Attribution (BY) 4.0 license
printf '%s\n' "${BASH_SOURCE[0]} 0.2"
shopt -s nullglob globstar
#shellcheck source=TAP/lint.sh
source "$(dirname "${BASH_SOURCE[0]}")/lint.sh" ./**/*
