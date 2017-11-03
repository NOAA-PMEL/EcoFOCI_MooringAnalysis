#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckip1a'
mooringYear='2016'
lat='70 50.264 N'
lon='163 07.525 W'
site_depth=43
deployment_date='2016-09-16 00:00:00'
recovery_date='2017-08-09 03:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3768
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckip1a_sbe37_2023_39m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckip1a_s37_0040.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 40 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"

serial_no=1734
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm_sg/sg1734.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckip1a_sg_0039.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0039 -dec 70.838 163.125 -kw false false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth 
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
