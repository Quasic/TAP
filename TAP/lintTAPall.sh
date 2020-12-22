#!/bin/bash
shopt -s nullglob globstar
bash "$(dirname "${BASH_SOURCE[0]}")/lint.sh" ./**/*
