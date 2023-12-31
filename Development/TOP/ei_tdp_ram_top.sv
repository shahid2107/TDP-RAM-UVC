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
`include "uvm_macros.svh"

//macros for address and data bus size
`define ADDR_WIDTH 10
`define DATA_WIDTH 8

//macros for frequency and duty cycle
`define FREQUENCY 10000000
`define DUTY_CYCLE 50

//import package for tdp ram
`include "ei_tdp_ram_package.sv"
import ei_tdp_ram_package::*;

//inclusion of DUT file
`include "ei_tdp_ram_dut.sv"

//module declaration
module ei_tdp_ram_top();

    //global signal declaration
    bit clk;
    wire resetn;

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

    //binding the assertion module
    bind ei_tdp_ram_top ei_tdp_ram_assertion #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) binding_file
        (
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
            .out_a(pif.out_a),
            .out_b(pif.out_b)
        );

    //block to invoke test and store pif in config db
    initial
    begin
        //store the pif in config db
        uvm_config_db #(virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
            set(null, "*", "vif", pif);

        //start the test
        run_test();
    end

    //parameter calculation block
    initial 
    begin
        time_period = ((1.0/`FREQUENCY)*(1e9)); 
        on_time = ((`DUTY_CYCLE/100.0)*time_period);
        off_time = (((100-`DUTY_CYCLE)/100.0)*time_period);
    end

    //clock generation block
    initial
    begin
        clk = 1'b0;
        //resetn = 1'b1;
        forever
        begin
            #(off_time) clk = 1;
            #(on_time) clk = 0;
        end
    end

endmodule : ei_tdp_ram_top
