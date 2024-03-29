///Unnnnnfinished

`timescale 1ns/1fs

import SystemVerilogCSP::*;

module X_Y_Router(interface PE_in, interface PE_out,interface E_in,interface E_out,interface W_in,interface W_out, interface S_in,interface S_out, interface N_in, interface N_out);

//Latency
parameter FL=2;
parameter BL=1;

parameter WIDTH=32;
parameter Buffer_Depth=4;

logic [WIDTH-1:0]packet_in_N, packet_in_S, packet_in_E, packet_in_W, packet_in_PE;
logic [WIDTH-1:0]packet_out_N, packet_out_S, packet_out_E, packet_out_W, packet_out_PE;
//Packet Adress X
logic [1:0]src_X_N,dst_X_N;
logic [1:0]src_X_S,dst_X_S;
logic [1:0]src_X_W,dst_X_W;
logic [1:0]src_X_E,dst_X_E;
logic [1:0]src_X_PE,dst_X_PE; 
////Packet Adress Y
logic [1:0]src_Y_N,dst_Y_N;
logic [1:0]src_Y_S,dst_Y_S;
logic [1:0]src_Y_W,dst_Y_W;
logic [1:0]src_Y_E,dst_Y_E;
logic [1:0]src_Y_PE,dst_Y_PE; 


/*logic [3:0]higher_priority;
logic [3:0]higher_priority_packet;
logic [3:0]priority_IN;
logic [3:0]priority_packct;
*/

//North
always begin
	N_in.Receive(packet_in_N);
	#FL;
	packet_out_N=packet_in_N;
	fork
	src_X_N=[WIDTH-1:30]packet_in;
	src_Y_N=[29:28]packet_in;
	dst_X_N=[27:26]packet_in;
	dst_Y_N=[25:24]packet_in;
	join
	
	if(dst_X_N>src_X_N)begin
		src_X_N =src_X_N +1;
		[WIDTH-1:30]packet_out_N=src_X_N;
		W_out.Send(packet_out_N);
		#BL;
	end
	
	else if(dst_X_N==src_X_N)begin
		if(dst_Y_N>src_Y_N)begin
			src_Y_N=src_Y_N+1;
			[31:30]packet_out=src_Y;
			Y_plus.Send(packet_out);
			#BL;
		end	
		else if(dst_Y==src_Y)begin
			OUT_PE.Send(packet_in_N);
			#BL;
		end	
	end	
end
// South
always begin
	N.Receive(packet_in_N);
	#FL;
	packet_out_N=packet_in_N;
	src_X_N=[WIDTH-1:30]packet_in;
	src_Y_N=[29:28]packet_in;
	dst_X_N=[27:26]packet_in;
	dst_Y_N=[25:24]packet_in;
	
	if(dst_X_N>src_X_N)begin
		src_X_N =src_X_N +1;
		[WIDTH-1:30]packet_out_N=src_X_N;
		E.Send(packet_out_N);
		#BL;
	end
	
	else if(dst_X_N==src_X_N)begin
		if(dst_Y_N>src_Y_N)begin
			src_Y_N=src_Y_N+1;
			[WIDTH-1:30]packet_out_N=src_Y;
			Y_plus.Send(packet_out_N);
			#BL;
		end	
		else if(dst_Y==src_Y)begin
			OUT_PE.Send(packet_in_N);
			#BL;
		end	
	end	
end
//East

//West


//Packetization
always begin

end

// Input Arbiter

