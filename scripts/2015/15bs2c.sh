#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='15bs2c'
mooringYear='2015'
lat='56 52.237 N'
lon='164 03.978 W'
site_depth=41
deployment_date='2015-09-27 23:00:00'
recovery_date='2016-05-04 21:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=3767
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs2c_sbe39_3767_0027m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs2c_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Offset 43200
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

