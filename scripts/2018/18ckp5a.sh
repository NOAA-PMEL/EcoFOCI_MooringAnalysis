#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp5a'
mooringYear='2018'
lat='71 12.467 N'
lon='158 01.049 W'
site_depth=50
deployment_date='2018-08-16T20:00:00'
recovery_date='2019-08-20T04:30:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6628
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp5a_sbe16_6628_39.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp5a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2329
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckp5a_sbe37_2329_38.5m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp5a_s37_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=flsb_3450
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp5a_flsb_3450_39.5m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp5a_eco_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0040 -kw 0 median 0.0074 48 0 0.0 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0040 -kw 349  median 0.0074 48 0 0.0 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
