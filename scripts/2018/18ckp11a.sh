#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp11a'
mooringYear='2018'
lat='70 01.022 N'
lon='166 51.202 W'
site_depth=49
deployment_date='2018-08-11T23:00:00'
recovery_date='2019-08-12T18:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4607
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp11a_sbe16_4285_39.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp11a_sc_0043m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0043 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0043 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=flsb_659
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp11a_flsb_659_39.75m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp11a_eco_0043m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0043 -kw 0 median 0.0083 86 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0043 -kw 0  median 0.0083 86 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
