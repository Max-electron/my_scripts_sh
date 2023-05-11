#!/bin/bash

Y=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
X=0.25
Z=$Y*$X
prcs=0
W=$(printf '%.*f\n' "${prcs}" "$(bc -l <<< "a=$Z; a+=5/10^(${prcs}+1); scale=${prcs}; a/1")")
MEM=$(($W/1024))
echo $MEM
psql -c "alter system set shared_buffers = '${MEM}MB';"
X=0.75
Z=$Y*$X
prcs=0
W=$(printf '%.*f\n' "${prcs}" "$(bc -l <<< "a=$Z; a+=5/10^(${prcs}+1); scale=${prcs}; a/1")")
MEM=$(($W/1024))
psql -c "alter system set effective_cache_size = '${MEM}MB';"
echo $(psql -c "show shared_buffers;")
echo $(psql -c "show effective_cache_size;")