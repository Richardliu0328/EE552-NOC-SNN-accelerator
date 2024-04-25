`timescale 1ns/100ps
import SystemVerilogCSP::*;

module OF_Residual_mem (interface in, out, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);

parameter WIDTH = 35;
parameter FL = 2;
parameter BL = 1;
parameter ofm_addr = 4'b1111;//need two?
parameter sum1_addr = 4'b0011;
parameter sum2_addr = 4'b0111;
parameter sum3_addr = 4'b1011;
parameter ifmap_addr=4'b0000;

logic [WIDTH-1:0]packet_out;
logic [WIDTH-1:0]packet_in;
logic [WIDTH-1]packet_done;
logic [WIDTH-1]packet_send1,packet_send2,packet_send3;
logic spike1,spike2,spike3;
logic ofm_mem1 [783:0];
logic ofm_mem2 [783:0];
logic [7:0]res_mem1 [783:0];
logic [7:0]res_mem2 [783:0];
logic [7:0] res_value;
logic [7:0] sum1_value, sum2_value, sum3_value;
logic [7:0]req_data1,req_data2,req_data3;
logic [9:0]counter=0,counter_req;
logic [1:0]timestep;
logic [7:0]req_data1,req_data2,req_data;;
logic [9:0]addr_req;
logic [9:0]addr1=0,addr2=0;
logic flag1,flag2,flag3;
initial begin
	timestep=1;
end	
always begin
	while(timestep==1)begin
		in.Receive(packet_in);
		if(addr1%27!=0)begin	
			if (packet_in[WIDTH-1:WIDTH-4]==sum1_addr) begin
				sum1_value =packet_in[7:0];
				spike1=packet_in[WIDTH-8];
				flag1=1;
				counter=counter+1;
			end

			if (packet_in[WIDTH-1:WIDTH-4]==sum2_addr) begin
				sum2_value =packet_in[7:0];
				spike2=packet_in[WIDTH-8];
				flag2=1;
				counter=counter+1;
			end

			if (packet_in[WIDTH-1:WIDTH-4]==sum3_addr) begin
				sum3_value =packet_in[7:0];
				spike3=packet_in[WIDTH-8];
				flag3=1;
				counter=counter+1;
			end
			$display("%m first receive---:%b", packet_in);
			$display("Finish Loading Map1 Result");
			if(flag1&&flag2&&flag3)begin
				res_mem1 [addr1]=sum1_value;
				ofm_mem1[addr1] = spike1;
				#1;
				res_mem1 [addr1+1]=sum2_value;
				ofm_mem1[addr1+1] = spike2;
				#1;
				res_mem1 [addr1+2]=sum3_value;
				ofm_mem1[addr1+2] = spike3;
				#1;
				addr1=addr1+3;
				flag1=flag2=flag3=0;
				packet_done={res_addr,ifmap_addr,27'b000000000000000000000000000};
				out.Send(packet_done);
			end	
		end	
		if(addr1%27==0)begin
			sum1_value =packet_in[7:0];
			spike1=packet_in[WIDTH-8];
			res_mem1 [addr1]=sum1_value;
			ofm_mem1[addr1] = spike1;
			addr1=addr1+1;
			counter=counter+1;
			packet_done={res_addr,ifmap_addr,27'b000000000000000000000000000};
			out.Send(packet_done);
		end	
		if(counter==784)begin
			counter=0;
			timestep=2;
			break;
		end	
	end	
while(timestep==2)begin
	if(addr2%27!=0)begin
		packet_send1={ofm_addr,sum1_addr,23'b00000000000000000000000,res1[addr2]};
		out.Send(packet_send1);
		#2;
		packet_send1={ofm_addr,sum1_addr,23'b00000000000000000000000,res1[addr2+1]};
		out.Send(packet_send1);
		#2;
		packet_send1={ofm_addr,sum1_addr,23'b00000000000000000000000,res1[addr2+2]};
		out.Send(packet_send1);
		#2
		in.Receive(packet_in);	
		if (packet_in[WIDTH-1:WIDTH-4]==sum1_addr) begin
				sum1_value =packet_in[7:0];
				spike1=packet_in[WIDTH-8];
				flag1=1;
				counter=counter+1;
			end

			if (packet_in[WIDTH-1:WIDTH-4]==sum2_addr) begin
				sum2_value =packet_in[7:0];
				spike2=packet_in[WIDTH-8];
				flag2=1;
				counter=counter+1;
			end

			if (packet_in[WIDTH-1:WIDTH-4]==sum3_addr) begin
				sum3_value =packet_in[7:0];
				spike3=packet_in[WIDTH-8];
				flag3=1;
				counter=counter+1;
			end
			$display("%m first receive---:%b", packet_in);
			$display("Finish Loading Map1 Result");
			if(flag1&&flag2&&flag3)begin
				res_mem1 [addr1]=sum1_value;
				ofm_mem2 [addr1] = spike1;
				#1;
				res_mem1 [addr1+1]=sum2_value;
				ofm_mem2[addr1+1] = spike2;
				#1;
				res_mem1 [addr1+2]=sum3_value;
				ofm_mem2[addr1+2] = spike3;
				#1;
				addr1=addr1+3;
				flag1=flag2=flag3=0;
				packet_done={res_addr,ifmap_addr,27'b000000000000000000000000000};
				out.Send(packet_done);
			end	
		end	
		if(addr1%27==0)begin
			packet_send1={ofm_addr,sum1_addr,23'b00000000000000000000000,res1[addr2]};
			out.Send(packet_send1);
			#2;
			in.Receive(packet_in);
			sum1_value =packet_in[7:0];
			spike1=packet_in[WIDTH-8];
			res_mem1 [addr1]=sum1_value;
			ofm_mem1[addr1] = spike1;
			addr1=addr1+1;
			counter=counter+1;
			packet_done={res_addr,ifmap_addr,27'b000000000000000000000000000};
			out.Send(packet_done);
		end	
		if(counter==784)begin
			counter=0;
			timestep=3;
			break;
		end	
	end	
end
//finish store all spike value

start_r.Send(1);
fork
ts_r.Send(1);
layer_r.Send(1);
join
for(integer i=0;i<784;i++)begin
	fork
		out_spike_addr.Send(i);
		out_spike_data.Send(ofm_mem1[i]);
	join	
		10;
end

fork
ts_r.Send(2);
layer_r.Send(1);
join

for(integer j=0;j<784;j++)begin
	fork	
		out_spike_addr.Send(j);
		out_spike_data.Send(ofm_mem2[j]);
	join
end	
done_r.Send(1);

end
endmodule
