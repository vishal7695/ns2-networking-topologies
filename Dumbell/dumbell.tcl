set ns [new Simulator]
$ns rtproto DV
set nf [open dumbell.nam w]
$ns namtrace-all $nf
set nftr [open dumbell.tr w]
$ns trace-all $nftr
proc finish {} {
        global ns nf nftr
        $ns flush-trace
        close $nf
        exec nam dumbell.nam &
        exit 0
}
for {set i 0} {$i < 14} {incr i} {
        set n($i) [$ns node]
}
for {set i 1} {$i < 7} {incr i} {
        $ns duplex-link $n(0) $n($i) 1Mb 10ms DropTail
}
$ns duplex-link $n(6) $n(13) 1Mb 10ms DropTail
for {set i 8} {$i < 14} {incr i} {
        $ns duplex-link $n(7) $n($i) 1Mb 10ms DropTail
}
set udp0 [new Agent/UDP]
$ns attach-agent $n(1) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set null0 [new Agent/Null]
$ns attach-agent $n(11) $null0
$ns connect $udp0 $null0  
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
