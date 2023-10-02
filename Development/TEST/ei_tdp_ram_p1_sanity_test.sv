/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_p1_sanity_test.sv                  */ 
/* Title          : Sanity Test for Port-1                        */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_p1_sanity_test_c extends ei_tdp_ram_base_test_c;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_p1_sanity_test_c)

    //dual port sanity sequence declaration
    ei_tdp_ram_dual_port_sanity_sequence_c seq_h;

    //user-defined constructor declaration
    extern function new(string name = "p1_sanity_test_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);
    
    //end of elaboration phase method declaration
    extern function void end_of_elaboration_phase(uvm_phase phase);

    //run phase method declaration
    extern task run_phase(uvm_phase phase);

endclass : ei_tdp_ram_p1_sanity_test_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor declaration 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_p1_sanity_test_c::new(string name = "p1_sanity_test_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Create the sequence
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_p1_sanity_test_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("P1 Sanity Test", "Build Phase", UVM_FULL) 

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
 
function void ei_tdp_ram_p1_sanity_test_c::end_of_elaboration_phase(uvm_phase phase);
     
    //calling parent class end_of_elaboration_phase 
    super.end_of_elaboration_phase(phase); 
    `uvm_info("P1 Sanity Test", "End-of-elaboration Phase", UVM_FULL) 
    print();
     
endfunction : end_of_elaboration_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Start the sequence 
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_p1_sanity_test_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("P1 Sanity Test", "Run Phase", UVM_FULL)  

    //raise the objection
    phase.raise_objection(this);

    //configuring the sequence for port-a write operation
    //total number of transactions
    seq_h.no_of_transactions = 1;
    //port operations
    seq_h.port_a_op = WR;
    seq_h.port_b_op = NO_OP;
    seq_h.addr_random_a = 0;
    //start the sequence
    seq_h.start(env_h.agent_h.seqr_h);

    //configuring the sequence for port-a read operation
    //total number of transactions
    seq_h.no_of_transactions = 1;
    //port operations
    seq_h.port_a_op = RD;
    seq_h.port_b_op = NO_OP;
    seq_h.addr_random_a = 1;
    seq_h.address_a = seq_h.tr_h.addr_a;
    //start the sequence
    seq_h.start(env_h.agent_h.seqr_h);

    //setting the drain time 
    phase.phase_done.set_drain_time(this, 210);
    //drop the objection
    phase.drop_objection(this);

endtask : run_phase 

