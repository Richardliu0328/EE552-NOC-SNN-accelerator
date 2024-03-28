`timescale 1ns/1fs
import SystemVerilogCSP::*;

module merge_5_tb;
Channel #(.WIDTH(32),.hsProtocol(P4PhaseBD)) in0(),in1(),in2(),in3(),in4(),out();
Channel #(.WIDTH(3),.hsProtocol(P4PhaseBD)) sel();

data_generator gen0(in0);
data_generator gen1(in1);
data_generator gen2(in2);
data_generator gen3(in3);
data_generator gen4(in4);
data_generator gen5(sel);
merge_5 MM(sel,in0,in1,in2,in3,in4,out);
data_bucket BB(out);

initial begin
#500;
$stop;
end
endmodule

module data_generator (interface r);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment   forward delay
  logic [WIDTH-1:0] SendValue;
  always
  begin 
    
	//add a display here to see when this module starts its main loop
	$display("%m Data Generator Starts sending data %t",$time );
	$display("%m Data Generator Finishes sending data %t",$time );
    SendValue = $random() % (2**WIDTH); // the range of random number is from 0 to 2^WIDTH
    #FL;   // change FL and check the change of performance
     
    //Communication action Send is about to start
    r.Send(SendValue);
    //Communication action Send is finished
	

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
	
