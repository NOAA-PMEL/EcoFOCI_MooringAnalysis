#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bsm2a'
mooringYear='2017'
lat='56 52.060 N'
lon='164 03.340 W'
site_depth=71
deployment_date='2017-04-27 22:00:00'
recovery_date='2017-09-23 17:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "WPAK Processing"
echo "-------------------------------------------------------------"

serial_no=1361
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/weatherpak/17bsm2a_weatherpak_1361.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_wpak.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} wpak 0003 -dec 56.868 164.056 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

