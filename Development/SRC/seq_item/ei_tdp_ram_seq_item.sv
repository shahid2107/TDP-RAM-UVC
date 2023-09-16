/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_seq_item.sv                        */ 
/* Title          : Sequence Item for TDP RAM UVC                 */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/20223                                   */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_seq_item_c extends uvm_sequence_item;

    //factory registration of the class
    `uvm_object_utils(ei_tdp_ram_seq_item_c)

    //properties declaration
    //enable signals declaration
    rand bit we_a;
    rand bit we_b;
    rand bit re_a;
    rand bit re_b;

    //address bus signal declaration
    rand bit [`ADDR_WIDTH - 1 : 0] addr_a;
    rand bit [`ADDR_WIDTH - 1 : 0] addr_b;

    //write data bus signal declaration
    rand bit [`DATA_WIDTH - 1 : 0] data_a;
    rand bit [`DATA_WIDTH - 1 : 0] data_b;

    //read data bus signal declaration
    bit [`DATA_WIDTH - 1 : 0] out_a;
    bit [`DATA_WIDTH - 1 : 0] out_b;

    //counter variable for timing details
    int count;

    //user-defined constructor declaration
    extern function new(string name = "tr_h");

    //do-print method declaration
    extern function void do_print(uvm_printer printer);

endclass : ei_tdp_ram_seq_item_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_seq_item_c::new(string name = "tr_h");
     
    //calling parent class constructor 
    super.new(name); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : do_print 
//Parameters Passed   : printer
//Returned parameters : None
//Description         : Print the properties based on user-requirement
////////////////////////////////////////////////////////////////////////

function void ei_tdp_ram_seq_item_c::do_print(uvm_printer printer);

    //printing all fields using printer
    printer.print_field_int("we_a", we_a, $bits(we_a), UVM_HEX);
    printer.print_field_int("we_b", we_b, $bits(we_b), UVM_HEX);
    printer.print_field_int("re_a", re_a, $bits(re_a), UVM_HEX);
    printer.print_field_int("re_b", re_b, $bits(re_b), UVM_HEX);
    printer.print_field_int("addr_a", addr_a, $bits(addr_a), UVM_HEX);
    printer.print_field_int("addr_b", addr_b, $bits(addr_b), UVM_HEX);
    printer.print_field_int("data_a", data_a, $bits(data_a), UVM_HEX);
    printer.print_field_int("data_b", data_b, $bits(data_b), UVM_HEX);
    printer.print_field_int("out_a", out_a, $bits(out_a), UVM_HEX);
    printer.print_field_int("out_b", out_b, $bits(out_b), UVM_HEX);
    printer.print_field_int("count", count, $bits(count), UVM_DEC);

endfunction : do_print
