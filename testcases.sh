#!/bin/bash
# merely redirects to TAP/testcases.bash
# By Quasic
# Report bugs to https://github.com/Quasic/TAP/issues
# Released under Creative Commons Attribution (BY) 4.0 license
printf '%s\n' "${BASH_SOURCE[0]} 0.1"
. TAP/testcases.bash TAP "$@"
