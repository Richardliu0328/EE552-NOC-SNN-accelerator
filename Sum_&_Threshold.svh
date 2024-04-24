`timescale 1ns/100ps
import SystemVerilogCSP::*;

module Sum_Threshold (interface in, out);
parameter WIDTH = 35;
parameter FL= 2, BL = 1;
parameter threshold = 64;
parameter pe1_addr = 4'b1000;
parameter pe2_addr = 4'b1100;
parameter pe3_addr = 4'b0001;
parameter pe4_addr = 4'b0101;
parameter pe5_addr = 4'b1001;
parameter pe6_addr = 4'b1101;
parameter pe7_addr = 4'b0010;
parameter pe8_addr = 4'b0110;
parameter pe9_addr = 4'b1010;
parameter pe10_addr = 4'b1110;
parameter res_addr = 4'b1111;
parameter sum_addr = 4'b0000;//s&t1_addr=4'b0000, s&t2_addr=4'b0100, s&t3_addr=4'b1000;
parameter ofm_addr = 4'b1111;
//parameter res_type = 2'b10;
//parameter output_spike_type = 2'b11;
parameter res_zeros = {16{1'b0}};
parameter out_spike_zeros = {23{1'b0}};
parameter sum_num = 2'b00;//00 S&T1, 01 S&T2, 10 S&T3
parameter sum3_num = 2'b11;
parameter done = 5'b11111;
parameter done_zeros = {20{1'b0}};
parameter done_type = 2'b10;

logic tstep2 = 0;

logic [WIDTH-1:0]value;
logic [7:0]pe1_value, pe2_value, pe3_value, pe4_value, pe5_value, pe6_value, pe7_value, pe8_value, pe9_value, pe10_value;
logic [7:0]Add_value;
logic [7:0]res_value;
logic flag1,flag2,flag3flag4,flag5,flag6,flag7,flag8,flag9,flag10;//to indicate I get 10 packets from PEs
logic output_spike;
logic [WIDTH-1:0]packet_out;
logic [9:0]counter=0;//counter for map1 to show timestep1 and 2
logic [WIDTH-1]packet_req;
logic [3:0]counter_Send=0;
always begin
	if(tstep2==0)begin
    in.Receive(value);
	#FL;
		if (value[WIDTH-9:WIDTH-12]==pe1_addr)
		begin 
			pe1_value = value[7:0];
			flag1=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe2_addr)
		begin 
			pe2_value = value[7:0];
			flag2=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe3_addr)
		begin 
			pe3_value = value[7:0];
			flag3=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe4_addr)
		begin 
			pe4_value = value[7:0];
			flag4=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe5_addr)
		begin 
			pe5_value = value[7:0];
			flag5=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe6_addr)
		begin 
			pe6_value = value[7:0];
			flag6=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe7_addr)
		begin 
			pe7_value = value[7:0];
			flag7=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe8_addr)
		begin 
			pe8_value = value[7:0];
			flag8=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe9_addr)
		begin 
			pe9_value = value[7:0];
			flag9=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe10_addr)
		begin 
			pe10_value = value[7:0];
			flag3=1;
		end
		$display("pe1_value:%b---pe2_value:%b---pe3_value:%b---pe4_value:%b---pe5_value:%b---pe6_value:%b---pe7_value:%b---pe8_value:%b---pe9_value:%b---pe10_value:%b", pe1_value,pe2_value,pe3_value,pe4_value,pe5_value,pe6_value,pe7_value,pe8_value,pe9_value,pe10_value);
		if (flag1&&flag2&&flag3&&flag4&&flag5&&flag6&&flag7&&flag8&&flag9&&flag10)begin
			$display("%m receive all data from PE1 to PE10");
			Add_value = pe1_value + pe2_value + pe3_value + pe4_value + pe5_value + pe6_value + pe7_value + pe8_value + pe9_value + pe10_value;
			$display("1st_in:%b", Add_value);
		//Threshold
			if (Add_value>=threshold) begin
				output_spike = 1;
				res_value = Add_value - threshold;
			end
			else if(Add_value<threshold)begin
				output_spike = 0;
				res_value = Add_value;
			end
			$display("residual_value:%m---%b", packet_out);
			packet_out = {sum_addr, res_addr, output_spike, res_zeros,2'b00, res_value};//4+4+1+16+2+8=35 bits
			out.Send(packet_out);
			flag1=flag1=flag2=flag3=flag4=flag5flag=flag7=flag8=flag9=flag10=0;
			counter=counter+1'b1;
		end
		#BL;
		if(counter==279)begin
		counter=0;
		tstep2=1;
		end
    end
    if(tstep2==1)begin
    in.Receive(value);
    #FL;
		if (value[WIDTH-9:WIDTH-12]==pe1_addr)
		begin 
			pe1_value = value[7:0];
			flag1=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe2_addr)
		begin 
			pe2_value = value[7:0];
			flag2=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe3_addr)
		begin 
			pe3_value = value[7:0];
			flag3=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe4_addr)
		begin 
			pe4_value = value[7:0];
			flag4=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe5_addr)
		begin 
			pe5_value = value[7:0];
			flag5=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe6_addr)
		begin 
			pe6_value = value[7:0];
			flag6=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe7_addr)
		begin 
			pe7_value = value[7:0];
			flag7=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe8_addr)
		begin 
			pe8_value = value[7:0];
			flag8=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe9_addr)
		begin 
			pe9_value = value[7:0];
			flag9=1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe10_addr)
		begin 
			pe10_value = value[7:0];
			flag10=1;
		end
		if (flag1&&flag2&&flag3&&flag4&&flag5&&flag6&&flag7&&flag8&&flag9&&flag10)begin
			packet_req={sum_addr,ofm_addr,sum_addr,23'b11111111111111111111111};
			out.Send(packet_req);
			#FL;
			in.Receive(value);
			res_value=value[7:0];
			$display("%m receiveresidue from Residue MEM");
			Add_value = pe1_value + pe2_value + pe3_value + pe4_value + pe5_value + pe6_value + pe7_value + pe8_value + pe9_value + pe10_value + res_value;
			$display("N_in:%b", Add_value);
			if(Add_value>=threshold) begin
				output_spike = 1;
				res_value = Add_value - threshold;
			end
			else begin
				output_spike = 0;
				res_value = Add_value;
			end
			packet_out = {sum_addr, res_addr, sum_addr,output_spike, res_zeros,2'b00, res_value};//4+4+1+16+2+8=35 bits
			out.Send(packet_out);
			flag1=flag1=flag2=flag3=flag4=flag5flag=flag7=flag8=flag9=flag10=0;
			counter=counter+1'b1;
		end
		#BL;
		end	
		if(counter==279)begin
		counter=0;
		end
	end
end
endmodule

    




    

    

    
    
