#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckip1a'
mooringYear='2018'
lat='70 50.341 N'
lon='163 07.736 W'
site_depth=46
deployment_date='2018-08-14T20:00:00'
recovery_date='2019-08-18T14:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2327
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckip1a_sbe37_2327_39.75m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip1a_s37_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"
serial_no=rcmsg_1806
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/SG1806/18CKIP_1A_RCM_Combined.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip1a_sg_0041m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0041 -dec 70.839 163.129 -kw false false 'combined_manual_units' -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


