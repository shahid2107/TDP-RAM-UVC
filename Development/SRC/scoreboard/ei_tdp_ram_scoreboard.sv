/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_scoreboard.sv                      */ 
/* Title          : Scoreboard for TDP RAM UVC                    */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//class declaration
class ei_tdp_ram_scoreboard_c extends uvm_scoreboard;

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_scoreboard_c)

    //local memory of scoreboard
    local bit [`DATA_WIDTH - 1 : 0] scb_mem [2**`ADDR_WIDTH];

    //queue to store packets of monitor
    ei_tdp_ram_seq_item_c queue[$];

    //transaction class to check packet
    ei_tdp_ram_seq_item_c tr_h;

    //analysis imp for receiving packet from monitor
    uvm_analysis_imp #(ei_tdp_ram_seq_item_c, ei_tdp_ram_scoreboard_c) scb_imp;

    //instance of virtual interface
    virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) vif;

    //user-defined constructor declaration
    extern function new(string name = "scb_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);

    //run-phase method declaration
    extern task run_phase(uvm_phase phase);

    //write method declaration
    extern function write(ei_tdp_ram_seq_item_c tr_h);

    //report phase method declaration
    extern function void report_phase(uvm_phase phase);

endclass : ei_tdp_ram_scoreboard_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_scoreboard_c::new(string name = "scb_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Extract vif from config db and allocate memory to imp
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_scoreboard_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Scoreboard", "Build Phase", UVM_FULL) 

    //extract vif from config db
    uvm_config_db #(virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
        get(this, "", "vif", vif);

    //allocate memory to scb_imp
    scb_imp = new("scb_imp", this);
     
endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : To check data integrity of packets
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_scoreboard_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Scoreboard", "Run Phase", UVM_FULL) 

    //creating a thread to reset memory when reset arrives
    fork
        begin
            forever
            begin
                //wait for reset to arrive
                wait(~vif.resetn);

                `uvm_info("Scoreboard", "Reset detected!! Resetting the memory", UVM_HIGH)

                for(int i = 0; i < 2**`ADDR_WIDTH; i++)
                begin
                    scb_mem[i] = 0;
                end

                //wait for reset to be deasserted
                wait(vif.resetn);
            end
        end
    join_none

    //forever loop to check each transaction
    forever
    begin
        //wait for queue to get filled
        wait(queue.size() > 0);

        //extract the packet from queue
        tr_h = queue.pop_front();

        //checking write enable for port A
        if(tr_h.we_a)
        begin
            `uvm_info("Scoreboard", "(Port A)Writing in Scoreboard Memory", UVM_DEBUG)
            //writing in scoreboard memory
            scb_mem[tr_h.addr_a] = tr_h.data_a;
        end
        
        //checking for read enable for port A
        if(tr_h.re_a)
        begin
            `uvm_info("Scoreboard", "(Port B)Reading from Scoreboard Memory", UVM_DEBUG)
            //comparing scoreboard memory and actual data received
            if(scb_mem[addr_a] != tr_h.out_a)
            begin
                `uvm_error("Scoreboard Error", "Expected Read Data(Port A) is not matching with Actual Data(Port A)")
            end
            else
            begin
                `uvm_info("Scoreboard", "Expected Read Data(Port A) is matching with Actual Data(Port A)", UVM_FULL)
            end
        end

        //checking write enable for port B
        if(tr_h.we_b)
        begin
            `uvm_info("Scoreboard", "(Port B)Writing in Scoreboard Memory", UVM_DEBUG)
            //writing in scoreboard memory
            scb_mem[tr_h.addr_b] = tr_h.data_b;
        end

        //checking for read enable for port B
        if(tr_h.re_b)
        begin
            `uvm_info("Scoreboard", "(Port B)Reading from Scoreboard Memory", UVM_DEBUG)
            //comparing scoreboard memory and actual data received
            if(scb_mem[addr_b] != tr_h.out_b)
            begin
                `uvm_error("Scoreboard Error", "Expected Read Data(Port B) is not matching with Actual Data(Port B)")
            end
            else
            begin
                `uvm_info("Scoreboard", "Expected Read Data(Port B) is matching with Actual Data(Port B)", UVM_FULL)
            end
        end
    end
     
endtask : run_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : write 
//Parameters Passed   : tr_h
//Returned parameters : None
//Description         : Receiving the packet from Monitor
////////////////////////////////////////////////////////////////////////

function ei_tdp_ram_scoreboard_c::write(ei_tdp_ram_seq_item_c tr_h);

    `uvm_info("Scoreboard", $sformatf("Received a packet from Monitor\n%s", tr_h.sprint()), UVM_FULL)
    //storing the packet in the queue
    queue.push_back(tr_h);

endfunction : write

////////////////////////////////////////////////////////////////////////
//Method name         : report_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : To print the report of testcase 
////////////////////////////////////////////////////////////////////////
 
function void report_phase(uvm_phase phase);
     
    //creating a report server
    uvm_report_server ei_tdp_ram_server_h;

    //calling parent class report_phase 
    super.report_phase(phase); 
    `uvm_info("Scoreboard", "Report Phase", UVM_FULL) 
    
    //allocating memory to sever
    ei_tdp_ram_server_h = uvm_report_server::get_server();

    //check of any errors
    if(ei_tdp_ram_server_h.get_severity_count(UVM_ERROR) > 0)
    begin
        `uvm_info("Scoreboard Report", "--------------------------------", UVM_NONE)
        `uvm_info("Scoreboard Report", "----     TESTCASE PASSED    ----", UVM_NONE)
        `uvm_info("Scoreboard Report", "--------------------------------", UVM_NONE)
    end
    else
    begin
        `uvm_info("Scoreboard Report", "--------------------------------", UVM_NONE)
        `uvm_info("Scoreboard Report", "----     TESTCASE FAILED    ----", UVM_NONE)
        `uvm_info("Scoreboard Report", "--------------------------------", UVM_NONE)
    end

endfunction : report_phase 
