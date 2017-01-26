#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

mooringID='15ckt2a'
mooringYear='2015'
lat='71 13.808 N'
lon='164 13.237 W'
site_depth=41
deployment_date='2015-09-19 04:00:00'
recovery_date='2016-09-14 21:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1866
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15ckt2a_sbe37_1866_37m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckt2a_s37_0037m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0037 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

