/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_sanity_sequence.sv                 */ 
/* Title          : Sanity Sequence for TDP RAM UVC               */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_sanity_sequence_c extends uvm_sequence #(ei_tdp_ram_seq_item_c);

    //factory registration of the class
    `uvm_object_utils(ei_tdp_ram_sanity_sequence_c)

    //variable to store local address
    local bit [`ADDR_WIDTH - 1 : 0] address;

    //user-defined constructor declaration
    extern function new(string name = "sanity_sequence_h");

    //body method declaration
    extern task body();

endclass : ei_tdp_ram_sanity_sequence_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_sanity_sequence_c::new(string name = "sanity_sequence_h");
     
    //calling parent class constructor 
    super.new(name); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : body 
//Parameters Passed   : None
//Returned parameters : None
//Description         : Generate and send the transaction to sequencer
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_sanity_sequence_c::body();

    //allocating the memory to tr_h
    tr_h = ei_tdp_ram_seq_item_c::type_id::create("tr_h");

    //starting the sequence for write operation
    `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b0;})
    //storing the address
    address = tr_h.addr_a;
    //starting the sequence for read operation
    `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b0; addr_a == address;})

endtask : body
