#################################################################### 
## File name      : ei_tdp_ram_run.py                             ## 
## Title          : Python Script to execute VIP                  ## 
## Project        : TDP RAM UVC                                   ## 
## Created on     : 29/09/2023                                    ## 
## Developer      : Mahammadshahid Shaikh                         ## 
## GID            : 158160                                        ## 
#################################################################### 

#importing argphase library to take command line arguments
import argparse

#import os library to execute commands on terminal
import os

#import random as rand
import random as rand

#global list for passed and failed testcases
passed_testcases = {}
failed_testcases = {}

#class used for printing the status report in colored format
class colors:
    reset = '\033[0m'
    bold = '\033[01m'
    disable = '\033[02m'
    underline = '\033[04m'
    reverse = '\033[07m'
    strikethrough = '\033[09m'
    invisible = '\033[08m'
    class fg:
        black = '\033[30m'
        red = '\033[31m'
        green = '\033[32m'
    class bg:
        black = '\033[40m'
        cyan = '\033[46m'
        lightgrey = '\033[47m'

#function to print all the testcase
def print_testcases(testcase_list):
    
    print()
    print("Currently available testcases are : ")
    for i in range(0, len(testcase_list)):
        print(str(i + 1) + '. ' + testcase_list[i])
    print()

#show status method to show status testcases
def show_status():

    max_name_length = max(len(name) for name in testcase_list)
    equal_signs = '=' * (max_name_length + 43)      
    des_signs = '-' * (max_name_length + 43)      
    header = f'{" ID.":<8}{"TESTCASE NAME":<{max_name_length+8}}{" SEED":<11}TEST STATUS'
   
    print(equal_signs)
    print(header)
    print(equal_signs)

    #loop to check for each testcases
    for i in range (0, len(testcase_list)):
        testcase = testcase_list[i]
        #check if testcase is available in pass or fail dictionary
        if testcase in passed_testcases or testcase in failed_testcases:
            #check if available in pass
            if testcase in passed_testcases:
                for j in passed_testcases[testcase]:
                    formatted_name = f' {i+1}.\t{testcase}{" " * (max_name_length - len(testcase))}\t\t{str(j)}'.ljust(max_name_length + 1)
                    print(formatted_name + '\t', colors.bold, colors.fg.green, colors.bg.cyan,'PASSED', colors.reset)
            #check if available in fail
            if testcase in failed_testcases:
                for j in failed_testcases[testcase]:
                    formatted_name = f' {i+1}.\t{testcase}{" " * (max_name_length - len(testcase))}\t\t{str(j)}'.ljust(max_name_length + 1)
                    print(formatted_name + '\t', colors.bold, colors.fg.red, colors.bg.lightgrey, 'FAILED', colors.reset)
        else:
            formatted_name = f' {i+1}.\t{testcase}{" " * (max_name_length - len(testcase))}\t\t-'.ljust(max_name_length + 1)
            print(formatted_name + '\t', colors.bold, colors.fg.black, colors.bg.lightgrey,'NOT TESTED', colors.reset)
        print(des_signs)
    print(equal_signs)

#run_testcase method to execute single testcase
def run_testcase(testname = 'ei_tdp_ram_base_test', verbosity = ''):

    #seed variable
    seed = 0
    #checking if manual-seed is available
    if args.manual_seed:
        #store that seed
        seed = int(str(args.manual_seed))
    else:
        #else random seed
        seed = rand.randint(0, 1000)

    testcase = 'Running Testcase : ' + testname 
    filename = testname + '_' + str(seed)

    print()
    print('=' * len(testcase))
    print(testcase)
    print("Seed - " + str(seed))

    #initial command for run
    cmd = './simv ' + '+UVM_TESTNAME=' + testname + '_c ' + '+UVM_VERBOSITY=' + verbosity + ' +ntb_random_seed=' + str(seed) + ' +UVM_TIMEOUT=200000'

    #when not in debug mode
    if args.debug == False:
        #open output
        with os.popen(cmd) as output:
            #store the output
            cmd_output = output.read()
            #check if are not storing output in logfile
            if args.logfile == False:
                #print the output
                print(cmd_output)
                #check if testcase has been passed
                if 'TESTCASE PASSED' in cmd_output:
                    #append the testcase in passed_testcase
                    if testname in passed_testcases:
                        passed_testcases[testname].append(seed)
                    else:
                        passed_testcases[testname] = []
                        passed_testcases[testname].append(seed)
                elif 'TESTCASE FAILED' in cmd_output:
                    #append in failed testcase 
                    if testname in failed_testcases:
                        failed_testcases[testname].append(seed)
                    else:
                        failed_testcases[testname] = []
                        failed_testcases[testname].append(seed)

            else:
                #else open log file in write mode
                with open(f'./output_logs/{filename}.log', 'w') as f:
                    #write in file
                    f.write(cmd_output)
                print('-' * len(testcase))
                print(' ' * (int(len(testcase) / 2) - 7) + ' TEST STATUS ' + ' ' * (int(len(testcase) / 2) - 6))
                print('-' * len(testcase))
                #check if testcase passed
                if 'TESTCASE PASSED' in cmd_output:
                    print(' ' * (int(len(testcase) / 2) - 9) + ' TESTCASE PASSED ' + ' ' * int(len(testcase) / 2 - 6))
                    if testname in passed_testcases:
                        passed_testcases[testname].append(seed)
                    else:
                        passed_testcases[testname] = []
                        passed_testcases[testname].append(seed)
                elif 'TESTCASE FAILED' in cmd_output:
                    print(' ' * (int(len(testcase) / 2) - 9) + ' TESTCASE FAILED ' + ' ' * int(len(testcase) / 2 - 6))
                    if testname in failed_testcases:
                        failed_testcases[testname].append(seed)
                    else:
                        failed_testcases[testname] = []
                        failed_testcases[testname].append(seed)

                print('-' * len(testcase))
                print('=' * len(testcase))
    else:
        #else in debug mode
        #check if logfile
        if args.logfile == True:
            cmd = cmd + ' > output_logs/' + filename + '.log'
        #execute the command
        os.system(cmd)
        print(cmd)

    #check if for functional coverage or for regression .vdb file is to be stored
    if args.funcov == True or args.execute == 'regression':
        #make directory if not available
        os.makedirs('vdb_files', exist_ok=True)
        #store in vdb files folder
        cmd = f'mv simv.vdb vdb_files/{filename}.vdb'
        print(cmd)
        #execute the command
        os.system(cmd)

