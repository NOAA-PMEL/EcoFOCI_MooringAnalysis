#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='15ckp1a'
mooringYear='2015'
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
echo "ADCP Processing"
echo "-------------------------------------------------------------"

serial_no=3060
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/adcp/15ckp1a_bottom_track.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp1a_adcp_bottomtrack
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc adcp_ice 0000 -dec 70.836 163.105 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.timecorr.nc adcp_ice 0000 -dec 70.836 163.105 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.unqcd.timecorr.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6629
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/15ckp1a_sbe16_6629_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp1a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3048
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/15ckp1a_flsb_3048_39m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15ckp1a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0039 -kw 0 median 0.0073 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0039 -kw 571 median 0.0073 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'