#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='14bs4b'
mooringYear='2014'
lat='57 53.178 N'
lon='168 52.085 W'
site_depth=70
deployment_date='2014-10-17 20:19:00'
recovery_date='2015-09-23 21:35:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4607
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/14bs4b_sbe16_4607_12_5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/14bs4b_sc_0013m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0013 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0013 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
