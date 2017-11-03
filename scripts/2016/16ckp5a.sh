#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp5a'
mooringYear='2016'
lat='71 12.152 N'
lon='158 00.662 W'
site_depth=48
deployment_date='2016-09-07 18:00:00'
recovery_date='2017-08-12 20:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3764
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckt2a_sbe37_3764_37m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp5a_s37_0044.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0044 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6627
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp5a_sbe16_6627_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp5a_sc_0043m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0043 -kw 0 time_elapsed_s false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0043 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_603
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp5a_flsb_603_39m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp5a_ecf_0043m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0043 -kw 0 median 0.0076 88 false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0043 -kw 298 median 0.0076 88 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
'