`timescale 1ns/1fs

module depacket_controller_tb;

logic Lreq;
logic Lack;
logic Rreq;
logic Rack;
logic [34:0]in;
logic [34:0]out;

depacket_controller uut(
	.Lreq(Lreq),
	.Lack(Lack),
	.Rreq(Rreq),
	.Rack(Rack),
	.in(in),
	.out(out)
);

initial begin
	in=35'b00000000000000000000000000000001111;
	#40;
	in=35'b00000000001000000000000000000001111;
	#40;
	in=35'b00000000000000000000000000000010111;
	#40;
	in=35'b00000000001000000000000000000001100;
	#40;
end

//LHS Handshake
always begin
Lreq=1;
wait(Lack==1);
Lreq=0;
wait(Lack==0);
end

//RHS Handshake
always begin
Rack=0;
wait(Rreq==1);
Rack=1;
wait(Rreq==0);
end
 endmodule	