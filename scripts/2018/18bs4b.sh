#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Documents/GitHub/EcoFOCI_MooringAnalysis/"

mooringID='18bs4b'
mooringYear='2018'
lat='57 52.05 N'
lon='168 53.59 W'
site_depth=71.59
deployment_date='2018-10-07T21:00:00'
recovery_date='2020-10-01T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "MTRduino Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3770
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs4b_sbe37_3770_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs4b_sbe39_807_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
