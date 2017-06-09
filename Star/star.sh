sudo ns star.tcl $1 $2 $3 $4
exec gawk -f star.awk A=$3 B=$4 star.tr
