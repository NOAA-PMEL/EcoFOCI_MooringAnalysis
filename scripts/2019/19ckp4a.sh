#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19ckp2a'
mooringYear='2019'
lat='71 2.591 N'
lon='160 29.706 W'
site_depth='52.5'
deployment_date='2019-08-19T11:00:00'
recovery_date='2020-09-14T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: "
#with PAR
serial_no=4425
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/19ckp4a_sbe16_4425_45.5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp4a_sc_0044m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0044 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0044 -kw -38 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

"
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: "
serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/19ckp4a_flsb_2694_45.5m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp4a_ecf_0044m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0044 -kw 0 median 0.0075 48 0 0 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0044 -kw 1115 median 0.0075 48 0 0 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=905
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/19ckp4a_rcm905.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp4a_an9_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0047 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}
