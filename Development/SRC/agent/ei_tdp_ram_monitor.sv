/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_monitor.sv                         */ 
/* Title          : Monitor for TDP RAM UVC                       */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//compiler directive for modport with clocking block
`define MON_IF vif.monitor_mod.monitor_cb

//class declaration
class ei_tdp_ram_monitor_c extends uvm_monitor;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_monitor_c)

    //instance of virtual interface
    virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) vif;

    //analysis port to send data to scoreboard and subscriber
    uvm_analysis_port #(ei_tdp_ram_seq_item_c) mon_port;

    //transaction class object to store the packet
    ei_tdp_ram_seq_item_c tr_h;

    //local variables to store data to avoid skew
    local bit                       current_we_a;
    local bit                       current_we_b;
    local bit                       current_re_a;
    local bit                       current_re_b;
    local bit [`ADDR_WIDTH - 1 : 0] current_addr_a;
    local bit [`ADDR_WIDTH - 1 : 0] current_addr_b;
    local bit [`DATA_WIDTH - 1 : 0] current_data_a;
    local bit [`DATA_WIDTH - 1 : 0] current_data_b;

    //local variable of counter to send timing event
    local int counter;

    //user-defined constructor declaration
    extern function new(string new = "mon_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);

    //run-phase method declaration
    extern task run_phase(uvm_phase phase);

endclass : ei_tdp_ram_monitor_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_monitor_c::new(string name = "mon_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Extract vif from config db and allocate memory to port 
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_monitor_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Monitor", "Build Phase", UVM_FULL) 

    //extract vif from config db
    uvm_config_db #(virtual ei_tdp_ram_seq_item_c #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
        get(this, "", "vif", vif);

    //allocate memory to mon_port
    mon_port = new("mon_port", this);
     
endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Monitor each and every packet from interface
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_monitor_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Monitor", "Run Phase", UVM_FULL) 
    
    //wait for one clock cycle
    @(vif.monitor_cb);

    //extract initial information from master side
    current_we_a   = `MON_IF.we_a;
    current_we_b   = `MON_IF.we_b;
    current_re_a   = `MON_IF.re_a;
    current_re_b   = `MON_IF.re_b;
    current_addr_a = `MON_IF.addr_a;
    current_addr_b = `MON_IF.addr_b;
    current_data_a = `MON_IF.data_a;
    current_data_b = `MON_IF.data_b;

    //wait for one clock cycle
    @(vif.monitor_cb);

    //loop to monitor remaining transactions
    forever
    begin
        
        //allocating memory to tr_h;
        tr_h = ei_tdp_ram_seq_item_c :: type_id :: create("tr_h");

        //storing last clock information in packet
        tr_h.we_a   = current_we_a;
        tr_h.we_b   = current_we_b;
        tr_h.re_a   = current_re_a;
        tr_h.re_b   = current_re_b;
        tr_h.addr_a = current_addr_a;
        tr_h.addr_b = current_addr_b;
        tr_h.data_a = current_data_a;
        tr_h.data_b = current_data_b;

        //storing the read data information from dut side
        tr_h.out_a = `MON_IF.out_a;
        tr_h.out_b = `MON_IF.out_b;

        //store the timing information of packet
        tr_h.count = counter++;

        //storing the master side information of current cycle
        current_we_a   = `MON_IF.we_a;
        current_we_b   = `MON_IF.we_b;
        current_re_a   = `MON_IF.re_a;
        current_re_b   = `MON_IF.re_b;
        current_addr_a = `MON_IF.addr_a;
        current_addr_b = `MON_IF.addr_b;
        current_data_a = `MON_IF.data_a;
        current_data_b = `MON_IF.data_b;

        `uvm_info("Monitor", $sformatf("Item Collected\n%s", tr_h.sprint()), UVM_FULL)

        //sending the packet to scoreboard and subscriber
        mon_port.write(tr_h);

    end

endtask : run_phase 
