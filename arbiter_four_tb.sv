`timescale 1ns/1fs

import SystemVerilogCSP::*;

module arbiter_four_tb;

Channel #(.WIDTH(32),.hsProtocol(P4PhaseBD))  in0(), in1(), in2(), in3(), out();

arbiter_four aa(in0,in1,in2,in3, out);
data_bucket bb1(out);

initial begin
in0.Send(32'h12344566);in1.Send(32'h12344567);#2 in2.Send(32'h12344568);in3.Send(32'h12344569);
in0.Send(32'h12344166); #2 in1.Send(32'h12344767); in2.Send(32'h12344168);  in3.Send(32'h12340569);

in0.Send(32'h12344560); in1.Send(32'h02344567);#1 in2.Send(32'h12344068);   in3.Send(32'h10344569);
#10;
end

endmodule

module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment    backward delay
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