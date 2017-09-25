#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp9a'
mooringYear='2016'
lat='72 27.822 N'
lon='156 32.880 W'
site_depth=1032
deployment_date='2016-09-08 21:15:00'
recovery_date='2017-08-03 20:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3768
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckp9a_sbe37_3768_501m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_s37_0460m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 460 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4078
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckp9a_sbe37_4078_110m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_s37_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
