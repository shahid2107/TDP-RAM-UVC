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
package ei_tdp_ram_package();

    //sequence item class file
    `include "ei_tdp_ram_seq_item.sv"

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
    `include "ei_tdp_ram_environment.sv"

    //base sequence class file
    `include "ei_tdp_ram_base_sequence.sv"
    //sanity sequence class file
    `include "ei_tdp_ram_sanity_sequence.sv"

    //base test class file
    `include "ei_tdp_ram_base_test.sv"
    //sanity test class file
    `include "ei_tdp_ram_sanity_test.sv"

endpackage : ei_tdp_ram_package
