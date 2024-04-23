`timescale 1ns/1fs

module packetize_send(
input [34:0]in,
output reg [34:0]out
);

parameter WIDTH=35;
parameter PE_addr=4'b1011;
parameter sum_thr1=4'b0011;
parameter sum_thr2=4'b0111;
parameter sum_thr3=4'b1011;
parameter delay=2;

logic [WIDTH-1:0]packet1;
logic [WIDTH-1:0]packet2;
logic [WIDTH-1:0]packet3;

logic [7:0]psumA;
logic [7:0]psumB;
logic [7:0]psumC;

always@(*)begin
	psumA=in[23:16];
	psumB=in[15:8];
	psumC=in[7:0];
	#delay;
	packet1={PE_addr,sum_thr1,PE_addr,15'b000000000000000, psumA};
	out=packet1;
	#delay;
	packet2={PE_addr,sum_thr2,PE_addr,15'b000000000000000, psumB};
	out=packet2;
	#delay;
	packet3={PE_addr,sum_thr3,PE_addr,15'b000000000000000, psumC};
	out=packet3;
	#delay;
end	
endmodule