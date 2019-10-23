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
echo "RBR Processing"
echo "Special Instruments for PopTop"
echo "-------------------------------------------------------------"
serial_no=11803
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/rbr/18bs8a_rbr_tr1050_012124.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_rbr_0016m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rbr 0015 -kw 16 1 -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


serial_no=12124
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/rbr/18bs8a_rbr_tdr2050_11803.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_rbr_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rbr 0015 -kw 20 2 -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=6629
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs8a_sbe16_6629_20m.clean.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_sc_0021m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0021 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0021 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

#from UAF - with oxy
serial_no=6957
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01606675_2018_10_29.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_sc_0069m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0069 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0069 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
'
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2024
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs8a_s37_2024_0055m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s37_0056m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0056 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1858
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs8a_s37_1858_0031m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s37_0032m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0032 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_0813_0035m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0036m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0036 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=0817
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_0817_0027m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=0986
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_0986_0050m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0051m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0051 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1421
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_1421_0045m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0046m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0046 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1640
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_1640_0023m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0024m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0024 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1802
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_1802_0067m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0068m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0068 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs8a_s39_3769_0060m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_s39_0061m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0061 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bs8a_ecoflsb_1796_0020m.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs8a_ecf_0021m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0021 -kw 0 median 0.0062 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0021 -kw 5 median 0.0062 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} 

