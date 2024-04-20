`timescale 1ns/1fs

import SystemVerilogCSP::*;

module ifm_load_tb;//(interface ifmap_data, interface ifmap_addr, interface timestep,interface load_done);

// Set Channels
Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) load_done();
Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) ts();
Channel #(.WIDTH(12),.hsProtocol(P4PhaseBD)) ifmap_addr();
Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) ifmap_data();
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) packet(),out();

integer i;
ifm_loading ll(ts,ifmap_addr, ifmap_data, load_done);
ifp_load ff(ts,ifmap_data,ifmap_addr,load_done,packet,out);
data_bucket bb(out);

initial begin
wait(load_done.data==1);
	for(i=0;i<505;i++)begin
		packet.Send(35'b00000000000000000000000000000011111);
		#10;
	end
end
endmodule

module ifm_loading(interface timestep, interface ifmap_addr, interface ifmap_data, interface load_done);

parameter WIDTH_data = 8;
parameter WIDTH_addr = 12;
parameter WIDTH_out_data = 13;
parameter DEPTH_F= 5;
parameter DEPTH_I =32;
logic [1:0] tss=1;
logic i1_data, i2_data;
logic [WIDTH_addr-1:0] i1_addr = 0, i2_addr=0;
integer  fpi_i1, fpi_i2,fpt,status;

always begin
//Open Text File
fpi_i1 = $fopen("ifmap1.txt","r");
fpi_i2 = $fopen("ifmap2.txt", "r");
if(!fpi_i1|!fpi_i2)begin
	$display("Can't open file");
end	
// sending ifmap 1 (timestep1)
	for(integer i=0; i<DEPTH_I*DEPTH_I; i++) begin
	    if (!$feof(fpi_i1)) begin
	     status = $fscanf(fpi_i1,"%d\n", i1_data);
	     $display("Ifmap1 data read:%d", i1_data);
     		timestep.Send(tss);
	     ifmap_addr.Send(i1_addr);
	     ifmap_data.Send(i1_data);

	     i1_addr++;
	 end end

	tss++;

// sending ifmap 2 (timestep2)

	for(integer i=0; i<DEPTH_I*DEPTH_I; i++) begin
	    if (!$feof(fpi_i2)) begin
	     status = $fscanf(fpi_i2,"%d\n", i2_data);
	     $display("Ifmap2 data read:%d", i2_data);
	     timestep.Send(tss);
	     ifmap_addr.Send(i2_addr);
	     ifmap_data.Send(i2_data);

	     i2_addr++;
	 end end

//Finish sending the matrix values
  load_done.Send(1); 
  $fdisplay(fpt,"%m sent load_done token at %t",$realtime);
  $display("%m sent load_done token at %t",$realtime);
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