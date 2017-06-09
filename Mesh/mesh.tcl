set ns [new Simulator]
$ns rtproto DV
set nf [open mesh.nam w]
$ns namtrace-all $nf
set nftr [open mesh.tr w]
$ns trace-all $nftr
proc finish {} {
        global ns nf nftr
        $ns flush-trace
        close $nf
        exec nam mesh.nam &
        exit 0
}
set var [lindex $argv 0]
set var1 [lindex $argv 1]
set var2 [lindex $argv 2]
for {set i 0} {$i < $var} {incr i} {
        set n($i) [$ns node]
}
for {set i 0} {$i < $var} {incr i} {
        for {set j 0} {$j < $var} {incr j} {
       if {$i<$j||$i>$j} {
      $ns duplex-link $n($j) $n($i) 1Mb 10ms DropTail
}
}
}
set udp0 [new Agent/UDP]
$ns attach-agent $n([expr ($var1-1)]) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set null0 [new Agent/Null]
$ns attach-agent $n([expr ($var2-1)]) $null0
$ns connect $udp0 $null0  
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
