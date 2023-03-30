set ns [new Simulator]
set tracefile [open 4.tr w]
$ns trace-all $tracefile

set namfile [open 4.nam w]
$ns namtrace-all $namfile


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n4 5Mb 5ms DropTail
$ns duplex-link $n1 $n4 5Mb 5ms DropTail
$ns duplex-link $n2 $n4 5Mb 5ms DropTail
$ns duplex-link $n3 $n4 5Mb 5ms DropTail

set udp [new Agent/UDP]
set null [new Agent/UDP]
$ns attach-agent $n1 $udp
$ns attach-agent $n2 $null

$ns connect $udp $null

set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 1.0 "$cbr start"
$ns at 1.0 "$ftp start"
#stopping the traffic
$ns at 10.0 "finish"

proc finish {} {
    global ns tracefile namfile 
    $ns flush-trace
   
    close $tracefile
    close $namfile
    exec nam 4.nam
    exit 0 
    #puts "simulation finished at $sim_end"
}
puts "running"
$ns run
