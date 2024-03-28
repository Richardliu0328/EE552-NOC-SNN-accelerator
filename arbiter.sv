`timescale 1ns/1fs

import SystemVerilogCSP::*;

module arbiter(interface req0, interface req1, interface req2, interface req3,interface req4,interface W);


parameter FL=2;
parameter BL=1;

logic req_0,req_1, req_2, req_3, req_4;
logic [2:0]winner;
always begin
	req0.Receive(req_0);
	req1.Receive(req_1);
	req2.Receive(req_2);
	req3.Receive(req_3);
	req4.Receive(req_4);
	#FL;
	if(req_0)begin
		winner=0;
	end
	if(req_1)begin
		winner=1;
	end
	if(req_2)begin
		winner=2;
	end
	if(req_3)begin
		winner=3;
	end
	if(req_4)begin
		winner=4;
	end	
W.Send(winner);
#BL;
end
endmodule