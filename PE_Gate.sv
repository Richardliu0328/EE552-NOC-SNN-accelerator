`timescale 1ns/1fs

import SystemVerilogCSP::*;


module PE_Gate(interface in, interface out);

parameter WIDTH=35;
logic [WIDTH-1:0]in_data;
logic [WIDTH-1:0]out_data;
PE_Gatelevel ctr(in.req,in.ack,out.req,out.ack,in_data,out_data);

always @ (in.data) begin

in_data<= in.data;
in_data<= ~in.data0;
in_data<= in.data1;
end
always @ (out_data) begin

out.data <= out_data;;
out.data0 <= ~out_data;;
out.data1 <= out_data;;
end
endmodule
