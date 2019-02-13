#!/bin/bash

# on pavlof/ecorad
data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/MooringDataProcessing/adcp/"


echo "ADCP Processing"
mooringYear='2014'

echo $prog_dir
echo $mooringYear

mooringID='14ckp9a'
adcpID='1984'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='lrcp'
start_bin='2445'
bin_length='1600'
depth='0345'
dec_cor='17.12'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-9A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

