/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_package.sv                         */ 
/* Title          : Package for TDP RAM UVC                       */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//include interface file
`include "ei_tdp_ram_interface.sv"

//package declaration
package ei_tdp_ram_package;

    //import uvm package
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //sequence item class file
    `include "ei_tdp_ram_seq_item.sv"

    //driver callback class file
    `include "ei_tdp_ram_driver_cb.sv"

    //sequencer class file
    `include "ei_tdp_ram_sequencer.sv"
    //driver class file
    `include "ei_tdp_ram_driver.sv"
    //monitor class file
    `include "ei_tdp_ram_monitor.sv"
    //agent class file
    `include "ei_tdp_ram_agent.sv"

    //scoreboard class file
    `include "ei_tdp_ram_scoreboard.sv"
    //subscriber class file
    `include "ei_tdp_ram_subscriber.sv"

    //environment class file
    `include "ei_tdp_ram_env.sv"

    //base sequence class file
    `include "ei_tdp_ram_base_sequence.sv"
    //sanity sequence class file
    `include "ei_tdp_ram_sanity_sequence.sv"
    //single port sanity sequence class file
    `include "ei_tdp_ram_single_port_sanity_sequence.sv"
    //dual port sanity sequence class file
    `include "ei_tdp_ram_dual_port_sanity_sequence.sv"

    //base test class file
    `include "ei_tdp_ram_base_test.sv"
    //sanity test for port-1 class file
    `include "ei_tdp_ram_p1_sanity_test.sv"
    //sanity test for port-2 class file
    `include "ei_tdp_ram_p2_sanity_test.sv"
    //reset test class file
    `include "ei_tdp_ram_reset_test.sv"
    //inclusion of port-1 port-2 together sanity test
    `include "ei_tdp_ram_p1_p2_sanity_test.sv"
    //inclusion of port-1 write both port read test
    `include "ei_tdp_ram_p1_wr_p1_p2_rd_test.sv"
    //inclusion of port-2 write both port read test
    `include "ei_tdp_ram_p2_wr_p1_p2_rd_test.sv"
    //inclusion of port-1 write whole memory read test
    `include "ei_tdp_ram_p1_wr_whole_rd_test.sv"
    //inclusion of port-2 write whole memory read test
    `include "ei_tdp_ram_p2_wr_whole_rd_test.sv"
    //inclusion of port-1 write with wr en low test
    `include "ei_tdp_ram_p1_wr_with_wr_en_low_test.sv"
    //inclusion of port-2 write with wr en low test
    `include "ei_tdp_ram_p2_wr_with_wr_en_low_test.sv"
    //inclusion of port-1 read with rd en low test
    `include "ei_tdp_ram_p1_rd_with_rd_en_low_test.sv"
    //inclusion of port-2 read with rd en low test
    `include "ei_tdp_ram_p2_rd_with_rd_en_low_test.sv"

endpackage : ei_tdp_ram_package
