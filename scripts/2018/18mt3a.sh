#!/bin/bash

# Peter ran a thermal test on 12 MTR's to evaluate the impact of the current flow
#  on the temperature.

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18mt3a'
mooringYear='2018'
lat='60 13.91 N'
lon='172 31.24 W'
site_depth=50
deployment_date='2018-05-04T22:00:00'
recovery_date='2018-10-06T00:00:00'


echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE-26 Processing"
echo "-------------------------------------------------------------"

serial_no=347
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw_converted/sbe26/18mt3a_narr_apress.orig.tid
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mt3a_s26_0048m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} sbe26 0048 -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

