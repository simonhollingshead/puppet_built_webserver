#!/bin/bash

EST_ERROR=$(ntpq -c kerninfo | grep "estimated error" | cut -d: -f2 | xargs)
echo "Estimated Error: ${EST_ERROR} seconds."

exit $(echo "${EST_ERROR} > $1" | bc -l)
