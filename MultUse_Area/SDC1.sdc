#Constraining PLL Base Clocks Manually
create_clock -period 50.000 -waveform {0.000 25.000} -name Ex_Clock [get_ports {Ex_Clock}]

#The Timing Analyzer determines the correct settings based on the IP Catalog instantiation of the PLL.
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

#Constraining PLL Output and Base Clocks Manually
create_generated_clock \
-name PLL_C0 \
-source [get_pins {MyPLL_inst|inclk0}] \
[get_pins {MyPLL_inst|c0}]\

create_generated_clock \
-name PLL_C1 \
-multiply_by 4 \
-source [get_pins {MyPLL_inst|inclk0}] \
[get_pins {MyPLL_inst|c1}]

create_clock -name Clock_Virtual_In_20M -period 50

create_clock -name Clock_Virtual_In_80M -period 12.5
create_clock -name Clock_Virtual_Out_80M -period 12.5

#create the input maximum delay for the data input to the
#FPGA that accounts for all delays specified
set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_A[*]}]
#create the input minimum delay for the data input to the
#FPGA that accounts for all delays specified
set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_A[*]}]

#create the input maximum delay for the data input to the
#FPGA that accounts for all delays specified
set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_B[*]}]
#create the input minimum delay for the data input to the
#FPGA that accounts for all delays specified
set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_B[*]}]

#create the input maximum delay for the data input to the
#FPGA that accounts for all delays specified
set_input_delay -clock Clock_Virtual_In_20M \
-max 10.7 \
[get_ports {Ex_Rst_n}]
#create the input minimum delay for the data input to the
#FPGA that accounts for all delays specified
set_input_delay -clock Clock_Virtual_In_20M \
-min 3.0 \
[get_ports {Ex_Rst_n}]


#create the output maximum delay for the data output from the
#FPGA that accounts for all delays specified
set_output_delay -clock Clock_Virtual_Out_80M \
-max  3.4\
[get_ports {Result[*]}]
#create the output minimum delay for the data output from the
#FPGA that accounts for all delays specified
set_output_delay -clock Clock_Virtual_Out_80M \
-min  1.0\
[get_ports {Result[*]}]




set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_A1[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_A1[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_B1[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_B1[*]}]

set_output_delay -clock Clock_Virtual_Out_80M \
-max  3.4\
[get_ports {Result1[*]}]

set_output_delay -clock Clock_Virtual_Out_80M \
-min  1.0\
[get_ports {Result1[*]}]


set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_A2[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_A2[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_B2[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_B2[*]}]

set_output_delay -clock Clock_Virtual_Out_80M \
-max  3.4\
[get_ports {Result2[*]}]

set_output_delay -clock Clock_Virtual_Out_80M \
-min  1.0\
[get_ports {Result2[*]}]


set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_A3[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_A3[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-max 3.4 \
[get_ports {Mult_In_B3[*]}]

set_input_delay -clock Clock_Virtual_In_80M \
-min 1.0 \
[get_ports {Mult_In_B3[*]}]

set_output_delay -clock Clock_Virtual_Out_80M \
-max  3.4\
[get_ports {Result3[*]}]

set_output_delay -clock Clock_Virtual_Out_80M \
-min  1.0\
[get_ports {Result3[*]}]