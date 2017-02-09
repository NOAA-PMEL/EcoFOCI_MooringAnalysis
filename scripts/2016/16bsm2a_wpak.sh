#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16bsm2a'
mooringYear='2016'
lat='56 52.1729 N'
lon='164 02.8716 W'
site_depth=71
deployment_date='2016-05-05 06:00:00'
recovery_date='2016-09-29 04:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "WPAK Processing"
echo "-------------------------------------------------------------"

serial_no=1361
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/weatherpak/16bsm2a_weatherpak.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_wpak.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} wpak 0003 -dec 56.870 164.048 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

