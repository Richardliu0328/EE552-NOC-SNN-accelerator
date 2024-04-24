`timescale 1ns/100ps
import SystemVerilogCSP::*;

module OF_Residual_mem (interface in, out, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);

parameter WIDTH = 35;
parameter FL = 2;
parameter BL = 1;
parameter res_addr = 4'b1111;
parameter ofm_addr = 4'b1111;//need two?
parameter sum1_addr = 4'b0011;
parameter sum2_addr = 4'b0111;
parameter sum3_addr = 4'b1011;
parameter res_zeros = {17{1'b0}};

logic flag=0, i=0, j=0, index;
logic [9:0]addr_req;
logic [WIDTH-1:0]packet_out;
logic [WIDTH-1:0]packet_in;
logic [WIDTH-1]packet_req;
logic spike1,spike2,spike3;
logic ofm_mem1 [29:0][29:0];
logic ofm_mem2 [29:0][29:0];
logic [7:0]res_mem1 [29:0][29:0];
logic [7:0]res_mem2 [29:0][29:0];
logic [7:0] res_value;
logic [7:0] sum1_value, sum2_value, sum3_value;
logic [7:0]req_data1,req_data2,req_data3;
logic [9:0]counter=0,counter_req;
logic [1:0]timestep;
logic [7:0]req_data1,req_data2,req_data;;
logic [9:0]addr_req;
logic [4:0]row=0;
logic [4:0]col=0;

initial begin
	timestep=1;
end	
always begin
if(timestep==1)begin
    in.Receive(packet_in);
    #FL;
	for(row=0;row<28;row++)begin
		for(col=0;col<28;col+3)begin
		in.Receive(packet_in);
			if (packet_in[WIDTH-1:WIDTH-4]==sum1_addr) begin
				fork
				sum1_value =packet_in[7:0];
				spike1=packet_in[WIDTH-8];
				res_mem1 [row][col]=sum1_value;
				ofm_mem1[row][col] = spike1;
				join
			end

			if (packet_in[WIDTH-1:WIDTH-4]==sum2_addr) begin
				fork
				sum2_value =packet_in[7:0];
				spike2=packet_in[WIDTH-8];
				res_mem1 [row][col+1]=sum2_value;
				ofm_mem1[row][col+1] = spike2;
				join
			end

			if (packet_in[WIDTH-1:WIDTH-4]==sum3_addr) begin
				fork
				sum3_value =packet_in[7:0];
				spike3=packet_in[WIDTH-8];
				res_mem1 [row][col+2]=sum3_value;
				ofm_mem1[row][col+2] = spike3;

				join
			end
			$display("%m first receive---:%b", packet_in);
			$display("Finish Loading Map1 Result");
		end
end
timestep==2;
if(timestep==2)begin
	in.Receive(packet_in);
	if(pack[12:0]=23'b11111111111111111111111)begin
		
	else begin	
		if(sum1_addr=packet_in[WIDTH-9:WIDTH-12])begin
		counter_req=packet_in[23:14];
		row=counter_req/28;
		col=counter_req%28;
		req_data=res_mem1[row][col];
		packet_req={res_addr,sum1_addr,19'b0000000000000000000,req_data};
		out.Send(packet_req);
		#FL;
		end
		if(sum2_addr=packet_in[WIDTH-9:WIDTH-12])begin
		counter_req=packet_in[23:14];
		row=counter_req/28;
		col=counter_req%28;
		req_data=res_mem1[row][col+1];
		packet_req={res_addr,sum2_addr,19'b0000000000000000000,req_data};
		out.Send(packet_req);
		#FL;
		end
		if(sum3_addr=packet_in[WIDTH-9:WIDTH-12])begin
		counter_req=packet_in[23:14];
		row=counter_req/28;
		col=counter_req%28;
		req_data=res_mem1[row][col+2];
		packet_req={res_addr,sum3_addr,19'b0000000000000000000,req_data};
		out.Send(packet_req);
		#FL;
		end
	end	
end
start_r.Send(1);




















    for (i = 0; i < ROWS; i++) begin//memory for residual value
        for (j = 0; j < COLS; j++) begin
            
            res_mem[i][j] = res_value;
        end
    end

    if (packet_in[WIDTH-1:WIDTH-4]==sum1_addr) begin
        packet_out = {res_addr, sum1_addr, res_type, res_zeros, res_value};
        out.Send(packet_out);
         #BL;
    end

    if (packet_in[WIDTH-1:WIDTH-4]==sum2_addr) begin
        packet_out = {res_addr, sum2_addr, res_type, res_zeros, res_value};
        out.Send(packet_out);
         #BL;
    end

     if (packet_in[WIDTH-1:WIDTH-4]==sum3_addr) begin
        packet_out = {res_addr, sum3_addr, res_type, res_zeros, res_value};
        out.Send(packet_out);
         #BL;
    end

end

endmodule