#function to compile the program
def compile():
    
    print("Compiling the VIP/UVC")

    #'uvm' command alias
    uvm = 'vcs -full64 -debug_access+r -sverilog +acc +vpi +incdir+/home/hitesh.patel/UVM/UVM_1.2/src /home/hitesh.patel/UVM/UVM_1.2/src/uvm.sv /home/hitesh.patel/UVM/UVM_1.2/src/dpi/uvm_dpi.cc -CFLAGS -DVCS -assert svaext'
    top = '../TOP/ei_tdp_ram_top.sv'

    #command to compile the VIP
    cmd = uvm + ' -timescale=1ns/1ns' + ' +vcs+lic+wait -f compile.f ' + top + ' +define+UVM_REPORT_DISABLE_FILE_LINE' 
    #execute the command on terminal
    os.system(cmd)

    #print the command if debug activated
    if args.debug == True:
        print("Compiling the VIP/UVC with below command :\n" + cmd)

#function to run testcases
def run():
    
    #set the verbosity as MEDIUM if not passed from CLI
    if args.verbosity == False:
        verbosity = "MEDIUM"
    #fetch verbosity from CLI if available
    else:
        verbosity = str(args.verbosity).upper()

    #check if logfile is to be created
    if args.logfile != False:
        #make the directory
        os.makedirs('output_logs', exist_ok=True)
    
    #initial how many times each testcase is to be executed
    times = 1;
    #check if available else only 1
    if args.times:
        times = int(str(args.times))

    #check if only single testcase is to be executed passed from command line
    if args.testname == None:
        
        #call function to print all the testcases
        print_testcases(testcase_list)
        
        #asking user to enter testcases to be executed
        run_test_input = input('Enter Testcase Number seperated by comma to run (\'all\' to run all testcases): ')
        
        #check if user entered anything
        if run_test_input != '':

            #check to see if all testcases to be run
            if run_test_input == 'all':
                #loop to select each testcases
                for i in range(0, len(testcase_list)):
                    #loop to run current testcase multiple times
                    for j in range(0, times):
                        #call run_testcase method to run the current testcase
                        run_testcase(testcase_list[i], verbosity)
            else :
                #else bifurcate testcases
                run_test_input = run_test_input.split(',')
                #loop to run mentioned testcases
                for i in range(0, len(run_test_input)):
                    #loop to run current testcase multiple times
                    for j in range(0, times):
                        #call run testcase method to run the current testcase
                        run_testcase(testcase_list[int(run_test_input[i]) - 1], verbosity)
        else:
            #else run the base test
            run_testcase('ei_tdp_ram_base_test', verbosity)

    else:
        #else execute that testcase mentioned from command line
        #check if available in list
        if str(args.testname) in testcase_list:
            #call run_testcase method for that tetscase
            run_testcase(str(args.testname), verbosity)
        else:
            #else invalid case
            print("Invalid testcase " + str(args.testname) )

    #check if status is to be shown
    if args.status == True:
        #call function to show status
        show_status()

#function to open waveform for a testcase
def waveform():
    #printing all testcases
    print_testcases(testcase_list)
    run_test_input = input('select any testcase from above to observe waveform: ')

    #seed variable
    seed = 0
    #checking if manual-seed is available
    if args.manual_seed:
        #store that seed
        seed = int(str(args.manual_seed))
    else:
        #else random seed
        seed = rand.randint(0, 1000)

    #check if not null
    if run_test_input != '':
        #create a command
        cmd = './simv +UVM_TESTNAME=' + testcase_list[int(run_test_input) - 1] + '_c +ntb_random_seed=' + str(seed) + ' -gui'
        #execute the command
        os.system(cmd)

