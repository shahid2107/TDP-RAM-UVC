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

    //covergroup for coverage
    covergroup ei_tdp_ram_coverage;

        //coverpoint for resetn
        cp_resetn : coverpoint vif.resetn
        {
            bins resetn[2] = {0,1};
        }

        //coverpoint for we_a
        cp_we_a : coverpoint tr_h.we_a
        {
            bins we_a[2] = {0,1};
        }

        //coverpoint for we_b
        cp_we_b : coverpoint tr_h.we_b
        {
            bins we_b[2] = {0,1};
        }

        //coverpoint for addr_a
        cp_addr_a : coverpoint tr_h.addr_a
        {
            bins addr_a[] = {[0:$]};
        }

        //coverpoint for addr_b
        cp_addr_b : coverpoint tr_h.addr_b
        {
            bins addr_b[] = {[0:$]};
        }

        //coverpoint for data_a
        cp_data_a : coverpoint tr_h.data_a
        {
            bins data_a[] = {[0:$]};
        }

        //coverpoint for data_b
        cp_data_b : coverpoint tr_h.data_b
        {
            bins data_b[] = {[0:$]};
        }

        //coverpoint for out_a
        cp_out_a : coverpoint tr_h.out_a
        {
            bins out_a[] = {[0:$]};
        }

        //coverpoint for out_b
        cp_out_b : coverpoint tr_h.out_b
        {
            bins out_b[] = {[0:$]};
        }

    //end of cover group
    endgroup : ei_tdp_ram_coverage

    //virtual interface instance
    virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) vif;

    //user-defined constructor declaration
    extern function new(string name = "sub_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);

    //run-phase method declaration
    extern task run_phase(uvm_phase phase);

    //write method declaration
    extern function void write(ei_tdp_ram_seq_item_c tr_h);

endclass : ei_tdp_ram_subscriber_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined Constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_subscriber_c::new(string name = "sub_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
    
    //allocating the memory to the coverage group
    ei_tdp_ram_coverage = new(); 
     
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

function void ei_tdp_ram_subscriber_c::write(ei_tdp_ram_seq_item_c tr_h);

    `uvm_info("Subscriber", $sformatf("Received a packet from Monitor\n%s", tr_h.sprint()), UVM_FULL)
    //storing the packet in the queue
    queue.push_back(tr_h);
    this.tr_h = tr_h;
    ei_tdp_ram_coverage.sample();

endfunction : write

