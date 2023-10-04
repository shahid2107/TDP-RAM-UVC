**TDP RAM UVC**

**RAM Specification:**

  - Memory Size       : 1 KBytes
  - Address Range     : 0x000 to 0x3FF
  - Address Bus Width : 10
  - Data Bus Width    : 8
  - Byte Size Memory
  - Dual Port Memory
  - Two separate ports
  - Simultaneously Write and Read all combinations possible

**Signals of TDP RAM DUT:**

Input Signals of DUT:

  - we_a
  - re_a
  - addr_a
  - data_a
  - we_b
  - re_b
  - addr_b
  - data_b

Output Signals of DUT:

  - q_a
  - q_b

**Architecture For UVC**

![image](https://github.com/shahid2107/TDP-RAM-UVC/assets/86091931/b84cf6b4-2891-45d1-9b32-b3bd7b38fef7)

**Verification Flow**

  - A Top Module will generate clock signals and will create physical interface and will invoke the base test.
  - A base test will be overridden with a testcase to be executed at the run time with command line argument +UVM_TESTNAME=testcase_name.
  - A base test will create the Environment for verification.
  - Next testcase test will add callback or report catcher if required and will do the changes for run time.
  - Hierarchically all components will be created and will be connected using TLM ports.
  - In the run phase testcase will invoke the sequence and stimulus will be generated and will be given to sequencer.
  - A Sequencer will send the packet to drive to on interface using virtual interface and driver will drive the received packet.
  - Next DUT will respond to Driver's input via Interface.
  - All the activity will be monitored by Monitor component which will send the packet to scoreboard and subscriber.
  - A scoreboard will be used to check the data integrity of packet received from monitor and check with internal memory in scoreboard.
  - A subscriber will be used to generate functional coverage for simulation.
  - Assertions will be used to monitor signal level acivities on interface.

**Python Commands To Execute UVC**

usage: ei_tdp_ram_run.py [-h]
                         
                         [-e {compile,run,compile_and_run,waveform,regression}]
                         
                         [-v {NONE,LOW,MEDIUM,HIGH,FULL,DEBUG}] [-fc] [-cc]
                         
                         [-l] [-n TESTNAME] [-s] [-db] [-ms MANUAL_SEED]
                         
                         [-t TIMES]


Python script to execute TDP RAM UVC


optional arguments:

  -h, --help            show this help message and exit
  
  -e {compile,run,compile_and_run,waveform,regression}, --execute {compile,run,compile_and_run,waveform,regression}
                        Type of Execution : 1. compile 2. run 3.
                        compile_and_run 4. waveforms 5. regression
  
  -  v {NONE,LOW,MEDIUM,HIGH,FULL,DEBUG}, --verbosity {NONE,LOW,MEDIUM,HIGH,FULL,DEBUG}
                        Verbosity Type : 1. NONE 2. LOW 3. MEDIUM 4. HIGH 5.                      
                        FULL 6. DEBUG
  
  -fc, --funcov         To add functional coverage
  
  -cc, --codecov        To add code coverage
  
  -l, --logfile         To create log file of output
  
  -n TESTNAME, --testname TESTNAME
                        To execute testcase mentioned from CLI input
  
  -s, --status          To show status pf each testcases at the end of
                        simulation
  
  -db, --debug          To see executed command
  
  -ms MANUAL_SEED, --manual_seed MANUAL_SEED
                        To select seed for all testcases

  -t TIMES, --times TIMES
                        To select how many times each testcases is to be
                        executed

**Directory Structure**

|-|TDP-RAM-UVC

|--|-Development

|---|--SIM

|----|---csrc

|-----|----diag

|---|--ENV

|---|--|--- ei_tdp_ram_env.sv

|---|--RTL

|---|--|--- ei_tdp_ram_dut.sv

|---|--SRC

|----|---agent

|----|---|--- ei_tdp_ram_agent.sv

|----|---|--- ei_tdp_ram_monitor.sv

|----|---|--- ei_tdp_ram_sequencer.sv

|----|---|--- ei_tdp_ram_driver.sv

|----|---interface

|----|---|--- ei_tdp_ram_interface.sv

|----|---scoreboard

|----|---|--- ei_tdp_ram_scoreboard.sv

|----|---seq_item

|----|---|--- ei_tdp_ram_seq_item.sv

|----|---sequences

|----|---|--- ei_tdp_ram_base_sequence.sv

|----|---|--- ei_tdp_ram_sanity_sequence.sv

|----|---|--- ei_tdp_ram_single_port_sanity_sequence.sv

|----|---|--- ei_tdp_ram_dual_port_sanity_sequence.sv

|----|---subscriber

|----|---|--- ei_tdp_ram_subscriber.sv

|----|---callback

|----|---|--- ei_tdp_ram_driver_cb.sv

|----|---assertions

|----|---|--- ei_tdp_ram_assertion.sv

|---|--TEST

|---|--|--- ei_tdp_ram_base_test.sv

|---|--|--- ei_tdp_ram_reset_inbetween_p1_5_wr_test.sv

|---|--|--- ei_tdp_ram_p1_sanity_test.sv

|---|--|--- ei_tdp_ram_p1_5_wr_p1_5_rd_test.sv

|---|--|--- ei_tdp_ram_p1_p2_sanity_test.sv

|---|--|--- ei_tdp_ram_p1_rd_with_rd_en_low_test.sv

|---|--|--- ei_tdp_ram_p1_wr_whole_rd_test.sv

|---|--|--- ei_tdp_ram_p1_wr_with_wr_en_low_test.sv

|---|--|--- ei_tdp_ram_p2_sanity_test.sv

|---|--|--- ei_tdp_ram_p2_wr_p1_rd_same_addr_test.sv

|---|--|--- ei_tdp_ram_p2_b2b_wr_p2_rd_test.sv

|---|--|--- ei_tdp_ram_p2_wr_p1_p2_rd_test.sv

|---|--|--- ei_tdp_ram_p2_wr_whole_rd_test.sv

|---|--|--- ei_tdp_ram_p2_wr_with_wr_en_low_test.sv

|---|--|--- ei_tdp_ram_random_test.sv

|---|--|--- ei_tdp_ram_reset_inbetween_p1_5_rd_test.sv

|---|--|--- ei_tdp_ram_reset_inbetween_p2_5_rd_test.sv

|---|--|--- ei_tdp_ram_reset_inbetween_p2_5_wr_test.sv

|---|--|--- ei_tdp_ram_p1_b2b_wr_p1_rd_test.sv

|---|--|--- ei_tdp_ram_p1_wr_p1_p2_rd_test.sv

|---|--|--- ei_tdp_ram_p1_wr_p2_rd_same_addr_test.sv

|---|--|--- ei_tdp_ram_p2_5_wr_p2_5_rd_test.sv

|---|--|--- ei_tdp_ram_p2_rd_with_rd_en_low_test.sv

|---|--|--- ei_tdp_ram_reset_test.sv

|---|--TOP

|---|--|--- ei_tdp_ram_package.sv

|---|--|--- ei_tdp_ram_top.sv

|--|-Documentation

|---|--Coverage_Report

|---|--Project_overall_individual_status_and_MoM

|---|--Verification_Plan

