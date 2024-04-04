`timescale 1ns/100ps
import SystemVerilogCSP::*;

module Filter_memory (interface filt_in, filt_out);
parameter WIDTH = 8;
parameter ROWS = 5;
parameter COLS = 5;
parameter FL = 2;
parameter BL = 1;

integer fii, fij;

logic [WIDTH-1:0] filt_mem [ROWS][COLS];
logic [WIDTH-1:0] filt_value;
   
always begin

    filt_in.Receive(filt_value);
    $display("%m receive value = %b, Simulation time = %t", filt_value, $time);
    #FL;
    for (fii = 0; fii < ROWS; fii++) begin
        for (fij = 0; fij < COLS; fij++) begin
            index = COLS * fii + fij;
            filt_out.Send(filt_mem[ROWS][COLS]);
            $display("%m filt_mem[%h][%h] = %d\n", fii, fij, filt_mem[ROWS][COLS]);
        end
    #BL;
end

