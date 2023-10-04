/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_assertion.sv                       */ 
/* Title          : Assertion Module of TDP RAM UVC Signals check */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 02/10/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//module declaration
module ei_tdp_ram_assertion #(parameter ADDR_WIDTH = 10, DATA_WIDTH = 8)
    (
        //global signals
        input logic clk,
        input logic resetn,
        
        //port-a signals
        input logic we_a,
        input logic re_a,
        input logic [ADDR_WIDTH - 1 : 0] addr_a,
        input logic [DATA_WIDTH - 1 : 0] data_a,
        input logic [DATA_WIDTH - 1 : 0] out_a,

        //port-b signals
        input logic we_b,
        input logic re_b,
        input logic [ADDR_WIDTH - 1 : 0] addr_b,
        input logic [DATA_WIDTH - 1 : 0] data_b,
        input logic [DATA_WIDTH - 1 : 0] out_b
    );

    //****************Assertion-1*******************
    //property to check clock frequency
    property clk_freq_check_p (realtime clk_period);
        //local variable storing current time
        realtime current_time;
        @(posedge clk) (1, current_time = $realtime) |-> 
            ##1 ((clk_period <= $realtime - (current_time - 0.001ns)) && (clk_period >= $realtime - (current_time + 0.001ns)));
    endproperty 

    //storing the time period in local variable
    realtime time_period = ((1.0/`FREQUENCY)*1e9);
    //starting the assertion
    clk_freq_check_a : assert property (clk_freq_check_p(time_period))
    `uvm_info("CLK FREQ CHK", "Correct Clock Frequency Generated", UVM_DEBUG)
    else
        `uvm_error("CLK FREQ CHK", "Incorrect Clock Frequency Generated")

    //****************Assertion-2******************
    //property to check on time of clock
    property clk_on_time_period_check_p (realtime on_time);
        //local variable to store current time
        realtime current_time;
        @(posedge clk) (1, current_time = $realtime) |-> 
            @(negedge clk) ((on_period <= $realtime - (current_time - 0.001ns)) && (on_period >= $realtime - (current_time + 0.001ns)));
    endproperty

    //storing the on period in local variable
    realtime on_period = time_period * (`DUTY_CYCLE / 100.0);
    //starting the assertion
    on_time_check_a : assert property (clk_on_time_period_check_p(on_period))
    `uvm_info("CLK ON TIME CHK", "Correct On Time of Clock", UVM_DEBUG)
    else
        `uvm_error("CLK ON TIME CHK", "Incorrect On Time of Clock")

    //******************Assertion-3*********************
    //property to check signals at low when reset is applied
    property reset_check_p;
        @(posedge clk) !resetn |-> 
            (!we_a && !re_a && (addr_a == 0) && (data_a == 0) && (out_a == 0) && !we_b && !re_b && (addr_b == 0) && (data_b == 0) && (out_b == 0));
    endproperty

    //starting the assertion
    reset_check_a : assert property (reset_check_p)
    `uvm_info("RSTn CHK", "All Signals are at Low Level", UVM_DEBUG)
    else
        `uvm_error("RSTn CHK", "Not all Signals are at Low Level")

    //****************Assertion-4**********************
    //property to check if port-a both write and read are not active at same time
    property p1_en_check_p;
        @(posedge clk) !($isunknown(we_a) && $isunknown(re_a)) |-> !(we_a  && re_a);
    endproperty

    //starting the assertion
    p1_en_check_a : assert property (p1_en_check_p)
    `uvm_info("P1 EN CHK", "Both Read and Write are not activated together", UVM_DEBUG)
    else
        `uvm_error("P1 EN CHK", "Both Read and Write are activated together")

    //****************Assertion-5**********************
    //property to check if port-b both write and read are not active at same time
    property p2_en_check_p;
        @(posedge clk) !($isunknown(we_b) && $isunknown(re_b)) |-> !(we_b  && re_b);
    endproperty

    //starting the assertion
    p2_en_check_a : assert property (p2_en_check_p)
    `uvm_info("P2 EN CHK", "Both Read and Write are not activated together", UVM_DEBUG)
    else
        `uvm_error("P2 EN CHK", "Both Read and Write are activated together")

    //**************Assertion-6**********************
    //property to check if port-a write data and address not unknown when write enable
    property p1_wr_addr_data_known_check_p;
        @(posedge clk) we_a |-> !($isunknown(addr_a) || $isunknown(data_a));
    endproperty

    //staring the assertion
    p1_wr_addr_data_known_check_a : assert property (p1_wr_addr_data_known_check_p)
    `uvm_info("P1 Wr En", "Address and Data are Known", UVM_DEBUG)
    else
        `uvm_error("P1 Wr En", "Address or Data are Unknown")

    //**************Assertion-7***********************
    //property to check if port-b write data and address not unknown when write enable
    property p2_wr_addr_data_known_check_p;
        @(posedge clk) we_b |-> !($isunknown(addr_b) || $isunknown(data_b));
    endproperty

    //staring the assertion
    p2_wr_addr_data_known_check_a : assert property (p2_wr_addr_data_known_check_p)
    `uvm_info("P2 Wr En", "Address and Data are Known", UVM_DEBUG)
    else
        `uvm_error("P2 Wr En", "Address or Data are Unknown")

    //**************Assertion-8**********************
    //property to check if port-a address and dut read data are not unknown when read enable
    property p1_rd_addr_data_known_check_p;
        @(posedge clk) re_a |-> !$isunknown(addr_a) ##1 !$isunknown(out_a);
    endproperty

    //starting the assertion
    p1_rd_addr_data_known_check_a : assert property (p1_rd_addr_data_known_check_p)
    `uvm_info("P1 Rd En", "Address and Data are Known", UVM_DEBUG)
    else
        `uvm_error("P1 Rd En", "Address or Data are Unknown")

    //**************Assertion-9**********************
    //property to check if port-b address and dut read data are not unknown when read enable
    property p2_rd_addr_data_known_check_p;
        @(posedge clk) re_b |-> !$isunknown(addr_b) ##1 !$isunknown(out_b);
    endproperty

    //starting the assertion
    p2_rd_addr_data_known_check_a : assert property (p2_rd_addr_data_known_check_p)
    `uvm_info("P2 Rd En", "Address and Data are Known", UVM_DEBUG)
    else
        `uvm_error("P2 Rd En", "Address or Data are Unknown")

    //**************Assertion-10********************
    //property to check address boundary check for port-a
    property p1_addr_boundary_check_p;
        @(posedge clk) (we_a || re_a) |-> (addr_a < 1024);
    endproperty

    //starting the assertion
    p1_addr_boundary_check_a : assert property (p1_addr_boundary_check_p)
    `uvm_info("P1 Addr CHK", "Address within boundary", UVM_DEBUG)
    else
        `uvm_error("P1 Addr CHK", "Address outside boundary")

    //**************Assertion-11********************
    //property to check address boundary check for port-b
    property p2_addr_boundary_check_p;
        @(posedge clk) (we_b || re_b) |-> (addr_b < 1024);
    endproperty

    //starting the assertion
    p2_addr_boundary_check_a : assert property (p2_addr_boundary_check_p)
    `uvm_info("P2 Addr CHK", "Address within boundary", UVM_DEBUG)
    else
        `uvm_error("P2 Addr CHK", "Address outside boundary")


endmodule : ei_tdp_ram_assertion
