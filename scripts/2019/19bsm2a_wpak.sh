#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19bsm2a'
mooringYear='2019'
lat='56 52.270 N'
lon='164 04.191 W'
site_depth=71
deployment_date='2019-04-25T05:00:00'
recovery_date='2019-09-20T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "WPAK Processing"
echo "-------------------------------------------------------------"

serial_no=1361
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/weatherpak/19bsm2a_weatherpak_1361.clean.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_wpak.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} wpak 0003 -dec 56.8712 164.0700 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

