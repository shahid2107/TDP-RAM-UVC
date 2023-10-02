/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_reset_inbetween_p2_5_wr_test.sv    */ 
/* Title          : Reset Test for TDP RAM DUT                    */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 02/10/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_reset_inbetween_p2_5_wr_test_c extends ei_tdp_ram_base_test_c;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_reset_inbetween_p2_5_wr_test_c)

    //dual port sanity sequence declaration
    ei_tdp_ram_dual_port_sanity_sequence_c seq_h;

    //instance of virtual interface
    virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) vif;

    //user-defined constructor declaration
    extern function new(string name = "reset_inbetween_p2_5_wr_test_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);
    
    //end of elaboration phase method declaration
    extern function void end_of_elaboration_phase(uvm_phase phase);

    //run phase method declaration
    extern task run_phase(uvm_phase phase);

    //reset phase method declaration
    extern task reset_phase(uvm_phase phase);

endclass : ei_tdp_ram_reset_inbetween_p2_5_wr_test_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor declaration 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_reset_inbetween_p2_5_wr_test_c::new(string name = "reset_inbetween_p2_5_wr_test_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Create the sequence
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_reset_inbetween_p2_5_wr_test_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Reset inbetween P2 5 Wr Test", "Build Phase", UVM_FULL) 

    //extract virtual interface instance from config db
    uvm_config_db #(virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
        get(this, "", "vif", vif);

    //create sanity sequence
    seq_h = ei_tdp_ram_dual_port_sanity_sequence_c::type_id::create("seq_h");
     
endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : end_of_elaboration_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Print the hierarchy of the test 
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_reset_inbetween_p2_5_wr_test_c::end_of_elaboration_phase(uvm_phase phase);
     
    //calling parent class end_of_elaboration_phase 
    super.end_of_elaboration_phase(phase); 
    `uvm_info("Reset inbetween P2 Wr Test", "End-of-elaboration Phase", UVM_FULL) 
    print();
     
endfunction : end_of_elaboration_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Start the sequence 
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_reset_inbetween_p2_5_wr_test_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Reset inbetween P2 Wr Test", "Run Phase", UVM_FULL)  

    //raise the objection
    phase.raise_objection(this);

    //performing 5 transactions and writing to memory using port-a
    repeat(5)
    begin
        //configuring the sequence for port-b write operation
        //total number of transactions
        seq_h.no_of_transactions = 1;
        //port operations
        seq_h.port_a_op = NO_OP;
        seq_h.port_b_op = WR;
        seq_h.addr_random_b = 0;
        //start the sequence
        seq_h.start(env_h.agent_h.seqr_h);
     end
    //setting the drain time 
    phase.phase_done.set_drain_time(this, 210);
    //drop the objection
    phase.drop_objection(this);

endtask : run_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : reset_phase
//Parameters Passed   : phase
//Returned parameters : None
//Description         : Resetting the RAM in between transactions
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_reset_inbetween_p2_5_wr_test_c::reset_phase(uvm_phase phase);

    //raising the objection
    phase.raise_objection(this);
    //applying the initial reset
    vif.reset <= 1'b1;
    //applying the reset after some time
    #52 vif.reset <= 1'b0;
    //waiting for clock edge
    @(posedge vif.clk);
    //releasing the reset
    vif.reset <= 1'b1;
    //drop the objection
    phase.drop_objection(this);

endtask : reset_phase


