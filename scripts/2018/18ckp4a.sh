#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp4a'
mooringYear='2018'
lat='71 02.622 W'
lon='160 30.213 N'
site_depth=52
deployment_date='2018-08-15T07:00:00'
recovery_date='2019-08-19T22:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6627
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp4a_sbe16_6627_44.5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp4a_sc_0045m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0045 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0045 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
# unknown cal factor
serial_no=flsb_1984
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp4a_flsb_1984_44.5m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp4a_eco_0045m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0045 -kw 0 median 0.077 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0045 -kw 185  median 0.077 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"


##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6627
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp4a_sbe16_6627_44.5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp4a_sc_0045m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0045 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0045 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
 echo "-------------------------------------------------------------"
# unknown cal factor
serial_no=flsb_1984 
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp4a_flsb_1984_44.5m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp4a_eco_0045m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc eco 0045 -kw 0 median 0.077 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc eco 0045 -kw 185  median 0.077 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"

