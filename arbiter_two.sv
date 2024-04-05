`timescale 1ns/1fs

import SystemVerilogCSP::*;

module arbiter_two(interface in0, interface in1, interface out);

parameter FL=2;
parameter BL=1;
parameter WIDTH=32;
logic winner;
logic [WIDTH-1:0]data0, data1;

always begin
	wait(in0.req==1 || in1.req==1);
	if(in0.req==1)begin
		winner=1'b0;
	end
	else if(in1.req==1)begin
		winner=1'b1;
	end
	else if(in0.req==1&&in1.req==1)begin
		winner=($random%2==0) ? 0:1;
	end

	if(winner==1'b0)begin
		in0.Receive(data0);
		#FL;
		out.Send(data0);
		#BL;
	end
	else begin
		in1.Receive(data1);
		#FL;
		out.Send(data1);
		#BL;
	end
end
endmodule	