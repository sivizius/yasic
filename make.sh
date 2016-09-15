#!/bin/bash

../build/bin/fasm "yasic.fasm" "../build/lib/yasic" 2>&1 | tee "../build/out/yasic.log"
