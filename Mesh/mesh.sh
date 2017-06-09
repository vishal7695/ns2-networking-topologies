sudo ns mesh.tcl $1 $2 $3
exec awk -f mesh.awk A=$2 B=$3 mesh.tr
