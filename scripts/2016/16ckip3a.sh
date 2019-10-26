#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckip3a'
mooringYear='2016'
lat='71 49.682 N'
lon='166 04.220 W'
site_depth=45
deployment_date='2016-09-14T01:00:00'
recovery_date='2017-08-20T21:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2377
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckip3a_sbe37_2337_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckip3a_s37_0041m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0041 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

#rcm has significant challenges and was not processed
: '
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18ck14a_rcm660.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ck14a_an9_0037m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0038 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 
'
##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"
serial_no=2377
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckip3a_sbe37_2337_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckip3a_s37_0041m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0041 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

#rcm has significant challenges and was not processed
: '
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18ck14a_rcm660.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ck14a_an9_0037m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0038 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
'