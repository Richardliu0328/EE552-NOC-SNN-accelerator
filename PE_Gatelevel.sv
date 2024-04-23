`timescale 1ns/1fs

module PE_Gatelevel(
input Lreq,
output Lack,
output Rreq,
input  Rack,
input [34:0]in,
output [34:0]out
);

logic Rreq_inter;
logic [34:0]data;

depacket_controller de(Lreq,Lack,Rreq_inter,Rack,in,data);
packetize_send_controller pack(Rreq_inter,Rack_inter,Rreq,Rack,data,out);

endmodule