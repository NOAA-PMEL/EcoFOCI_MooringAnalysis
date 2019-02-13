#!/bin/bash

## on microburst
#data_dir="/Users/bell/Data_Local/FOCI/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/adcp/"

## on pavlof/ecorad
data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
#prog_dir="/home/pavlof/strausz/python/MooringDataProcessing/adcp/"


echo "ADCP Processing"
mooringYear='2016'

echo $prog_dir
echo $mooringYear


mooringID='16bsp2b'
adcpID='1950'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='613'
bin_length='400'
depth='0062'
dec_cor='10.96'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/adcp/ 16BSP-2B ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


