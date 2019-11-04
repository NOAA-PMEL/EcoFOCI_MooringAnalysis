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


##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2327
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckip1a_sbe37_2327_39.75m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip1a_s37_0040m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "RCMSG Processing"
echo "-------------------------------------------------------------"


