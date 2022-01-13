#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='13bsp4a'
mooringYear='2013'
lat='57 52.018 N'
lon='168 52.359 W'
site_depth=45
deployment_date='2013-05-06T23:00:00'
recovery_date='2013-09-12T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no='869'
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/F-13-BSP-4A-869.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/13bsp4a_an9_0063m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0063 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}netcdf_utils/NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 
