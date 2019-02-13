#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/MooringDataProcessing/adcp/"


echo "ADCP Processing"
mooringYear='2014'

echo $prog_dir
echo $mooringYear

mooringID='14bsp2b'
adcpID='3072'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='614'
bin_length='400'
depth='0062'
dec_cor='11.43'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14BSP-2B ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='14bsp6a'
adcpID='5501'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='614'
bin_length='400'
depth='0150'
dec_cor='9.08'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14BSP-6A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}
