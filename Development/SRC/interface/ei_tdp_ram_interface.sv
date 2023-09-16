/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_interface.sv                       */ 
/* Title          : Interface for TDP RAM UVC                     */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//interface declaration
interface ei_tdp_ram_interface_i #(parameter ADDR_WIDTH = 10, DATA_WIDTH = 8) (input bit clk, resetn);

    //properties declaration

    //enable signals
    logic we_a;
    logic we_b;
    logic re_a;
    logic re_b;

    //address bus signals
    logic [`ADDR_WIDTH - 1 : 0] addr_a;
    logic [`ADDR_WIDTH - 1 : 0] addr_b;

    //data bus signals
    logic [`DATA_WIDTH - 1 : 0] data_a;
    logic [`DATA_WIDTH - 1 : 0] data_b;
    logic [`DATA_WIDTH - 1 : 0] out_a;
    logic [`DATA_WIDTH - 1 : 0] out_b;

    //clocking block for driver
    clocking driver_cb @(posedge clk);

        //skew declaration
        default input #1ns output #1ns;

        //signal directions
        output we_a;
        output we_b;
        output re_a;
        output re_b;
        output addr_a;
        output addr_b;
        output data_a;
        output data_b;
        input  out_a;
        input  out_b;
 
    endclocking : driver_cb

    //clocking block for monitor
    clocking monitor_cb @(posedge clk);

        //skew declaration
        default input #1ns output #1ns;

        //signal directions
        input we_a;
        input we_b;
        input re_a;
        input re_b;
        input addr_a;
        input addr_b;
        input data_a;
        input data_b;
        input out_a;
        input out_b;

    endclocking : monitor_cb

    //modport declaration
    modport driver_mod  (clocking driver_cb);
    modport monitor_mod (clocking monitor_cb);

endinterface : ei_tdp_ram_interface_i
