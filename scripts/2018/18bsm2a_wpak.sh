#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bsm2a'
mooringYear='2018'
lat='56 51.820 N'
lon='164 03.930 W'
site_depth=71
deployment_date='2018-05-02T00:00:00'
recovery_date='2018-10-03T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "WPAK Processing"
echo "-------------------------------------------------------------"

serial_no=1361
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/weatherpak/18bsm2a_weatherpak_1361.clean.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_wpak.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} wpak 0003 -dec 56.8637 164.0655 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

