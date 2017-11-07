#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp3a'
mooringYear='2016'
lat='71 49.866 N'
lon='166 04.285 W'
site_depth=41
deployment_date='2016-09-14 01:00:00'
recovery_date='2017-08-20 21:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6628
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp3a_sbe16_6628_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp3a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_elapsed_s false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"


serial_no=flsb_695
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp3a_flsb_659_38m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp3a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0039 -kw 0 median 0.0074 88 false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0039 -kw -2269  median 0.0074 88 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
