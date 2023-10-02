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

    //events for sampling
    uvm_event reset_sample;
    uvm_event p1_wr_sample;
    uvm_event p1_rd_sample;
    uvm_event p2_wr_sample;
    uvm_event p2_rd_sample;

    //storing last values
    bit last_reset;
    bit last_wr_a;
    bit last_wr_b;
    bit last_rd_a;
    bit last_rd_b;

    //analysis imp to receive packet from monitor
    uvm_analysis_imp #(ei_tdp_ram_seq_item_c, ei_tdp_ram_subscriber_c) sub_imp;

    //covergroup for coverage
    covergroup ei_tdp_ram_coverage;

        //coverpoint for resetn
        cp_resetn : coverpoint vif.resetn iff(reset_sample.is_on())
        {
            bins resetn[2] = {0,1};
        }

        //coverpoint for we_a
        cp_we_a : coverpoint tr_h.we_a iff(p1_wr_sample.is_on())
        {
            bins we_a[2] = {0,1};
        }

        //coverpoint for rd_a
        cp_re_a : coverpoint tr_h.re_a iff(p1_rd_sample.is_on())
        {
            bins re_a[2] = {0,1};
        }

        //coverpoint for we_b
        cp_we_b : coverpoint tr_h.we_b iff(p2_wr_sample.is_on())
        {
            bins we_b[2] = {0,1};
        }

        //coverpoint for re_b
        cp_re_b : coverpoint tr_h.re_b iff(p2_rd_sample.is_on())
        {
            bins re_b[2] = {0,1};
        }

        //coverpoint for addr_a
        cp_addr_a : coverpoint tr_h.addr_a iff(p1_wr_sample.is_on() or p1_rd_sample.is_on())
        {
            bins addr_a[64] = {[0:$]};
        }

        //coverpoint for addr_b
        cp_addr_b : coverpoint tr_h.addr_b iff(p2_wr_sample.is_on() or p2_rd_sample.is_on())
        {
            bins addr_b[64] = {[0:$]};
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

    //thread to check reset in background
    fork
        begin
            forever
            begin
                //wait for reset to be asserted
                @(negedge vif.resetn);
                //trigger reset sample
                reset_sample.trogger();
                //reset other events
                p1_wr_sample.reset();
                p1_rd_sample.reset();
                p2_wr_sample.reset();
                p2_rd_sample.reset();
                //call sample method
                ei_tdp_ram_coverage.sample();
                //reset for reset sample event
                reset_sample.reset();
                //store last reset
                last_reset = 1'b0;
            end
        end
    join_none

    //loop running forever
    forever
    begin
        //wait for queue to get filled
        wait(queue.size() > 0);

        //pop the packet in tr_h
        tr_h = queue.pop_front();

        //check for reset sample
        if(vif.resetn && !last_reset)
        begin
            //trigger event for reset sample
            reset_sample.trigger();
            //store last reset
            last_reset = 1'b1;
        end

        //check for p1 write signals
        if(tr_h.we_a)
        begin
            //trigger the event for p1 wr
            p1_wr_sample.trigger();
            //store last_we_a
            last_we_a = 1'b1;
        end
        //else check last was 1
        else if(!tr_h.we_a && last_we_a)
        begin
            //trigger the event for p1 wr
            p1_wr_sample.trigger();
            //store last we_a
            last_we_a = 1'b0;
        end
    end
     
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

endfunction : write

