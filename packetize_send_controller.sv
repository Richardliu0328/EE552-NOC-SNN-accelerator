`timescale 1ns/1fs

module packetize_send_controller(
input Lreq,
output Lack,
output Rreq,
input  Rack,
input [34:0]in,
output [34:0]out
);

//Delay Line
logic Lreq1, Lreq2,Lreq3;
buffer bb0(Lreq,Lreq1);
buffer bb1(Lreq1,Lreq2);
buffer bb2(Lreq2,Lreq3);

//Controller
logic [34:0]in_data;
four_phase_micropipeline_controller Con1(Lreq3, Rack,in,Rreq,Lack, in_data);
//Packettize Comb. Logic
packetize_send pack(in_data,out);


endmodule