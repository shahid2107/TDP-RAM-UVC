/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_base_sequence.sv                   */ 
/* Title          : Base Sequence for TDP RAM UVC                 */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_base_sequence_c extends uvm_sequence #(ei_tdp_ram_seq_item_c);

    //factory registration of the class
    `uvm_object_utils(ei_tdp_ram_base_sequence_c)

    //variable to store local address
    local bit [`ADDR_WIDTH - 1 : 0] address;

    //user-defined constructor declaration
    extern function new(string name = "base_sequence_h");

    //body method declaration
    extern task body();

endclass : ei_tdp_ram_base_sequence_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_base_sequence_c::new(string name = "base_sequence_h");
     
    //calling parent class constructor 
    super.new(name); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : body 
//Parameters Passed   : None
//Returned parameters : None
//Description         : Generate and send the transaction to sequencer
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_base_sequence_c::body();

    `uvm_info("Base Sequence", "Inside Body", UVM_FULL)

endtask : body

