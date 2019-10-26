#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckv2a'
mooringYear='2018'
lat='71 13.010 N'
lon='164 14.972 W'
site_depth=46
deployment_date='2018-08-13T21:05:00'
recovery_date='2019-08-14T03:04:31'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"



echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3763
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckv2a_sbe37_3763_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_s37_0014m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0014 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckv2a_flsb_158_14m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_ecf_0016m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0016 -kw 0 median 0.0080 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0016 -kw 407 median 0.0080 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=rcm9_875
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18CKV2A_rcm9_875.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_an9_0012m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0012 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


### CF Convention

echo "------CF Convention------------------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"



echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3763
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckv2a_sbe37_3763_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_s37_0014m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0014 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckv2a_flsb_158_14m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_ecf_0016m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc eco 0016 -kw 0 median 0.0080 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc eco 0016 -kw 407 median 0.0080 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=rcm9_875
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18CKV2A_rcm9_875.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_an9_0012m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0012 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

