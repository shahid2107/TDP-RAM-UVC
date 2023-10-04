/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_driver_cb.sv                       */ 
/* Title          : Driver Callback to inject error               */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 01/10/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_driver_cb_c extends uvm_callback;

    //factory registration of class
    `uvm_object_utils(ei_tdp_ram_driver_cb_c)

    //string to indicate error
    string error_a;
    string error_b;

    //user-defined constructor declaration
    extern function new(string name = "driver_cb_h");

    //modify_packet method to inject error
    extern task ei_tdp_ram_modify_packet_t(ei_tdp_ram_seq_item_c tr_h);

endclass : ei_tdp_ram_driver_cb_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_driver_cb_c::new(string name = "driver_cb_h");
     
    //calling parent class constructor 
    super.new(name); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : ei_tdp_ram_modify_packet_t
//Parameters Passed   : tr_h
//Returned parameters : None
//Description         : Modify the packet of driver to inject error
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_driver_cb_c::ei_tdp_ram_modify_packet_t(ei_tdp_ram_seq_item_c tr_h);

    //if error to be modified is of port-a write
    if(error_a == "p1_wr")
    begin
        //change to low
        tr_h.we_a = 0;
    end
    //else if error to be modified is of port-a read
    else if(error_a == "p1_rd")
    begin
        //change to low
        tr_h.re_a = 0;
    end

    //if error to be modified is of port-b write
    if(error_b == "p2_wr")
    begin
        //change to low
        tr_h.we_b = 0;
    end
    //else if error to be modified is of port-b read
    else if(error_b == "p2_rd")
    begin
        //change to low
        tr_h.re_b = 0;
    end

endtask : ei_tdp_ram_modify_packet_t
