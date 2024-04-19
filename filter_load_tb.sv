`timescale 1ns/1fs

import SystemVerilogCSP::*;

module filter_load_tb;

// Set Channels
Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) load_start();
Channel #(.WIDTH(12),.hsProtocol(P4PhaseBD)) filter_addr();
Channel #(.WIDTH(8),.hsProtocol(P4PhaseBD)) filter_data();
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) out();

filter_loading fr(load_start,filter_addr,filter_data);
filter_load ff(load_start,filter_data,filter_addr,out);
data_bucket bb2(out);

initial begin
#1000000;
$finish;
end
endmodule

// Loading filter values form Text file module
module filter_loading(interface load_start,interface filter_addr, interface filter_data);

parameter WIDTH_data = 8;
parameter WIDTH_addr = 5;
parameter WIDTH_out_data = 13;
parameter DEPTH_F= 5;

logic [WIDTH_data-1:0] f_data;
logic [WIDTH_addr-1:0] f_addr=0;
integer fpi_f,status;
initial begin
	fpi_f = $fopen("filter.txt","r");
	if(fpi_f==0)begin
		$display("Can't open the file");
	end
	else begin
		load_start.Send(1);
		for(integer i=0; i<(DEPTH_F*DEPTH_F); i++) begin
			if(!$feof(fpi_f)) begin
				status = $fscanf(fpi_f,"%d\n", f_data);
				$display("filter data read:%d", f_data);
				filter_addr.Send(f_addr);
				filter_data.Send(f_data); 
				f_addr++;
			end 
		end
	end	
end
endmodule

// Data Bucket Module
module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 1; //ideal environment    backward delay
  logic [WIDTH-1:0] ReceiveValue ;
  
  //Variables added for performance measurements
  real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
	
	//add a display here to see when this module starts its main loop

    timeOfReceive = $time;
	
	//Communication action Receive is about to start
	$display("%m Data Bucket Starts Receiving data %t",$time );
    r.Receive(ReceiveValue);
	$display("%m Data Bucket Finishes Receiving data %t",$time );
	//Communication action Receive is finished
    
	#BL;
    cycleCounter += 1;		
    //Measuring throughput: calculate the number of Receives per unit of time  
    //CycleTime stores the time it takes from the begining to the end of the always block
    cycleTime = $time - timeOfReceive; // the difference of time between now and the last receive
    averageThroughput = cycleCounter/$time; 
    sumOfCycleTimes += cycleTime;
    averageCycleTime = sumOfCycleTimes / cycleCounter;
    $display("Execution cycle= %d, Cycle Time= %d, Average CycleTime=%f, Average Throughput=%f \n", cycleCounter, cycleTime, averageCycleTime, averageThroughput);
	
	
  end

endmodule	