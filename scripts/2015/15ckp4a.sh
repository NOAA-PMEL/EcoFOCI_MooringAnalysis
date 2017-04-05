#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='15ckp4a'
mooringYear='2015'
lat='71 02.785 N'
lon='160 30.892 W'
site_depth=49
deployment_date='2015-09-13 02:00:00'
recovery_date='2016-09-07 19:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=3114
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/15ckp4a_sbe16_4287_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp4a_sc_0045m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0045 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0045 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3072
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/15ckp4a_flsb3072_39m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp4a_ecf_0045m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0045 -kw 0 median 0.0072 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0045 -kw 298 median 0.0072 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
