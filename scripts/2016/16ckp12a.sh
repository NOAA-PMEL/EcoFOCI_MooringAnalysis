#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp12a'
mooringYear='2016'
lat='71 13.929 N'
lon='164 13.022 W'
site_depth=58
deployment_date='2016-09-21T07:00:00'
recovery_date='2017-08-06T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "RCM-9 Processing"
echo "-------------------------------------------------------------"

#use old routine to process initial data
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/
python ${prog_dir}NetCDF_Time_Tools.py  ${output}16ckp12a_an9_0052m.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
#big clock error/drift (30min) - take care of this before interpolating