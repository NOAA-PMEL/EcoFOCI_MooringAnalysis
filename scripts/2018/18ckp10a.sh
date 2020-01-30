#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp10a'
mooringYear='2018'
lat='70 13.158 N'
lon='167 47.506 W'
site_depth=49
deployment_date='2018-08-12T05:00:00'
recovery_date='2019-08-12T15:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4607
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp10a_sbe16_4607_39.75m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp10a_sc_0044m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0044 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0044 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=flsb_1793
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp10a_flsb_1793_39.75m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp10a_eco_0044m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0044 -kw 0 median 0.0074 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0044 -kw 220  median 0.0074 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
