`timescale 1ns/100ps
import SystemVerilogCSP::*;

integer fp, fp1;

  module data_test (interface r);
  parameter WIDTH = 8;
  parameter data = 0;
  parameter FL = 0; //ideal environment   forward delay
  logic [WIDTH-1:0] SendValue;
  
  always
  begin
	$display("\n\n");  
    $display( "%m The starting time is: %t\n", $time);
	//add a display here to see when this module starts its main loop
	
    SendValue = data; 
    #FL;   // change FL and check the change of performance
     
    //Communication action Send is about to start
	$display("Start sending in module %m. Simulation time = %t\n", $time);
    r.Send(SendValue);
	$display("Finished sending in module %m. Simulation time = %t\n", $time);
    //Communication action Send is finished
	$fmonitor(fp,  "%m %t\t, Send value: %h\n", $time, SendValue);
	end
endmodule

module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment    backward delay
  logic [WIDTH-1:0] ReceiveValue = 0;
  
  //Variables added for performance measurements
  real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
	$display("\n\n");
	$display( "%m The starting time is : %t\n", $time);
	//add a display here to see when this module starts its main loop

    timeOfReceive = $time;
	
	//Communication action Receive is about to start
	$display("Start receiving in module %m. Simulation time = %t\n", $time);
    r.Receive(ReceiveValue);
	$display("Finished receiving in module %m. Simulation time = %t\n", $time);
	//Communication action Receive is finished
    
	#BL;
    cycleCounter += 1;		
    
  end

endmodule

module ofm_loading(interface load_start, interface ofm_data);

parameter WIDTH=35;
//parameter WIDTH_addr = 5;
//parameter WIDTH_out_data = 13;
parameter DEPTH_F= 28;
parameter sum_adder_addr1=4'b0000;
parameter sum_adder_addr2=4'b0100;
parameter sum_adder_addr3=4'b1000;

logic [WIDTH-1:0]packet_out;
logic o_data;
integer fpi_o,status;
initial begin
	fpi_o = $fopen("out_spike1.txt","r");
	if(fpi_o==0)begin
		$display("Can't open the file");
	end
	else begin
		load_start.Send(1);
		for(integer i=0; i<(DEPTH_F*DEPTH_F); i++) begin
			if(!$feof(fpi_o)) begin
				status = $fscanf(fpi_o,"%d\n", o_data);
				$display("ofm data read:%d", o_data);
				if(o_data==0)begin
				packet_out={sum_adder_addr1,4'b0000,2'b00,25'b000000000000000000000000};
				ofm_data.Send(packet_out);
				end	
				if(o_data==1)begin
				packet_out={sum_adder_addr1,4'b0000,2'b11,25'b000000000000000000000000};
				ofm_data.Send(packet_out);
				end	
			end 
		end
	end	
end
endmodule

module res_loading(interface load_start, interface res_data);

parameter WIDTH_data = 8;
//parameter WIDTH_addr = 5;
//parameter WIDTH_out_data = 13;
parameter DEPTH_F= 28;

logic [WIDTH_data-1:0] r_data;
integer fpi_f,status;
initial begin
	fpi_f = $fopen("out_residue1.txt","r");
	if(fpi_f==0)begin
		$display("Can't open the file");
	end
	else begin
		load_start.Send(1);
		for(integer i=0; i<(DEPTH_F*DEPTH_F); i++) begin
			if(!$feof(fpi_f)) begin
				status = $fscanf(fpi_f,"%d\n", r_data);
				$display("residue data read:%d", r_data);
				
				res_data.Send(r_data); 
				
			end 
		end
	end	
end
endmodule


module ofm_mem_tb;


Channel #(.hsProtocol(P4PhaseBD), .WIDTH(35)) intf [2:0] ();

ofm_loading of(intf[0], intf[1]);
//res_loading #(.WIDTH(8)) re(intf[1], intf[2]);
ofm_mem #(.WIDTH(35)) o1(intf[0], intf[1], intf[2]);
data_bucket #(.WIDTH(35)) db(intf[2]);

initial begin 
#10000;
end

endmodule