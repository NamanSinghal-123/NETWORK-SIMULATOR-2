set ns [new Simulator]
set tracefile [open 2.tr w]
$ns trace-all $tracefile

set namfile [open 2.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n2 $n1 2Mb 10ms DropTail
$ns duplex-link $n3 $n1 2Mb 10ms DropTail


set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp


set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n2 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp

$ns at 1.0 "$cbr0 start"
$ns at 0.5 "$ftp start"
$ns at 4.5 "finish"

proc finish {} {
  global ns tracefile namfile
  $ns flush-trace 
  close $tracefile
  close $namfile
  exec nam 2.nam 
  exit 0
  }
  puts "running"
  
$ns run



