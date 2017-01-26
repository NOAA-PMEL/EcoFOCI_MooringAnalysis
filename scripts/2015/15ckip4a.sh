#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

mooringID='15ckip4a'
mooringYear='2015'
lat='71 02.871 N'
lon='160 30.693 W'
site_depth=49
deployment_date='2015-09-13 00:00:00'
recovery_date='2016-09-07 06:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2025
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15ckip4a_sbe37_2025_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckip4a_s37_0046m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0046 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCM9 Processing"
echo "-------------------------------------------------------------"

