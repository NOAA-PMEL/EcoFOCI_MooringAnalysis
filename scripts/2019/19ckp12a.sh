#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19ckp12a'
mooringYear='2019'
lat='67 54.712 N'
lon='168 11.628 W'
site_depth=60
deployment_date='2019-08-11T03:00:00'
recovery_date='2020-09-11T01:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2979
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19ckp12a_sbe37_1852_54m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp12a_s37_0053m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0053 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
#recalculate salinity due to difference in designed vs actual depth?

echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=726
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/19ckp12a_rcm726.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp12a_an9_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0055 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}
