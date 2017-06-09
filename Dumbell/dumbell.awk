BEGIN {
	seqno = -1; 
	droppedPackets = 1;
	sentPackets = 1;
	receivedPackets = 1;
	count = 1;
	recvdSize = 0
	startTime = 1
	stopTime = 0
	sent=0
	receive=0
	highest_packet_id = 0;
	delayx = avg_delay = 0
}
{
	if($12>0)
		seqno=$12 ;
	if ($1 == "+"&& $3=="1" && $5=="cbr"){ 
		sentPackets++;
	} 
	else if ($1 == "r" && $4=="11" && $5=="cbr"){ 
		receivedPackets++;
	} 
	else if ($1 == "d "&& $4=="11" && $5=="cbr"){
		droppedPackets++; 
	}
	pkt_size = $6
	time = $2
	if ($1 == "+" && $5 == "cbr") {
		sent++	
		if (time < startTime) {
			startTime = time
		}
	}
	if ($1 == "r" && $4=="11" && $5 == "cbr") {
		receive++
		if (time > stopTime) {
			stopTime = time
		}
		recvdSize += pkt_size
	}
	if ($2 != "-t") {
		event = $1
		time = $2
		if (event == "+" || event == "-") node_id = $3
		if (event == "r" || event == "d") node_id = $4
		flow_id = $8
		pkt_id = $12
	}



	# Store packets send time
	if (flow_id == 0 && node_id == $3 && sendd[pkt_id] == 0 && (event == "+" || event == "s")) {
		sendd[pkt_id] = time
	}
	# Store packets arrival time
	if (flow_id == 0 && node_id == $4 && event == "r") {
		recvd[pkt_id] = time
	}
}
END { 
	for(i=0; i<=seqno; i++) {
		if(end_time[i] > 0) {
			delay[i] = end_time[i] - start_time[i];
			count++;
			}
		else{
			delay[i] = -1;
		}
	}
	for(i=0; i<count; i++) {
		if(delay[i] > 0) {
			n_to_n_delay = n_to_n_delay + delay[i];
		} 
	}
	n_to_n_delay = n_to_n_delay/count;
	print "\n";
	print "\n\t\tGenerated Packets = " seqno+1;
	print "\n\n\t\tSent Packets = " sentPackets;
	print "\n\n\t\tReceived Packets = " receivedPackets;
	print "\n\n\t\tPacket Delivery Ratio = " receivedPackets/sentPackets*100 "%";
	print "\n\n\t\tTotal Dropped Packets = " droppedPackets;
	printf("\n\n\t\tAverage Throughput[kbps] = %.2f\n\n\n\t\tStartTime=%.2f\n\n\n\t\tStopTime = %.2f\n", (recvdSize/(stopTime-startTime))*  (8/1000),startTime,stopTime);
	for (i in recvd) {
		if (sendd[i] == 0) {
			printf("\nErrorwerr %g\n",i)
		}
		delayx += recvd[i] - sendd[i]
		num ++
	}

	if (num != 0) {
	avg_delay = delayx / num
	} else {
	avg_delay = 0
	}
	printf("\n\n\t\tLatency=%f\n",avg_delay*1000)
	print "\n";
}
