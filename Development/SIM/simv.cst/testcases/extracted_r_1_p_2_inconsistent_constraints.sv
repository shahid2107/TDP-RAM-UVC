class c_1_2;
    rand bit[0:0] we_b; // rand_mode = ON 
    rand bit[0:0] re_b; // rand_mode = ON 

    constraint c_wr_rd_pb_this    // (constraint_mode = ON) (/home/mahammadshahid.shaikh/Desktop/TDP_RAM/TDP-RAM-UVC/Development/SRC/seq_item/ei_tdp_ram_seq_item.sv:42)
    {
       (we_b != re_b);
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (/home/mahammadshahid.shaikh/Desktop/TDP_RAM/TDP-RAM-UVC/Development/SRC/sequences/ei_tdp_ram_single_port_sanity_sequence.sv:96)
    {
       (we_b == 1'h0);
       (re_b == 1'h0);
    }
endclass

program p_1_2;
    c_1_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0x10x1z10xz10x10z0z01xx1zx00x111xzxxxxxxzxzzxzxzzxxxxzxzzxxxzzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
