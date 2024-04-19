`timescale 1ns/100ps
import SystemVerilogCSP::*;

module ofm_mem (interface load_start, in, out);

parameter WIDTH = 35;
parameter ROWS = 28, COLS = 28;
parameter FL = 2;
parameter BL = 1;
parameter output_spike_type = 2'b11;
parameter res_type = 2'b10;
parameter res_addr = 4'b1100;
parameter ofm_addr = 4'b1100;//need two?
parameter sum1_addr = 4'b0001;
parameter sum2_addr = 4'b0011;
parameter sum3_addr = 4'b0111;
parameter res_zeros = {17{1'b0}};

integer flag, i, j, index;

logic [WIDTH-1:0]packet_out;
logic [WIDTH-1:0]value1;
logic ofm_value;
logic ofm_mem [ROWS-1:0][COLS-1:0];
logic res_mem [ROWS-1:0][COLS-1:0];
logic [7:0] res_value;
logic [7:0] sum1_value, sum2_value, sum3_value;



always begin
    load_start.Receive(flag);
    #FL;
    if(flag==1)begin
        $display("start loading ofm value!");
    end

    while(flag) begin

    fork
    in.Receive(value1);//receive sum1
    #FL;
    if (value1[WIDTH-1:WIDTH-4]==sum1_addr) begin
        sum1_value = value1[7:0];
    end

    if (value1[WIDTH-1:WIDTH-4]==sum2_addr) begin
        sum2_value = value1[7:0];
    end

    if (value1[WIDTH-1:WIDTH-4]==sum3_addr) begin
        sum3_value = value1[7:0];
    end
    $display("%m first receive---:%b", value1);

    in.Receive(value1);//receive sum2
    #FL;
    if (value1[WIDTH-1:WIDTH-4]==sum1_addr) begin
        sum1_value = value1[7:0];
    end

    if (value1[WIDTH-1:WIDTH-4]==sum2_addr) begin
        sum2_value = value1[7:0];
    end

    if (value1[WIDTH-1:WIDTH-4]==sum3_addr) begin
        sum3_value = value1[7:0];
    end
    $display("%m second receive---:%b", value1);

    in.Receive(value1);//receive sum3
    #FL;
    if (value1[WIDTH-1:WIDTH-4]==sum1_addr) begin
        sum1_value = value1[7:0];
    end

    if (value1[WIDTH-1:WIDTH-4]==sum2_addr) begin
        sum2_value = value1[7:0];
    end

    if (value1[WIDTH-1:WIDTH-4]==sum3_addr) begin
        sum3_value = value1[7:0];
    end
    $display("%m third receive---:%b", value1);
    join

    end
    
    //$display("%m receive value1 is %b in %t", value1, $time);

    if (value1[WIDTH-9:WIDTH-10]==output_spike_type) begin
        ofm_value = 1;
    end

        
    for (i = 0; i < ROWS; i++) begin//memory for output spike
        for (j = 0; j < COLS; j++) begin
            
            ofm_mem[i][j] = ofm_value;
        end
    end

    if (value1[WIDTH-9:WIDTH-10]==res_type) begin
        res_value = value1[7:0];
    end

    for (i = 0; i < ROWS; i++) begin//memory for residual value
        for (j = 0; j < COLS; j++) begin
            
            res_mem[i][j] = res_value;
        end
    end

    if (value1[WIDTH-1:WIDTH-4]==sum1_addr) begin
        packet_out = {res_addr, sum1_addr, res_type, res_zeros, res_value};
        out.Send(value1);
         #BL;
    end

    if (value1[WIDTH-1:WIDTH-4]==sum2_addr) begin
        packet_out = {res_addr, sum2_addr, res_type, res_zeros, res_value};
        out.Send(value1);
         #BL;
    end

     if (value1[WIDTH-1:WIDTH-4]==sum3_addr) begin
        packet_out = {res_addr, sum3_addr, res_type, res_zeros, res_value};
        out.Send(value1);
         #BL;
    end

end

endmodule


