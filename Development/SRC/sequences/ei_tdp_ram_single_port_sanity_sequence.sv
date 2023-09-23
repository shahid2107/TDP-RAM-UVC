/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_single_port_sanity_sequence.sv     */ 
/* Title          : Single Port Sanity Sequence for Verification  */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 23/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//enum for port to use
typedef enum bit {PORT_A, PORT_B} ei_tdp_ram_port_e;

//enum for operation
typedef enum bit [1 : 0] {WR, RD, WR_RD, RD_WR} ei_tdp_ram_operation_e;

//class declaration
class ei_tdp_ram_single_port_sanity_sequence_c extends ei_tdp_ram_base_sequence_c;

    //factory registration of the class
    `uvm_object_utils(ei_tdp_ram_single_port_sanity_sequence_c)

    //object of transaction class
    ei_tdp_ram_seq_item_c tr_h;

    //variable for port to use
    ei_tdp_ram_port_e port;

    //variable for type of operation to be performed
    ei_tdp_ram_operation_e operation;

    //variable for total number of transaction
    int no_of_transactions;

    //local variable to store address
    local bit [`ADDR_WIDTH - 1 : 0] address_a;
    local bit [`ADDR_WIDTH - 1 : 0] address_b;

    //user-defined constructor declaration
    extern function new(string name = "single_port_seq_h");

    //body method declaration
    extern task body();

endclass : ei_tdp_ram_single_port_sanity_sequence_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_single_port_sanity_sequence_c::new(string name = "single_port_seq_h");
     
    //calling parent class constructor 
    super.new(name); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : body
//Parameters Passed   : None
//Returned parameters : None
//Description         : Start the sanity sequence for port mentioned
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_single_port_sanity_sequence_c::body();

    //repeat for total number of transactions
    repeat(no_of_transactions)
    begin
        //allocate memory to tr_h
        tr_h = ei_tdp_ram_seq_item_c::type_id::create("tr_h");

        //check port type as port-a
        if(port == PORT_A)
        begin
            //check if only write is to be performed
            if(operation == WR)
            begin
                //starting the sequence for write operation
                `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b0;})
            end
            //else check if only read is to be performed
            else if(operation == RD)
            begin
                //starting the sequence for write operation
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b0;})
            end
            //else check if write followed by read is to be performed
            else if(operation == WR_RD)
            begin
                //starting the sequence for write operation
                `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b0;})
                //store the local address
                address_a = tr_h.addr_a;
                //starting the sequence for read operation with same address
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b0; addr_a == address_a;})
            end
            //else check if read followed by write is to be performed
            else if(operation == RD_WR)
            begin
                //starting the sequence for read operation
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b0;})
                //store the local address
                address_a = tr_h.addr_a;
                //starting the sequence for write operation with same address
                `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b0; addr_a == address_a;})
            end
            //else invalid operation
            else
            begin
                `uvm_fatal("Single Port Seq", "Invalid Operation Type")
            end
        end
        //else check type as port-b
        else if(port == PORT_B)
        begin
            //check if only write is to be performed
            if(operation == WR)
            begin
                //starting the sequence for write operation
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0;})
            end
            //else check if only read is to be performed
            else if(operation == RD)
            begin
                //starting the sequence for write operation
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1;})
            end
            //else check if write followed by read is to be performed
            else if(operation == WR_RD)
            begin
                //starting the sequence for write operation
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0;})
                //store the local address
                address_b = tr_h.addr_b;
                //starting the sequence for read operation with same address
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1; addr_b == address_b;})
            end
            //else check if read followed by write is to be performed
            else if(operation == RD_WR)
            begin
                //starting the sequence for read operation
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1;})
                //store the local address
                address_b = tr_h.addr_b;
                //starting the sequence for write operation with same address
                `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0; addr_b == address_b;})
            end
            //else invalid operation
            else
            begin
                `uvm_fatal("Single Port Seq", "Invalid Operation Type")
            end
        end
        //else terminate
        else
        begin
            `uvm_fatal("Single Port Seq", "Invalid Port Type")
        end
    end

endtask : body
