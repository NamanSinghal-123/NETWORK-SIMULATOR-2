set ns [new Simulator]
set tracefile [open 1.tr w]
$ns trace-all $tracefile

set namfile [open 1.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 5Mb 2ms DropTail

set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n1 $null
$ns connect $udp $null


set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp
set sim_end 5.0
$ns at 0.5 "$cbr0 start"
$ns at $sim_end "$cbr0 stop"
$ns at $sim_end "finish"

proc finish {} {
    global ns tracefile namfile 
    $ns flush-trace
    # stop the simulation and print out results
    #$ns halt
    close $tracefile
    close $namfile
    exec nam 1.nam
    exit 0 
    #puts "simulation finished at $sim_end"
}
puts "running"
$ns run
