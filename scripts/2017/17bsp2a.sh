#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bsp2a'
mooringYear='2017'
lat='56 52.1 N'
lon='164 03.2 W'
site_depth=71
deployment_date='2017-04-28T00:00:00'
recovery_date='2017-10-01T20:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

#uaf
serial_no=7333
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01606673_2017_10_20.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_sc_0067m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0067 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0067 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}netcdf_utils/NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
python ${prog_dir}netcdf_utils/NetCDF_Time_Tools.py ${output}.unqcd.nc CF_Convert
python ${prog_dir}netcdf_utils/NetCDF_Time_Tools.py ${output}.interpolated.trimmed_missing.nc CF_Convert
