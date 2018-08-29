#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckip2a'
mooringYear='2017'
lat='71 13.846 N'
lon='164 13.360 W'
site_depth=43
deployment_date='2017-08-20 21:48:00'
recovery_date='2018-08-12 17:27:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17CKIP2Asbe37.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip2a_s37_0037m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0037 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
