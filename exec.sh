#!/bin/bash

read -p "execute yasic? " yn
case "$yn" in
  ""|"y"|"Y"|"j"|"J"|"yes"|"ja")
    ../build/bin/yalave.elf "../build/bin/yasic.sba" 2>&1 | tee -a "../build/out/yasic.log"
  ;;
esac