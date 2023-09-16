/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_base_test.sv                       */ 
/* Title          : Base Test for TDP RAM UVC                     */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_base_test_c extends uvm_test;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_base_test_c)

    //object instance of base sequence
    ei_tdp_ram_base_sequence_c base_seq_h;

    //environment class instance
    ei_tdp_ram_env_c env_h;

    //user-defined constructor declaration
    extern function new(string name = "base_test_h", uvm_component parent = null);

    //build-phase method declaration
    extern function build_phase(uvm_phase phase);

    //run-phase method declaration
    extern task run_phase(uvm_phase phase);

endclass : ei_tdp_ram_base_test_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_base_test_c::new(string name = "base_test_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Creating the envionment 
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_base_test_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Base Test", "Build Phase", UVM_FULL) 

    //allocating memory to environment class object
    env_h = ei_tdp_ram_env_c::type_id::create("env_h", this);
     
endfunction : build_phase

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Run-phase work
////////////////////////////////////////////////////////////////////////
 
task run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Base Test", "Run Phase", UVM_FULL) 

endtask : run_phase 
