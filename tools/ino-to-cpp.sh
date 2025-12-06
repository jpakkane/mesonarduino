#!/bin/sh

echo "#include <Arduino.h>"
echo
if [ $# -gt 0 ] ; then
    cat "$@"
fi
