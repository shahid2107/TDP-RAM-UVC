/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_driver.sv                          */ 
/* Title          : Driver for TDP RAM UVC                        */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//compiler directive for modport with clocking block
`define DRV_IF vif.driver_mod.driver_cb

//class declaration
class ei_tdp_ram_driver_c extends uvm_driver #(ei_tdp_ram_seq_item_c);

    //factory registration of the class
    `uvm_component_utils(ei_tdp_ram_driver_c)

    //callback registration
    `uvm_register_cb(ei_tdp_ram_driver_c, ei_tdp_ram_driver_cb_c)

    //instance of virtual interface
    virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) vif;

    //user-defined constructor declaration
    extern function new(string name = "drv_h", uvm_component parent = null);

    //build-phase method declaration
    extern function void build_phase(uvm_phase phase);

    //run-phase method declaration
    extern task run_phase(uvm_phase phase);

    //drive method to drive signals
    extern task ei_tdp_ram_drive_t();
    
    //reset drive method to drive all signals low
    extern task ei_tdp_ram_reset_drive_t();

endclass : ei_tdp_ram_driver_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name, parent 
//Returned parameters : None 
//Description         : User-defined constrictor to allocate memory 
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_driver_c::new(string name = "drv_h", uvm_component parent = null);
     
    //calling parent class constructor 
    super.new(name, parent); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : build_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Extract virtual interface instance from config db
////////////////////////////////////////////////////////////////////////
 
function void ei_tdp_ram_driver_c::build_phase(uvm_phase phase);
     
    //calling parent class build_phase 
    super.build_phase(phase); 
    `uvm_info("Driver", "Build Phase", UVM_FULL) 
    
    //extract virtual interface instance from config db
    uvm_config_db #(virtual ei_tdp_ram_interface_i #(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH)))::
        get(this, "", "vif", vif);

endfunction : build_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : run_phase 
//Parameters Passed   : phase 
//Returned parameters : None 
//Description         : Drive the transaction on interface
////////////////////////////////////////////////////////////////////////
 
task ei_tdp_ram_driver_c::run_phase(uvm_phase phase);
     
    //calling parent class run_phase 
    super.run_phase(phase); 
    `uvm_info("Driver", "Run Phase", UVM_FULL) 

    //forever loop to drive packets
    forever
    begin

        //wait for reset to be de-asserted
        wait(vif.resetn);

        //creating two-threads to monitor reset and drive normal packets
        fork : drv
            //thread-1 to monitor reset
            begin
                //wait for reset assertion
                wait(~vif.resetn);
                `uvm_info("Driver", "Reset Detected!! Driving All Signals Low", UVM_HIGH)

                //check if any transaction is working
                if(req != null)
                begin
                    `uvm_info("Driver", "Transaction Aborted due to reset", UVM_HIGH)
                    disable drv;
                    seq_item_port.item_done();
                end

                //calling reset drive method 
                ei_tdp_ram_reset_drive_t();
            end
            //thread-2 to drive packets received from sequencer
            begin
                //wait for positive edge of clock
                @(vif.driver_cb);

                //requesting new packet from sequencer
                seq_item_port.get_next_item(req);
                `uvm_info("Driver", $sformatf("Received a packet from\n%s", req.sprint()), UVM_FULL)
                //callback hook
                `uvm_do_callbacks(ei_tdp_ram_driver_c, ei_tdp_ram_driver_cb_c, ei_tdp_ram_modify_packet_t(req))

                //thread to drive the received packet
                begin : drv
                    ei_tdp_ram_drive_t();
                end

                //sending completion signal to sequencer
                seq_item_port.item_done();
                //releasing the req
                req = null;
            end
        join_any
        //disable both thread
        disable drv;

    end
     
endtask : run_phase 

////////////////////////////////////////////////////////////////////////
//Method name         : ei_tdp_ram_drive_t 
//Parameters Passed   : None
//Returned parameters : None
//Description         : Drive the packet to interface
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_driver_c::ei_tdp_ram_drive_t();

    //driving all signals low
    `DRV_IF.we_a   <= req.we_a;
    `DRV_IF.we_b   <= req.we_b;
    `DRV_IF.re_a   <= req.re_a;
    `DRV_IF.re_b   <= req.re_b;
    `DRV_IF.addr_a <= req.addr_a;
    `DRV_IF.addr_b <= req.addr_b;
    `DRV_IF.data_a <= req.data_a;
    `DRV_IF.data_b <= req.data_b;

endtask : ei_tdp_ram_drive_t

////////////////////////////////////////////////////////////////////////
//Method name         : ei_tdp_ram_reset_drive_t 
//Parameters Passed   : None
//Returned parameters : None
//Description         : Drive All signals to low
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_driver_c::ei_tdp_ram_reset_drive_t();

    //driving all signals low
    vif.we_a   <= 0;
    vif.we_b   <= 0;
    vif.re_a   <= 0;
    vif.re_b   <= 0;
    vif.addr_a <= 0;
    vif.addr_b <= 0;
    vif.data_a <= 0;
    vif.data_b <= 0;

endtask : ei_tdp_ram_reset_drive_t
