#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckp2a'
mooringYear='2017'
lat='71 13.910 N'
lon='164 12.984 W'
site_depth=43
deployment_date='2017-08-08T18:14:00'
recovery_date='2018-08-13T17:23:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

: "
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=4426
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17ckp2a_sbe16_4426_39m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp2a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=bbfl2w_1418
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17ckp2a_bbfl2w_1418_40m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp2a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc ecobbfl2w 0039 -kw 0 median 0.0181 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc ecobbfl2w 0039 -kw 0 median 0.0181 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

