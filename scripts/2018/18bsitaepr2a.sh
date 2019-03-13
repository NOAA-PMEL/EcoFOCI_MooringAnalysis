#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bsitaepr2a'
mooringYear='2018'
lat='56 52.090 N'
lon='164 04.00 W'
site_depth=72
deployment_date='2018-05-01T20:31:00'
recovery_date='2018-10-02T00:58:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=7020
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18bsitaepr2a_sbe16_7020_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsitaepr2a_sc_0000m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0000 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0000 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4737
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/17bsitae_sbe56_4737_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsitae_s56_0000m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0000 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'