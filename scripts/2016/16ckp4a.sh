#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp4a'
mooringYear='2016'
lat='71 12.152 N'
lon='158 00.662 W'
site_depth=48
deployment_date='2016-09-07 18:00:00'
recovery_date='2017-08-12 20:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4285
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp4a_sbe16_4285_37m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp4a_sc_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0040 -kw 0 time_elapsed_s false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0040 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"


serial_no=flsb_3718
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp4a_flsb_3718_37m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp4a_ecf_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 40 -kw 0 median 0.0076 44 false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 40 -kw 600  median 0.0076 44 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
