#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bs8a'
mooringYear='2018'
lat='62 11.958 N'
lon='174 41.134 W'
site_depth=74
deployment_date='2018-10-12T01:00:00'
recovery_date='2019-09-23T18:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=6629
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs8a_sbe16_6629_20m.clean.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_sc_0020m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0020 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0020 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

#from UAF - with oxy
serial_no=6957
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01606675_2018_10_29.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_sc_0068m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0068 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0068 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF

'

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2024
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs8a_s37_2024_0055m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s37_0055m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=1858
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs8a_s37_1858_0031m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s37_0031m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_0813_0035m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0035m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=0817
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_0817_0027m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0027m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=0986
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_0986_0050m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0050m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=1421
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_1421_0045m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0045m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=1640
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_1640_0023m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0023m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0023 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=1802
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_1802_0067m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0067m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0067 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_3769_0060m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0060m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bs8a_ecoflsb_1796_0020m.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_ecf_0020m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc eco 0020 -kw 0 median 0.0062 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc eco 0020 -kw 5 median 0.0062 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.cf.nc -sd ${deployment_date} -ed ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
'
