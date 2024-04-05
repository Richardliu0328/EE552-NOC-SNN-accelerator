`timescale 1ns/1fs

import SystemVerilogCSP::*;

module buffer(interface in, interface out);

parameter FL=2;
parameter BL=1;

parameter WIDTH=32;
logic [WIDTH-1:0]packet_in;

always begin
in.Receive(packet_in);
#FL;
out.Send(packet_in);
#BL;
end
endmodule	
