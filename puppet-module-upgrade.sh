#!/bin/bash
/opt/puppetlabs/bin/puppet module list | grep -Po "(?<="$'\xe2\x94\x80'" )[^ ]+(?= )" | while read line; do
	/opt/puppetlabs/bin/puppet module upgrade $line
done
