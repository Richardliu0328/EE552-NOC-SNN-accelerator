`timescale 1ns/100ps
import SystemVerilogCSP::*;

module IFM_mem (interface ifm_in, ifm_out);
parameter ROWS = 32;
parameter COLS = 32;
parameter FL = 2;
parameter BL = 1;

integer ifmi, ifmj;

logic ifm_mem [ROWS][COLS];
logic ifm_value;


always begin

    ifm_in.Receive(ifm_value);
    $display("%m receive value = %b, Simulation time = %t", ifm_value, $time);
    #FL;
    
    for (ifmi = 0; ifmi < ROWS; ifmi++) begin
        for (ifmj = 0; ifmj < COLS; ifmj++) begin
            index = COLS * ifmi + ifmj;
            ifm_out.Send(ifm[ROWS][COLS]);
            $display("%m ifm_mem[%h][%h] = %d\n", ifmi, ifmj, ifm_mem[ifmi][ifmj]);
        end
    #BL;
end
