#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bs5a'
mooringYear='2018'
lat='59 54.238 N'
lon='171 42.092 W'
site_depth=74
deployment_date='2018-10-09T02:00:00'
recovery_date='2019-09-22T21:00:00'

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
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs5a_sbe16_6629_20m.clean.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_sc_0020m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0020 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0020 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

#from UAF - with oxy
serial_no=6957
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01606675_2018_10_29.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_sc_0068m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0068 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0068 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

'

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1805
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs5a_s37_1805_0055m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#clock was setup wrong? verify in setup files
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -5356800
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 
: '

serial_no=2022
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs5a_s37_2022_0032m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s37_0032m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0032 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=2341
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs5a_s37_2341_0017m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s37_0017m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0017 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 
'
echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=0808
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_0808_0023m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0023m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0023 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1426
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_1426_0027m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1428
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_1428_0040m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1636
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_1636_0035m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1778
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_1778_0045m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=3767
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_3767_0060m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=3774
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_3774_0020m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0020m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0020 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=5285
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_5285_0067m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0067m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0067 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=5474
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs5a_s39_5474_0050m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 
'
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bs5a_ecoflsb_194_0018m.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs5a_ecf_0018m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0018 -kw 0 median 0.0077 65 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0018 -kw 1049 median 0.0077 65 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} 
'
