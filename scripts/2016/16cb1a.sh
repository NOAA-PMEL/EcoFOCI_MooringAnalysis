#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16cb1a'
mooringYear='2016'
lat='57 43.344 N'
lon='152 17.384 W'
site_depth=190
deployment_date='2016-02-09 20:16:00'
recovery_date='2017-04-23 04:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1860
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16cb1a_sbe37_1860.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16cb1a_s37_0188m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0188 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCM9/11 Processing"
echo "-------------------------------------------------------------"

#
# Still use original rcm processing in mooringanalysis folder
#