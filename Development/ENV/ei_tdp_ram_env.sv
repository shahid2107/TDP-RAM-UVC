/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_env.sv                             */ 
/* Title          : Environment for TDP RAM                       */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_env_c extends uvm_env;

    //factory registration of class
    `uvm_component_utils(ei_tdp_ram_env_c)

    //agent, scoreboard and subscriber class object declaration
    ei_tdp_ram_agent_c      agent_h;
    ei_tdp_ram_scoreboard_c scb_h;
    ei_tdp_ram_subscriber_c sub_h;

    //user-defined constructor declaration
    extern function new(string name = "env_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);

    //connect-phase method declaration
    extern function void connect_phase(uvm_phase phase);

endclass : ei_tdp_ram_env_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : Allocates memory to environment class 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_env_c::new(string name = "env_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Create agent, scoreboard and subscriber
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_env_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Environment", "Build Phase", UVM_FULL) 

    //allocate memory to agent, scoreboard and subscriber
    agent_h = ei_tdp_ram_agent_c      :: type_id :: create("agent_h", this);
    scb_h   = ei_tdp_ram_scoreboard_c :: type_id :: create("scb_h", this);
    sub_h   = ei_tdp_ram_subscriber_c :: type_id :: create("sub_h", this);
     
endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : connect_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Connect the monitor with scoreboard and subscriber 
////////////////////////////////////////////////////////////////////////
 
function void connect_phase(uvm_phase phase);
     
    //calling parent class connect_phase 
    super.connect_phase(phase); 
    `uvm_info("Environment", "Connect Phase", UVM_FULL) 
    
    //connect the analysis port of monitor with scoreboard and subscriber analysis imp
    agent_h.mon_h.mon_port.connect(scb_h.scb_imp);
    agent_h.mon_h.mon_port.connect(sub_h.sub_imp);

endfunction : connect_phase 
