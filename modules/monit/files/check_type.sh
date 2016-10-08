#!/bin/bash

TYPE=$(file $1)
TYPE=${TYPE#*: }
echo "$TYPE"
grep -q "$2" <(echo "$TYPE")
