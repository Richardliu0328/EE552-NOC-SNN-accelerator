`timescale 1ns/1fs

import SystemVerilogCSP::*;


module de_test;


Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) in(),out();

logic [34:0]in_data;
logic [34:0]out_data;
depacket_controller ctr(in.req,in.ack,out.req,out.ack,in_data,out_data);
data_bucket bb(out);


always @ (in.data) begin

in_data<= in.data;
in_data<= ~in.data0;
in_data<= in.data1;
end
always @ (out_data) begin

out.data <= out_data;;
out.data0 <= ~out_data;;
out.data1 <= out_data;;
end


initial begin
	in.Send(35'b00000000000000000000000000000001111);
	#20;
	in.Send(35'b00000000001000000000000000000000111);
	#20;
	in.Send(35'b00000000000000000000000000000010111);
	#20;
	in.Send(35'b00000000001000000000000000000001100);
	#20;
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
  always begin
	
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