#main function
def main():

    #set a global variable for args
    global args
    
    #setting different command line arguments
    parser = argparse.ArgumentParser(description="Python script to execute TDP RAM UVC")
    
    #command line argument for execution of VIP
    parser.add_argument("-e", "--execute", choices=["compile", "run", "compile_and_run", "waveform", "regression"], help="Type of Execution :\n1. compile\n2. run\n3. compile_and_run\n4. waveforms\n5. regression")
    
    #command line argument for verbosity during run
    parser.add_argument("-v", "--verbosity", choices=["NONE", "LOW", "MEDIUM", "HIGH", "FULL", "DEBUG"], help="Verbosity Type :\n1. NONE\n2. LOW\n3. MEDIUM\n4. HIGH\n5. FULL\n6. DEBUG")
    
    #command line argument to have functional coverage
    parser.add_argument("-fc", "--funcov", action="store_true", help="To add functional coverage")
    
    #command line argument to haver code cpverage
    parser.add_argument("-cc", "--codecov", action="store_true", help="To add code coverage")
    
    #command line argument to have logfile
    parser.add_argument("-l", "--logfile", action="store_true", help="To create log file of output")
    
    #command line argument to give testcase name from command line
    parser.add_argument("-n", "--testname", help="To execute testcase mentioned from CLI input")
    
    #command line argument to show status of all testcases run at the end
    parser.add_argument("-s", "--status", action="store_true", help="To show status pf each testcases at the end of simulation")
    
    #command line argument to show executed command to debug
    parser.add_argument("-db", "--debug", action="store_true", help="To see executed command")

    #command line argument to pass manual seed
    parser.add_argument("-ms", "--manual_seed", help="To select seed for all testcases")

    #command line argument to run total number of times 
    parser.add_argument("-t", "--times", help="To select how many times each testcases is to be executed")

    #storing arguments in args
    args = parser.parse_args()

    #check if command line argument available fr execution
    if args.execute:
        
        #check if we want to compile only call compile function
        if args.execute == "compile":
            compile()
        
        #check if want to run only call run function
        elif args.execute == "run":
            run()
        
        #check if want to do both compile and run 
        elif args.execute == "compile_and_run" or args.execute == "regression":
            #fist step compile the VIP/UVC using compile function
            compile()
            #run function call to execute testcases
            run()
            #check if regression is activated then generate the report
            if args.execute == "regression":
                #create command for generating report
                cmd = 'urg -dir vdb_files/*.vdb'
                #execute command on terminal
                os.system(cmd)
        
        #check if waveforms to be opened
        elif args.execute == "waveform":
            waveform()
        
    #else ask the user to give command what to execute
    else:
        print("Please choose an option:")
        print("1. Compile")
        print("2. Run")
        print("3. Compile and Run")
        print("4. Generate Waveform")
        print("5. Run Regression Tests")
        choice = input("Enter the number of your choice: ")

        #if user wants to compile only
        if choice == "1":
            compile()
        
        #if user wants to run only
        elif choice == "2":
            run()

        #if user wants compile and run or regression
        elif choice == "3" or choice == "5":
            compile()
            run()
            #check if regression is activated then generate the report
            if choice == "5":
                #create command for generating report
                cmd = 'urg -dir vdb_files/*.vdb'
                #execute command on terminal
                os.system(cmd)

        #if user wants to see waveform
        elif choice == "4":
            waveform()
        
        #else invalid option
        else:
            print("Invalid choice. Please choose a valid option.")

#testcase list
testcase_list = [ 
"ei_tdp_ram_p1_sanity_test", 
"ei_tdp_ram_p2_sanity_test", 
"ei_tdp_ram_p1_p2_sanity_test",
"ei_tdp_ram_p1_wr_p1_p2_rd_test",
"ei_tdp_ram_p2_wr_p1_p2_rd_test",
"ei_tdp_ram_p1_wr_whole_rd_test",
"ei_tdp_ram_p2_wr_whole_rd_test",
"ei_tdp_ram_p1_wr_with_wr_en_low_test",
"ei_tdp_ram_p2_wr_with_wr_en_low_test",
"ei_tdp_ram_p1_rd_with_rd_en_low_test",
"ei_tdp_ram_p2_rd_with_rd_en_low_test",
"ei_tdp_ram_p1_5_wr_p1_5_rd_test",
"ei_tdp_ram_p2_5_wr_p2_5_rd_test",
"ei_tdp_ram_random_test",
"ei_tdp_ram_p1_b2b_wr_p1_rd_test",
"ei_tdp_ram_p2_b2b_wr_p2_rd_test",
"ei_tdp_ram_reset_inbetween_p1_5_wr_test",
"ei_tdp_ram_reset_inbetween_p2_5_wr_test",
"ei_tdp_ram_reset_inbetween_p1_5_rd_test",
"ei_tdp_ram_reset_inbetween_p2_5_rd_test",
"ei_tdp_ram_p1_wr_p2_rd_same_addr_test",
"ei_tdp_ram_p2_wr_p1_rd_same_addr_test"
]

#execute only if main
if __name__ == "__main__":
    main()

