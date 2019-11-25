#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckip3a'
mooringYear='2018'
lat='70 50.341 N'
lon='163 07.736 W'
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
serial_no=rcmsg_1814
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm_sg/18CKIP3A_rcmsg.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip3a_sg_0041m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0041 -dec 70.839 163.129 -kw false false 'combined_manual' -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2025
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckip3a_sbe37_2025_42.25m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip3a_s37_0042m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0042 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"
serial_no=rcmsg_1814
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm_sg/18CKIP3A_rcmsg.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip3a_sg_0041m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0041 -dec 70.839 163.129 -kw false false 'combined_manual' -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

