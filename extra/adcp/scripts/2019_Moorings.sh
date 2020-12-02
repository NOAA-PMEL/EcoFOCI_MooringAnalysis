#!/bin/bash

# on pavlof/ecorad
data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/extra/adcp/"


echo "ADCP Processing"
mooringYear='2019'

echo $prog_dir
echo $mooringYear

mooringID='19bsp8a'
adcpID='5501'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='306'
bin_length='300'
depth='0036'
dec_cor='12.63'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/adcp/concatinated/ 15CKP-2A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

