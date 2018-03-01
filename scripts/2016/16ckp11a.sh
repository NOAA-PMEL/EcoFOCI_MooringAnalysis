#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp11a'
mooringYear='2016'
lat='70 00.787 N'
lon='166 51.324 W'
site_depth=47
deployment_date='2016-09-19 14:00:00'
recovery_date='2017-08-08 00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4607
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp11a_sbe16_4607_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp11a_sc_0042m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0042 -kw 0 time_elapsed_s false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0042 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1793
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp11a_flsb_1793_39m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp11a_ecf_0042m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0042 -kw 0 median 0.0070 50 false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0042 -kw 243 median 0.0070 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
