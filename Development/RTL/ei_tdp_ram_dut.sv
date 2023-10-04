/******************************************************************/ 
/*----------------------------------------------------------------*/ 
/* File name      : ei_tdp_ram_dut.sv                             */ 
/* Title          : DUT of TDP RAM                                */ 
/* Project        : TDP RAM UVC                                   */ 
/* Created on     : 16/09/2023                                    */ 
/* Developer      : Mahammadshahid Shaikh                         */ 
/* GID            : 158160                                        */ 
/******************************************************************/ 
/*----------------------------------------------------------------*/ 

//module declaration
module ei_tdp_ram_dut
    #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=10)
    (
        input clk, resetn,
        input [(DATA_WIDTH-1):0] data_a, data_b,
        input [(ADDR_WIDTH-1):0] addr_a, addr_b,
        input we_a, we_b,
        input re_a, re_b,
        output logic [(DATA_WIDTH-1):0] q_a, q_b
    );

    //variable for loop control
    integer i;

    //memory declaration
    bit [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

    //Port A block of operation
    always @ (posedge clk or negedge resetn)
    begin
        //checking for resetn
        if(!resetn)
        begin
            //drive output as low
            q_a <= 0;
            //resetting the whole memory
            for(i=0; i<(2**ADDR_WIDTH)-1; i=i+1)
            begin
                ram[i] = 0;
            end
        end
        //else performing the operation
        else
        begin
            //checking for write enable
            if (we_a) 
            begin
                //writing the data in the memory
                ram[addr_a] = data_a;
            end
            //checking for read enable
            if(re_a)
            begin
                //wrting the data on the read data bus
                q_a <= ram[addr_a];
            end
        end
    end 

    //Port B block of operation
    always @ (posedge clk or negedge resetn)
    begin
        //check for resetn
        if(!resetn)
        begin
            //driveing q_b to low
            q_b <= 0;
            //resetting the whole memory
            for(i=0; i<(2**ADDR_WIDTH)-1; i=i+1)
            begin
                ram[i] = 0;
            end
        end
        //else normal read write operation
        else
        begin
            //check for write operation
            if (we_b) 
            begin
                ram[addr_b] = data_b;
            end
            //check for read operation
            if(re_b)
            begin
                q_b <= ram[addr_b];
            end
        end
    end

//end of module
endmodule : ei_tdp_ram_dut



