/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_dual_port_sanity_sequence.sv       */ 
/* Title          : Dual Port Sequence for TDP RAM Verification   */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 23/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//enum for operation on port
typedef enum bit [3:0] {NO_OP, WR, RD} ei_tdp_ram_port_operation_e;

//class declaration
class ei_tdp_ram_dual_port_sanity_sequence_c extends ei_tdp_ram_base_sequence_c;

    //factory registration of class
    `uvm_object_utils(ei_tdp_ram_dual_port_sanity_sequence_c)

    //operation type on both port
    ei_tdp_ram_port_operation_e port_a_op;
    ei_tdp_ram_port_operation_e port_b_op;

    //variable for total number of transactions
    int no_of_transactions;

    //transaction class object
    ei_tdp_ram_seq_item_c tr_h;

    //local variable to store addresses
    bit [`ADDR_WIDTH - 1 : 0] address_a;
    bit [`ADDR_WIDTH - 1 : 0] address_b;
    
    //flag to select address to be random or specific
    bit addr_random_a;
    bit addr_random_b;

    //user-defined constructor declaration
    extern function new(string name = "dual_port_seq_h");

    //body method declaration
    extern task body();

endclass : ei_tdp_ram_dual_port_sanity_sequence_c

////////////////////////////////////////////////////////////////////////
//Method name         : new 
//Parameters Passed   : name
//Returned parameters : None 
//Description         : User-defined constructor to allocate memory
////////////////////////////////////////////////////////////////////////
 
function ei_tdp_ram_dual_port_sanity_sequence_c::new(string name = "dual_port_seq_h");
     
    //calling parent class constructor 
    super.new(name); 
     
endfunction : new 

////////////////////////////////////////////////////////////////////////
//Method name         : body
//Parameters Passed   : None
//Returned parameters : None
//Description         : Generate and send the packet to sequencer
////////////////////////////////////////////////////////////////////////

task ei_tdp_ram_dual_port_sanity_sequence_c::body();

    //repeat for total number of transaction
    repeat(no_of_transactions)
    begin

        //allocate memory to tr_h
        tr_h = ei_tdp_ram_seq_item_c::type_id::create("tr_h");

        //check type of operation and generate sequence accordingly
        case({port_b_op, port_a_op})

            //port-b no operation and port-a write operation
            {NO_OP, WR} :
                begin
                    if(!addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b0;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b0; addr_a == address_a;})
                    //store the address
                    address_a = tr_h.addr_a;
                end
            //port-b no operation and port-a read operation
            {NO_OP, RD} :
                begin
                    if(!addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b0;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b0; addr_a == address_a;})
                    //store the address
                    address_a = tr_h.addr_a;
                end
                        //port-b write and port-a no operation
            {WR, NO_OP} :
                begin
                    if(!addr_random_b)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0; addr_b == address_b;})
                    //store the address
                    address_b = tr_h.addr_b;
                end
            //port-b write and port-a write operation
            {WR, WR} :
                begin
                    if(!addr_random_b && !addr_random_b)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0;})
                    else if(!addr_random_b && addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0; addr_a == address_a;})
                    else if(addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0; addr_b == address_b;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b1; re_a == 1'b0; re_b == 1'b0; addr_a == address_a; addr_b == address_b;})
                    //store the addresses
                    address_a = tr_h.addr_a;
                    address_b = tr_h.addr_b;
                end
            //port-b write and port-a read operation
            {WR, RD} :
                begin
                    if(!addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b1; re_b == 1'b0;})
                    else if(!addr_random_b && addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b1; re_b == 1'b0; addr_a == address_a;})
                    else if(addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b1; re_b == 1'b0; addr_b == address_b;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b1; re_a == 1'b1; re_b == 1'b0; addr_b == address_b; addr_a == address_a;})
                    //store the addresses
                    address_a = tr_h.addr_a;
                    address_b = tr_h.addr_b;
                end
                        
            //port-b read and port-a no operation
            {RD, NO_OP} :
                begin
                    if(!addr_random_b)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1; addr_b == address_b;})
                    //store the address
                    address_b = tr_h.addr_b;
                end
            //port-b read and port-a write operation
            {RD, WR} :
                begin
                    if(!addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1;})
                    else if(!addr_random_b && addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1; addr_a == address_a;})
                    else if(addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1; addr_b == address_b;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b1; we_b == 1'b0; re_a == 1'b0; re_b == 1'b1; addr_a == address_a; addr_b == address_b;})
                    //store the addresses
                    address_a = tr_h.addr_a;
                    address_b = tr_h.addr_b;
                end
            //port-b read and port-a read operation
            {RD, RD} :
                begin
                    if(!addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b1;})
                    else if(!addr_random_b && addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b1; addr_a == address_a;})
                    else if(addr_random_b && !addr_random_a)
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b1; addr_b == address_b;})
                    else
                        `uvm_do_with(tr_h, {we_a == 1'b0; we_b == 1'b0; re_a == 1'b1; re_b == 1'b1; addr_a == address_a; addr_b == address_b;})
                    //store the addresses
                    address_a = tr_h.addr_a;
                    address_b = tr_h.addr_b;
                end
            //default for invalid values
            default :
                begin
                    `uvm_fatal("Dual Port Seq", "Invalid Operations")
                end

        endcase

    end

endtask : body
