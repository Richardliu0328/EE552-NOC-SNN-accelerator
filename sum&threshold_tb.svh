`timescale 1ns/100ps
import SystemVerilogCSP::*;


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



module sum_loading(interface out);

parameter WIDTH = 35;
parameter FL = 2;
parameter pe1_addr = 4'b1011;
parameter pe2_addr = 4'b1111;
parameter pe3_addr = 4'b0010;
parameter pe4_addr = 4'b0110;
parameter pe5_addr = 4'b1010;
parameter pe6_addr = 4'b1110;
parameter pe7_addr = 4'b0001;
parameter pe8_addr = 4'b0101;
parameter pe9_addr = 4'b1001;
parameter pe10_addr = 4'b1101;
parameter res_addr = 4'b1100;
parameter sum_addr = 4'b0000;
parameter zeros = {15{1'b0}};
parameter data1 = 8'b00000001;
parameter data2 = 8'b00000010;
parameter data3 = 8'b00000011;
parameter data4 = 8'b00000100;
parameter data5 = 8'b00000101;
parameter data6 = 8'b00000110;
parameter data7 = 8'b00000111;
parameter data8 = 8'b00001000;
parameter data9 = 8'b00001001;
parameter data10 = 8'b00001010;



integer i;

logic [7:0]res_value = 8'b00000011;//3
logic [7:0]data = 0;
logic [WIDTH-1:0]packet_out1;
logic [WIDTH-1:0]packet_out2;
logic [WIDTH-1:0]packet_out3;
logic [WIDTH-1:0]packet_out4;
logic [WIDTH-1:0]packet_out5;
logic [WIDTH-1:0]packet_out6;
logic [WIDTH-1:0]packet_out7;
logic [WIDTH-1:0]packet_out8;
logic [WIDTH-1:0]packet_out9;
logic [WIDTH-1:0]packet_out10;

always begin
/*
for(i=0;i<10;i++)begin
    data0 = data0 + 1'b1;
    data[i] = data0;
end
*/


    packet_out1 = {pe1_addr, sum_addr, pe1_addr, zeros, data1};
    packet_out2 = {pe2_addr, sum_addr, pe2_addr, zeros, data2};
    packet_out3 = {pe3_addr, sum_addr, pe3_addr, zeros, data3};
    packet_out4 = {pe4_addr, sum_addr, pe4_addr, zeros, data4};
    packet_out5 = {pe5_addr, sum_addr, pe5_addr, zeros, data5};
    packet_out6 = {pe6_addr, sum_addr, pe6_addr, zeros, data6};
    packet_out7 = {pe7_addr, sum_addr, pe7_addr, zeros, data7};
    packet_out8 = {pe8_addr, sum_addr, pe8_addr, zeros, data8};
    packet_out9 = {pe9_addr, sum_addr, pe9_addr, zeros, data9};
    packet_out10 = {pe10_addr, sum_addr, pe10_addr, zeros, data10};

    out.Send(packet_out1);
    out.Send(packet_out2);
    out.Send(packet_out3);
    out.Send(packet_out4);
    out.Send(packet_out5);
    out.Send(packet_out6);
    out.Send(packet_out7);
    out.Send(packet_out8);
    out.Send(packet_out9);
    out.Send(packet_out10);
    #FL;

end
endmodule


module sum_tb;

Channel #(.hsProtocol(P4PhaseBD), .WIDTH(35)) intf [1:0] ();

sum_loading #(.WIDTH(35)) su(intf[0]);
Sum_Threshold #(.WIDTH(35)) st(intf[0], intf[1]);
data_bucket #(.WIDTH(35)) db(intf[1]);

initial begin 
#100000;
end
endmodule