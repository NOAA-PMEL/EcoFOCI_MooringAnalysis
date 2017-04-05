#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='15ckp9a'
mooringYear='2015'
lat='72 28.011 N'
lon='156 32.977 W'
site_depth=978
deployment_date='2015-09-15 00:00:00'
recovery_date='2016-09-08 19:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2332
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15ckp9a_sbe37_2332_406m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp9a_s37_0378m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0378 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCM9 Processing"
echo "-------------------------------------------------------------"

