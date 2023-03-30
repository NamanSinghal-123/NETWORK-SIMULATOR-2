set ns [new Simulator]
set tracefile [open 3.tr w]
$ns trace-all $tracefile

set namfile [open 3.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n0 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$tcp set packetSize_ 1500

set filesize [expr 10*1024*1024]

$ns at 0.1 "$ftp send $filesize"
$ns at 50.0 "finish"

proc finish {} {
  global ns tracefile namfile
  $ns flush-trace 
  close $tracefile
  close $namfile
  exec nam 3.nam 
  exit 0
}
  puts "running"
$ns run
