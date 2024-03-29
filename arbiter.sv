`timescale 1ns/1fs

import SystemVerilogCSP::*;

module arbiter(interface N, interface E, interface W, interface S,interface out);


parameter FL=2;
parameter BL=1;

logic [WIDTH-1:0]N_packet, E_packet,W_packet,S_packet,out_packet;
logic [2:0]winner;
logic req_N,req_E, req_W, req_S, req_PE;	
//Depacket
// North	
always begin
	N.Receive(N_packet);
	[]
always begin
	if(req_N)begin
		winner=0;
	end
	if(req_E)begin
		winner=1;
	end
	if(req_W)begin
		winner=2;
	end
	if(req_S)begin
		winner=3;
	end
	if(req_PE)begin
		winner=4;
	end	
	if(winner==0)begin
		fork 
			
	
	
	W.Send(winner);
#BL;
end
endmodule
