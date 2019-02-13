#!/bin/bash

## on microburst
#data_dir="/Users/bell/ecoraid/"
#prog_dir="/Users/bell/Programs/Python/MooringDataProcessing/adcp/"

## on pavlof/ecorad
data_dir="/home/ecoraid/data/"
prog_dir="/home/pavlof/bell/Python/MooringDataProcessing/adcp/"


echo "ADCP Processing"
mooringYear='2013'

echo $prog_dir
echo $mooringYear

mooringID='13bsp4a'
adcpID='1792'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='616'
bin_length='400'
depth='0071'
dec_cor='7.9'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 13BSP-4A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13bsp5a'
adcpID='3077'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='616'
bin_length='400'
depth='0071'
dec_cor='7.9'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 13BSP-5A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13bsp8a'
adcpID='2416'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='614'
bin_length='400'
depth='0071'
dec_cor='6.5'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 13BSP-8A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13ckp1a'
adcpID='1793'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='612'
bin_length='400'
depth='0046'
dec_cor='13.5'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 13CKP-1A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13ckp2a'
adcpID='5503'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='306'
bin_length='200'
depth='0042'
dec_cor='12.9'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawConverted/${adcpID}/ 13CKP-2A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13ckp4a'
adcpID='1705'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='614'
bin_length='400'
depth='0053'
dec_cor='14.9'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawConverted/${adcpID}/ 13CKP-4A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13ckp5a'
adcpID='5557'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='618'
bin_length='400'
depth='0049'
dec_cor='16.64'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawConverted/${adcpID}/ 13CKP-5A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='13ckp6a'
adcpID='5504'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='305'
bin_length='200'
depth='0044'
dec_cor='14.3'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawConverted/${adcpID}/ 13CKP-6A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor} -id


mooringID='13ckp7a'
adcpID='14068'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='305'
bin_length='200'
depth='0045'
dec_cor='14.6'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawConverted/${adcpID}/ 13CKP-7A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}

