#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bs4b'
mooringYear='2017'
lat='57 52.3 N'
lon='168 53.540 W'
site_depth=71.59
deployment_date='2017-09-25T22:00:00'
recovery_date='2018-10-07T19:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2332
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs4b_sbe37_2332_.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s37_0017m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0017 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1679
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/sbe37_1679.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s37_0030m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0030 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=3979
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs4b_sbe37_3979_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0511
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_511_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0025m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0025 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0516
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_516_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0033m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0033 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0517
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_517_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5473
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_5473_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0058m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0058 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0566
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_566_20m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0804
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_804_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0048m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0048 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0809
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_809_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0043m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0043 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0810
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs5a_sbe39_810_67m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_s39_0065m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0065 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3074
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bs5a_flsb_3074_18m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs5a_ecf_0016m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0016 -kw 0 median 0.0071 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0016 -kw 504 median 0.0071 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
