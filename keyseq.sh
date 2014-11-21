#!/bin/bash

while true; do
	x=""
	while read -n1 -t0.001 key; do
		x="$x$key"
	done
	echo $x
	sleep 0.1
done
