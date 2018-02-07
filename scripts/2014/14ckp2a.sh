#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='14ckp2a'
mooringYear='2014'
lat='71 13.755 N'
lon='164 14.739 W'
site_depth=45
deployment_date='2014-09-26 06:00:00'
recovery_date='2015-09-13 06:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1793
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/14ckp2a_eco_flsb1793_0038m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/14ckp2a_ecf_0038m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0038 -kw 0 median 0.0073 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0038 -kw 260 median 0.0073 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
