#!/bin/bash
printf '#TAP %s\n' "$0"
. TAP/testcases.bash TAP "$@"
