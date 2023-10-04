/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_random_test.sv                     */ 
/* Title          : Random Test of TDP RAM                        */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 02/10/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_random_test_c extends ei_tdp_ram_base_test_c;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_random_test_c)

    //dual port sanity sequence declaration
    ei_tdp_ram_dual_port_sanity_sequence_c seq_h;

    //user-defined constructor declaration
    extern function new(string name = "random_test_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);
    
    //end of elaboration phase method declaration
    extern function void end_of_elaboration_phase(uvm_phase phase);

    //run phase method declaration
    extern task run_phase(uvm_phase phase);

endclass : ei_tdp_ram_random_test_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor declaration 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_random_test_c::new(string name = "random_test_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Create the sequence
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_random_test_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Random Test", "Build Phase", UVM_FULL) 

    //create sanity sequence
    //seq_h = ei_tdp_ram_single_port_sanity_sequence_c::type_id::create("seq_h");
    seq_h = ei_tdp_ram_dual_port_sanity_sequence_c::type_id::create("seq_h");
     
endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : end_of_elaboration_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Print the hierarchy of the test 
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_random_test_c::end_of_elaboration_phase(uvm_phase phase);
     
    //calling parent class end_of_elaboration_phase 
    super.end_of_elaboration_phase(phase); 
    `uvm_info("Random Test", "End-of-elaboration Phase", UVM_FULL) 
    print();
     
endfunction : end_of_elaboration_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Start the sequence 
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_random_test_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Random Test", "Run Phase", UVM_FULL)  

    //raise the objection
    phase.raise_objection(this);

    repeat(5)
    begin
    //configuring the sequence random operation
    if(!seq_h.randomize())
        `uvm_fatal("Random Test", "Sequence Randomization Failed")
    //start the sequence
    seq_h.start(env_h.agent_h.seqr_h);
    end

    //setting the drain time 
    phase.phase_done.set_drain_time(this, 210);
    //drop the objection
    phase.drop_objection(this);

endtask : run_phase 


