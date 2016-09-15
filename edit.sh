#!/bin/bash

if [[ -d "src/yasic" ]]; then cd "src/yasic"; fi
line="libs/yasic.fobj libs/yasic.flib sba.sh yasic.fasm "
if [ "$(ls -A 'code')" ]; then line="$line code/*"; fi
if [ "$(ls -A 'data')" ]; then line="$line data/*"; fi
#if [ "$(ls -A 'misc')" ]; then line="$line misc/*"; fi
if [ "$(ls -A 'resv')" ]; then line="$line resv/*"; fi
if [ "$(ls -A 'stat')" ]; then line="$line stat/*"; fi
if [ "$(ls -A 'text')" ]; then line="$line text/*"; fi
editor $line
