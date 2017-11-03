#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp1a'
mooringYear='2016'
lat='70 50.130 N'
lon='163 06.321 W'
site_depth=42
deployment_date='2015-09-18 19:00:00'
recovery_date='2016-09-15 22:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

:'
serial_no=7021
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp1a_sbe16_7021_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp1a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flntusb_2164
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp1a_flntusb_2164_37m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp1a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0039 -kw 0 median 0.0172 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0039 -kw 298 median 0.0172 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
