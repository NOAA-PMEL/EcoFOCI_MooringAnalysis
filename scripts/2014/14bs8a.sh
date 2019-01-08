#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='14bs8a'
mooringYear='2014'
lat='62 11.693 N'
lon='174 41.009 W'
site_depth=70
deployment_date='2014-10-15T19:50:00'
recovery_date='2015-09-24T17:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=4139
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/14bs8a_sbe16_4139_20m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/14bs8a_sc_0020m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0020 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0020 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'
#from uaf
serial_no=4139
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01606673_2015_09_25.edit.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/14bs8a_sc_0068m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0068 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0068 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0813
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/14bs8a_sbe39_0060m_0813.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/14bs8a_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
