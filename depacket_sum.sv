`timescale 1ns/1fs


module depacket_sum(
input [34:0]in, 
output reg[34:0]out
);

parameter WIDTH=35;
parameter delay=2;

logic [2:0]packet_type;
logic [WIDTH-1:0]packet_in;
logic flag1, flag2;
logic [7:0]filter_value3;
logic [7:0]filter_value2;
logic [7:0]filter_value1;
logic ifmap_mem5,ifmap_mem4,ifmap_mem3,ifmap_mem2,ifmap_mem1;
logic [7:0]psumA;
logic [7:0]psumB;
logic [7:0]psumC;
always@(*)begin
	while(1) begin
		$display("Depacket");
		packet_in=in;
		packet_type=packet_in[WIDTH-9:WIDTH-11];
		if(packet_type==3'b000)begin
		$display("this packet is from filter");
			filter_value3=packet_in[23:16];
			filter_value2=packet_in[15:8];
			filter_value1=packet_in[7:0];
			#delay;
			flag1=1;		
		end
		if(packet_type==3'b001)begin
		$display("this packet is from Map");
			ifmap_mem5=packet_in[4];
			ifmap_mem4=packet_in[3];
			ifmap_mem3=packet_in[2];
			ifmap_mem2=packet_in[1];
			ifmap_mem1=packet_in[0];
			#delay;	
			flag2=1;
		end
		#delay;
		if(flag1&&flag2)begin
			flag1=0;
			flag2=0;
			break;
		end	
		$display("Finish receivnig 2 packets");
	end	
	$display("Calculate Partial Sum");
	psumA=(filter_value3*ifmap_mem5)+(filter_value2*ifmap_mem4)+(filter_value1*ifmap_mem3);
	psumB=(filter_value3*ifmap_mem4)+(filter_value2*ifmap_mem3)+(filter_value1*ifmap_mem2);
	psumC=(filter_value3*ifmap_mem3)+(filter_value2*ifmap_mem2)+(filter_value1*ifmap_mem1);
	out={10'b0000000000,psumA,psumB,psumC};
end
endmodule	
	

	