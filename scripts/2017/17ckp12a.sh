#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckp12a'
mooringYear='2017'
lat='67 54.658 N'
lon='168 11.842 W'
site_depth=59
deployment_date='2017-08-23T01:00:00'
recovery_date='2018-08-11T02:58:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

###
#
# This instrument was actually mounted on Berchoks mooring in the same location.
#
serial_no=1855
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17CK12_1855sbe37.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp12a_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0037 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}
