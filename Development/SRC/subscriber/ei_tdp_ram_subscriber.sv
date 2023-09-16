/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_subscriber.sv                      */ 
/* Title          : Subscriber for TDP RAM UVC                    */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_subscriber_c extends uvm_subscriber #(ei_tdp_ram_seq_item_c);

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_subscriber_c)

    //transaction class object
    ei_tdp_ram_seq_item_c tr_h;

    //queue to store packets received from monitor
    ei_tdp_ram_seq_item_c queue[$];

    //analysis imp to receive packet from monitor
    uvm_analysis_imp #(ei_tdp_ram_seq_item_c, ei_tdp_ram_subscriber_c) sub_imp;

    //virtual interface instance
    virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) vif;

    //user-defined constructor declaration
    extern function new(string name = "sub_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase);

    //run-phase method declaration
    extern task run_phase(uvm_phase phase);

    //write method declaration
    extern function write(ei_tdp_ram_seq_item_c tr_h);

endclass : ei_tdp_ram_subscriber_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined Constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_subscriber_c::new(string name = "scb_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Extract vif from config db and allocate memory to imp
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_subscriber_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Subscriber", "Build Phase", UVM_FULL) 

    //extract vif from config db
    uvm_config_db #(virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
        get(this, "", "vif", vif);

    //allocate memory to sub_imp
    sub_imp = new("sub_imp", this);
     
endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Run phase to check sampling point
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_subscriber_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Subscriber", "Run Phase", UVM_FULL) 
     
endtask : run_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : write 
//Parameters Passed   : tr_h
//Returned parameters : None
//Description         : Receiving the packet from Monitor
////////////////////////////////////////////////////////////////////////

function ei_tdp_ram_subscriber_c::write(ei_tdp_ram_seq_item_c tr_h);

    `uvm_info("Subscriber", $sformatf("Received a packet from Monitor\n%s", tr_h.sprint()), UVM_FULL)
    //storing the packet in the queue
    queue.push_back(tr_h);

endfunction : write

