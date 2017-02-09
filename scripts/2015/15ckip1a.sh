#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='15ckip1a'
mooringYear='2015'
lat='70 50.139 N'
lon='163 07.431 W'
site_depth=42
deployment_date='2015-09-18 19:00:00'
recovery_date='2016-09-15 22:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1865
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15ckip1a_sbe37_1865_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckip1a_s37_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"

serial_no=169SG
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm_sg/15ckip1a_rcm_169SG.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckip1a_sg_0039.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0039 -dec 70.836 163.124 -kw false True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth 
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}
