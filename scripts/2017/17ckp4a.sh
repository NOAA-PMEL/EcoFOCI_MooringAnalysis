#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckp4a'
mooringYear='2017'
lat='71 02.258 N'
lon='160 30.710 W'
site_depth=48
deployment_date='2017-08-12T01:29:00'
recovery_date='2018-08-15T03:54:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4139
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17ckp4a_sbe16_4139_42m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp4a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/17ckp4a_rcm905.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp4a_an9_0038m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0038 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}
