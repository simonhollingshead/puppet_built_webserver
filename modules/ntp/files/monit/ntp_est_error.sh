#!/bin/bash

EST_ERROR=$(ntpq -c kerninfo | grep "estimated error" | cut -d: -f2 | xargs)
echo "Estimated Error: ${EST_ERROR} seconds."

EST_ERROR=$(echo "${EST_ERROR}" | sed "s|e-|*10^|g")
exit $(echo "(${EST_ERROR}) > (${1:-1})" | bc -l)
