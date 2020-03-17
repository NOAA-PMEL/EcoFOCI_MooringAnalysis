#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckip3a'
mooringYear='2018'
lat='71 49.718 N'
lon='166 03.161 W'
site_depth=46
deployment_date='2018-08-12T20:00:00'
recovery_date='2019-08-13T15:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2025
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckip3a_sbe37_2025_42.25m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip3a_s37_0042m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0042 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"
serial_no=rcmsg_1982
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/SG1814-lebon/18CKIP_3A_RCM_Combined.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip3a_sg_0041m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0041 -dec 71.829 166.053 -kw false false 'combined_manual_units' -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


