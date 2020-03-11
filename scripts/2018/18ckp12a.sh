#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp12a'
mooringYear='2018'
lat='67 54.582 N'
lon='168 11.392 W'
site_depth=62
deployment_date='2018-08-11T02:00:00'
recovery_date='2019-08-11T02:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=rcm9_859
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18ckp12a_rcm859.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp12a_an9_054m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 054 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

