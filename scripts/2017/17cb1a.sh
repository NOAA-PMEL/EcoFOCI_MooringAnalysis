#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17cb1a'
mooringYear='2017'
lat='57 43.310 N'
lon='152 17.430 W'
site_depth=44
deployment_date='2017-04-23T03:26:00'
recovery_date='2019-04-20T0:02:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3765
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17cb1a_s37_3765_0188m.redownload.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17cb1a_s37_0188m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0188 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth 
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/17cb1a_rcm12443.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17cb1a_an9_0183m.unqcd.nc
serial_no=rcm9-659
cal_date="RCM unit last cal'd 1/18/05"
processing_notes="Optode cal'd - 2016-12-29"
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0183 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
