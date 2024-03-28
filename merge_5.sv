`timescale 1ns/1fs

import SystemVerilogCSP::*;

module merge_5(interface sel, interface in0, interface in1, interface in2, interface in3, interface in4, interface out);

parameter FL=2,BL=1;
parameter WIDTH=32;
logic [WIDTH-1:0]data0,data1,data2,data3,data4;
logic [2:0]d;

always begin
	fork
		in0.Receive(data0);
		in1.Receive(data1);
		in2.Receive(data2);
		in3.Receive(data3);
		in4.Receive(data4);
		sel.Receive(d);
	join	
	#FL;
	if(d==0)begin
		out.Send(data0);
	end	
	else if(d==1)begin
		out.Send(data1);
	end
	else if(d==2)begin
		out.Send(data2);
	end
	else if(d==3)begin
		out.Send(data3);
	end
	else if(d==4)begin
		out.Send(data4);
	end
	#BL;
end	
endmodule	