/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_top.sv                             */ 
/* Title          : Top Module File for TDP RAM UVC               */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//import uvm package
import uvm_pkg::*;
`include "uvm_macros.sv"

//import package for tdp ram
`include "ei_tdp_ram_package.sv"
import ei_tdp_ram_package::*;

//macros for address and data bus size
`define ADDR_WIDTH 10
`define DATA_WIDTH 8

//module declaration
module ei_tdp_ram_top();

    //global signal declaration
    bit clk;
    bit resetn;

    //parameters for clock generation
    real time_period;
    real on_time;
    real off_time;

    //instantiating the tdp ram interface
    ei_tdp_ram_interface_i #(.DATA_WIDTH(`DATA_WIDTH), 
                             .ADDR_WIDTH(`ADDR_WIDTH))
                        pif (clk, resetn);

    //instantiating the dut module
    ei_tdp_ram_dut #(.DATA_WIDTH(`DATA_WIDTH),
                     .ADDR_WIDTH(`ADDR_WIDTH))
                    dut (
                        .clk(pif.clk),
                        .resetn(pif.resetn),
                        .data_a(pif.data_a),
                        .data_b(pif.data_b),
                        .addr_a(pif.addr_a),
                        .addr_b(pif.addr_b),
                        .we_a(pif.we_a),
                        .we_b(pif.we_b),
                        .re_a(pif.re_a),
                        .re_b(pif.re_b),
                        .q_a(pif.out_a),
                        .q_b(pif.out_b)
                    );

    //block to invoke test and store pif in config db
    initial
    begin
        //store the pif in config db
        uvm_config_db #(virtual ei_tdp_ram_interface_i(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
            set(null, "*", "vif", pif);

        //start the test
        run_test();
    end

    //clock generation block
    initial
    begin
        clk = 1'b0;
        resetn = 1'b1;
        forever
        begin
            #10 clk = ~clk;
        end
    end

endmodule : ei_tdp_ram_top
