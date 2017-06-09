sudo ns grid.tcl $1 $2 $3 $4
exec awk -f grid.awk A=$3 B=$4 grid.tr
