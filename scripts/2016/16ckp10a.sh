#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp10a'
mooringYear='2016'
lat='70 12.655 N'
lon='167 47.240 W'
site_depth=47
deployment_date='2016-09-19 18:00:00'
recovery_date='2017-08-07 8:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=539
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp10a_sbe16_539_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp10a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_elapsed_s false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp10_flsb_194_39m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp10a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0039 -kw 0 median 0.0073 67 false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0039 -kw -2333 median 0.0073 67 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
