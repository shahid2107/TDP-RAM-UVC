/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_agent.sv                           */ 
/* Title          : Agent for TDP RAM UVC                         */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_agent_c extends uvm_agent;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_agent_c)

    //object instance of sequencer, driver and monitor
    ei_tdp_ram_sequencer_c seqr_h;
    ei_tdp_ram_driver_c    drv_h;
    ei_tdp_ram_monitor_c   mon_h;

    //user-defined constructor declaration
    extern function new(string name = "agent_h", uvm_component parent = null);

    //build-phase method declaration
    extern function build_phase(uvm_phase phase);

    //connect phase method declaration
    extern function connect_phase(uvm_phase phase);

endclass : ei_tdp_ram_agent_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory to agent 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_agent_c::new(string name = "agent_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Create sequencer, driver and monitor 
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_agent_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Agent", "Build Phase", UVM_FULL) 
    
    //check if agent is active
    if(get_is_active() == UVM_ACTIVE)
    begin
        //create sequencer and driver
        seqr_h = ei_tdp_ram_sequencer_c :: type_id :: create("seqr_h", this);
        drv_h  = ei_tdp_ram_driver_c    :: type_id :: create("drv_h" , this);
    end

    //create monitor
    mon_h = ei_tdp_ram_monitor_c :: type_id :: create("mon_h", this);

endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : connect_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Connect the sequencer and driver
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_agent_c::connect_phase(uvm_phase phase);
     
    //calling parent class connect_phase 
    super.connect_phase(phase); 
    `uvm_info("Agent", "Connect Phase", UVM_FULL) 
    
    //check if agent if active
    if(get_is_active() == UVM_ACTIVE)
    begin
        //connect the sequencer and driver
        drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end

endfunction : connect_phase 
