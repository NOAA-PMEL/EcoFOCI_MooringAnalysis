#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckip2a'
mooringYear='2016'
lat='71 13.855 N'
lon='164 13.381 W'
site_depth=41
deployment_date='2016-09-14 22:00:00'
recovery_date='2017-08-08 17:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2333
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckip2a_sbe37_2333_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckip2a_s37_0040.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
