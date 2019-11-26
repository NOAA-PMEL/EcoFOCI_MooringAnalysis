#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18alauph1'
mooringYear='2018'
lat='67 54.652 N'
lon='168 11.8 W'
site_depth=61
deployment_date='2018-10-10T23:00:00'
recovery_date='2019-08-11T02:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=4078
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/al181uph1_sbe37_4078.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18alauph1_s37_0057m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0057 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=4078
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/al181uph1_sbe37_4078.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18alauph1_s37_0057m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0057 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

