`timescale 1ns/1fs


module depacket_sum_tb;

logic [34:0]in; 
logic [34:0]out;

depacket_sum uut(
	.in(in),
	.out(out)
);

initial begin
	in=35'b00000000000000000000000000000001111;
	#20;
	in=35'b00000000001000000000000000000001111;
	#20;
	in=35'b00000000000000000000000000000010111;
	#20;
	in=35'b00000000001000000000000000000001100;
	#20;
end	

endmodule