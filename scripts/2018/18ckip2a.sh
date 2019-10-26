#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckip2a'
mooringYear='2018'
lat='71 12.828 N'
lon='164 15.158 W'
site_depth=46
deployment_date='2018-08-13T20:00:00'
recovery_date='2019-08-14T03:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckip2a_sbe37_3769_39.75m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip2a_s37_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=rcm9_858
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18ckip2a_rcm858.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip2a_an9_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0039 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"
serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckip2a_sbe37_3769_39.75m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip2a_s37_0040m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

#rcm has significant challenges and was not processed

serial_no=rcm9_858
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18ckip2a_rcm858.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckip2a_an9_0039m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0039 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
