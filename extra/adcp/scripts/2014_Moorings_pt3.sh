#!/bin/bash

# on pavlof/ecorad
data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/MooringDataProcessing/adcp/"


echo "ADCP Processing"
mooringYear='2014'

echo $prog_dir
echo $mooringYear

mooringID='14ckp1a'
adcpID='1774'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='620'
bin_length='400'
depth='0036'
dec_cor='13.51'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-1A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='14ckp2a'
adcpID='1750'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='620'
bin_length='400'
depth='0036'
dec_cor='12.96'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-2A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

mooringID='14ckp4a'
adcpID='22019'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='620'
bin_length='400'
depth='0036'
dec_cor='14.89'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-4A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

mooringID='14ckp5a'
adcpID='17729'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='310'
bin_length='200'
depth='0036'
dec_cor='16.19'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-5A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

mooringID='14ckp6a'
adcpID='3079'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='622'
bin_length='400'
depth='0036'
dec_cor='14.29'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-6A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

mooringID='14ckp8a'
adcpID='1398'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='620'
bin_length='400'
depth='0036'
dec_cor='14.77'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14CKP-8A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

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

