/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_sequencer.sv                       */ 
/* Title          : Sequencer for TDP RAM UVC                     */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_sequencer_c extends uvm_sequencer #(ei_tdp_ram_seq_item_c);

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_sequencer_c)

    //user-defined constructor declaration
    extern function new(string name = "seqr_h", uvm_component parent = null);
    
endclass : ei_tdp_ram_sequencer_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory  
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_sequencer_c::new(string name = "seqr_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 
