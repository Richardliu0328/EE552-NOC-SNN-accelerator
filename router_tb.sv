`timescale 1ns/1fs

import SystemVerilogCSP::*;

module router_tb;
//Total 10 ports for router in and out
Channel #(.WIDTH(32),.hsProtocol(P4PhaseBD)) N_in(),N_out(), E_in(), E_out(), W_in(), W_out(), S_in(),S_out(), PE_in(), PE_out();
/*
data_generator gen0(N_in);
data_generator gen1(E_in);
data_generator gen2(W_in);
data_generator gen3(S_in);
data_generator gen4(PE_in);
*/
router RR(N_in,N_out,E_in, E_out, W_in,W_out, S_in, S_out,PE_in,PE_out);
data_bucket bb1(N_out);
data_bucket bb2(E_out);
data_bucket bb3(W_out);
data_bucket bb4(S_out);
data_bucket bb5(PE_out);

initial begin
		//PE
		N_in.Send(32'h00123456);
		#5;
		E_in.Send(32'h00234567);
		W_in.Send(32'h00345678);
		#5;
		S_in.Send(32'h00456789);
		#5;
		//North out
		E_in.Send(32'hAB234567);
		W_in.Send(32'h67345678);
		#5;
		S_in.Send(32'hef456789);
		#5;
		PE_in.Send(32'h23567890);
		#5;
		//East out
		N_in.Send(32'h8c123456);
		#5;
		W_in.Send(32'h9d345678);
		#5;
		S_in.Send(32'h6a456789);
		#5;
		PE_in.Send(32'hbf567890);
		//West out
		N_in.Send(32'hc8123456);
		#5;
		E_in.Send(32'hd9234567);
		#5;
		S_in.Send(32'ha6456789);
		#5;
		PE_in.Send(32'hfb567890);
		//South
		N_in.Send(32'hba123456);
		#5;
		E_in.Send(32'h76234567);
		W_in.Send(32'hfe345678);
		#5;
		PE_in.Send(32'h32567890);
		#5;
		//random
		N_in.Send(32'h0e123456);
		#5;
		E_in.Send(32'he0234567);
		W_in.Send(32'h0b345678);
		#5;
		S_in.Send(32'hf0456789);
		#5;
		PE_in.Send(32'h7c567890);
		#5;
	end	

endmodule

module data_generator (interface r);
  parameter WIDTH = 8;
  parameter FL = 2; //ideal environment   forward delay
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