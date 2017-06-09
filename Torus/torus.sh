sudo ns torus.tcl $1 $2 $3 $4
exec awk -f torus.awk A=$3 B=$4 torus.tr
