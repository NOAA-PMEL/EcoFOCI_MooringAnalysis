#!/bin/bash

data_dir='/Volumes/Archive 7/ecoraid/'
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bs4b'
mooringYear='2018'
lat='57 52.05 N'
lon='168 53.59 W'
site_depth=71.59
deployment_date='2018-10-07T21:00:00'
recovery_date='2020-09-03T19:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "MTRduino Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: "
serial_no=0521
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18bsm2a_sbe16_655_44m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_sc_0031m
python ${prog_dir}EcoFOCIraw2nc.py '${input}' '${output}.unqcd.nc' sc 0031 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py "${output}" Trim --trim_bounds ${deployment_date} ${recovery_date}
"

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"
: "
serial_no=1678
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs4b_sbe37_1678_18m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s37_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s37 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2331
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs4b_sbe37_2331_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=3770
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs4b_sbe37_3770_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=1637
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs4b_sbe39_1637_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s39 0015 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5287
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs4b_sbe39_5287_19m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s39_0019m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s39 0019 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1433
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs4b_sbe39_1433_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1425
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs4b_sbe39_1425_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs4b_sbe39_807_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_s39_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}" s39 0047 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}" Trim  --trim_bounds ${deployment_date} ${recovery_date}
"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_0603
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bs4b_flsb_603_13m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs4b_ecf_0013m

python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}.unqcd.nc" ecoflsb 0013 -kw 0 median 0.0081 88 0 0 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py "${input}" "${output}.interpolated.nc" ecoflsb 0013 -kw 3752 median 0.0081 88 0 0 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  "${output}.interpolated.nc" Trim  --trim_bounds ${deployment_date} ${recovery_date}
