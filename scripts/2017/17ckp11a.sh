#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckp11a'
mooringYear='2017'
lat='70 01.007 N'
lon='166 50.999 W'
site_depth=47
deployment_date='2017-08-07T23:44:00'
recovery_date='2018-08-11T21:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: "serial_no=0658
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17ckp11a_sbe16_658_42m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp11a_sc_0042m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0042 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0042 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3072
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17ckp11a_flsb_3072_42m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/${mooringID}_ecf_0042m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0042 -kw 0 median 0.0071 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0042 -kw 318 median 0.0071 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

