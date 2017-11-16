#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bsitae'
mooringYear='2017'
lat='56 51.840 N'
lon='164 03.140 W'
site_depth=71
deployment_date='2017-04-27 18:00:00'
recovery_date='2017-09-23 15:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

: '
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_158
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bsitae_flsb_158_0m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_ecf_0000m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0000 -kw 0 median 0.0079 46 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0000 -kw 194 median 0.0079 46 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6592
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bsitae_sbe16_6592_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsitae_sc_0000m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0000 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0000 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4737
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/17bsitae_sbe56_4737_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsitae_s56_0000m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0000 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'