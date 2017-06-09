set ns [new Simulator]
$ns rtproto DV
set nf [open star.nam w]
$ns namtrace-all $nf
set nftr [open star.tr w]
$ns trace-all $nftr
proc finish {} {
        global ns nf nftr
        $ns flush-trace
        close $nf
        exec nam star.nam &
        exit 0
}
set var [lindex $argv 0]
set var1 [lindex $argv 1]
set var2 [lindex $argv 2]
set var3 [lindex $argv 3]
for {set i 0} {$i < $var} {incr i} {
        set n($i) [$ns node]
}
for {set i 0} {$i < $var} {incr i} {
        if {$i<$var1||$i>$var1} {
        $ns duplex-link $n($var1) $n($i) 1Mb 10ms DropTail
}
}
set udp0 [new Agent/UDP]
$ns attach-agent $n($var2) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set null0 [new Agent/Null]
$ns attach-agent $n($var3) $null0
$ns connect $udp0 $null0  
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
