
# Constrain clock port TCK with a 100-ns requirement
# create_clock -period 100 [get_ports {TCK}]
create_clock -period 200 [get_ports {syn_clk_H}]


# Constrain clock port cal_blk_clk_40MHz_H with a 100-ns requirement
create_clock -period 25 [get_ports {cal_blk_clk_40MHz_H}]

# Constrain clock port rxa_clk80MHz_H with a 12.5-ns requirement
create_clock -period 12.5 -name gxbclk0_80MHz_H [get_ports {gxbclk0_80MHz_H}]
#create_clock -period 12.5 -name gxbclk1_80MHz_H [get_ports {gxbclk1_80MHz_H}]

# Differential Data Clock Output. LVDS clock at the DAC sample rate. 
#create_clock -period 3.125 -name dac_dco [get_ports {dac_lvds_dco_H}]


create_clock -period 25 -name adc1_adclk_H [get_ports adc1_adclk_H] 
create_clock -period 3.125 -name adc1_lclk_H [get_ports adc1_lclk_H] 

create_clock -period 25 -name adc2_adclk_H [get_ports adc2_adclk_H] 
create_clock -period 3.125 -name adc2_lclk_H [get_ports adc2_lclk_H] 

# SPI IF to RFIS_COM
create_clock -period 200 -name rxa_spi_clk_in_H [get_ports rxa_spi_clk_in_H] 


# Automatically apply a generate clock on the output of phase-locked loops (PLLs)
# This command can be safely left in the SDC even if no PLLs exist in the design
derive_pll_clocks

derive_clock_uncertainty




################### ADS5263 -> FPGA Interface ####################
# Create virtual clock for ADS5263.  Phase-shift it 90 degrees to say it is center-aligned
create_clock -period 3.125 -name adc1_lclk_ext -waveform {0.78125 2.34375}
create_clock -period 3.125 -name adc2_lclk_ext -waveform {0.78125 2.34375}

# The device does not spec what it is actually doing, but what it can provide.  We will use our relationship to figure out what the ADS5263 is actually doing
# We will need to know the setup relationship and hold relationship to perform this calculation, which are just +90 degrees and -90 degrees in Explicit Clock Shift Mode
set relationship 0.5 ; # What should be the exact value??

# TI ADS5263 datasheet says it can provide a Tsu and Th to the FPGA:
set adc_tsu 0.47
set adc_th 0.47 

# Need to calculate what ADS5263 is actually doing
set adc_skew_max [expr $relationship - $adc_tsu] ; # 3.0 - 2.0 = 1.0
set adc_skew_min [expr -$relationship - (-$adc_th)] ; # -3.0 - (-2.0) = -1.0

# The board skew need to be accounted for.  Positive means data is longer than clk, negative means it is shorter than clk.  I made up some values:
set board_data2clk_skew_max 0.05         ; # please refer to PCB simulation for a reasonable value
set board_data2clk_skew_min -0.05        ; # please refer to PCB simulation for a reasonable value

# Now just add the ADC skew and board skew to calculate external delays:
set ssync_in_max [expr $adc_skew_max + $board_data2clk_skew_max] ;# 1.0 + 0.05 = 1.05
set ssync_in_min [expr $adc_skew_min + $board_data2clk_skew_min] ;# -1.0 + (-0.05) = -1.05

set_input_delay -clock adc1_lclk_ext -max $ssync_in_max [get_ports {adc1_data_H[*]}]
set_input_delay -clock adc1_lclk_ext -min $ssync_in_min [get_ports {adc1_data_H[*]}]
set_input_delay -clock adc1_lclk_ext -max $ssync_in_max [get_ports {adc1_data_H[*]}] -clock_fall -add_delay
set_input_delay -clock adc1_lclk_ext -min $ssync_in_min [get_ports {adc1_data_H[*]}] -clock_fall -add_delay

set_input_delay -clock adc2_lclk_ext -max $ssync_in_max [get_ports {adc2_data_H[*]}]
set_input_delay -clock adc2_lclk_ext -min $ssync_in_min [get_ports {adc2_data_H[*]}]
set_input_delay -clock adc2_lclk_ext -max $ssync_in_max [get_ports {adc2_data_H[*]}] -clock_fall -add_delay
set_input_delay -clock adc2_lclk_ext -min $ssync_in_min [get_ports {adc2_data_H[*]}] -clock_fall -add_delay
##################################################################
