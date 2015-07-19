# Ashik Kapadiya - 131005
# lab assignment-1, computer network

# problem statement: setup udp connections between node 1 to 10 and 8 to 0, ftp connection between node 2 to 7.


# Create a simulator object
set ns [new Simulator]

# Open the trace file and win file
set tracefile1 [open out.tr w]
set winfile [open winfile w]
$ns trace-all $tracefile1

# Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Define a 'finish' procedure
proc finish {} \
{
global ns tracefile1 namfile
$ns flush-trace
close $tracefile1
close $namfile
exec nam out.nam &
exit 0
}

# setting nodes and define color and shapes
$ns color 1 Blue
$ns color 2 red
$ns color 3 green
set n0 [ $ns node ]
$n0 color "blue"
$n0 shape box
set n1 [ $ns node ]
$n1 color "red"
$n1 shape square
set n2 [ $ns node ]
$n2 color "green"
$n2 shape square
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]
set n6 [ $ns node ]
set n7 [ $ns node ]
$n7 color "green"
$n7 shape box
set n8 [ $ns node ]
$n8 color "blue"
$n8 shape square
set n9 [ $ns node ]
set n10 [ $ns node ]
$n10 color "red"
$n10 shape box

# set linkeges between nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns simplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n4 $n6 2Mb 10ms DropTail
$ns duplex-link $n5 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
$ns duplex-link $n6 $n8 2Mb 10ms DropTail
$ns duplex-link $n9 $n10 2Mb 10ms DropTail

set lan [$ns newLan "$n2 $n4 $n9" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

# orientation: setting position of nodes
$ns duplex-link-op $n0 $n1 orient down
$ns duplex-link-op $n0 $n3 orient right
$ns simplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient up
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down
$ns duplex-link-op $n5 $n6 orient down
$ns duplex-link-op $n6 $n7 orient left-down
$ns duplex-link-op $n6 $n8 orient right-down
$ns duplex-link-op $n9 $n10 orient right

# Setup a UDP connection between node 1 to 10
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null [new Agent/Null]
$ns attach-agent $n10 $null
$ns connect $udp1 $null
$udp1 set fid_ 2

# Setup a CBR over UDP 
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1mb
$cbr1 set random_ false


#Setup a UDP connection between node 8 to 0
set udp2 [new Agent/UDP]
$ns attach-agent $n8 $udp2
set null [new Agent/Null]
$ns attach-agent $n0 $null
$ns connect $udp2 $null
$udp2 set fid_ 3

#Setup a CBR over UDP 
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb
$cbr2 set random_ false


#Setup a TCP connection between node 2 to 7
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n2 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n7 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP 
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#set when connection start and stop
$ns at 0.1 "$cbr1 start"
$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr2 start"
$ns at 4.2 "$cbr2 stop"
$ns at 4.5 "$ftp stop"
$ns at 4.9 "$cbr1 stop"

# finish procedure after 5 seconds of simulation 
$ns at 5.0 "finish"
$ns run
