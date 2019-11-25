#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckip3a'
mooringYear='2017'
lat='71 49.692 N '
lon='166 04.218 W'
site_depth=44
deployment_date='2017-08-20T21:48:00'
recovery_date='2018-08-12T17:27:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17CKIP3Asbe37.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip3a_s37_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/17ckip3a_rcm868.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip3a_an9_0038m.unqcd.nc
serial_no=rcm9-868
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0038 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}

##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17CKIP3Asbe37.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip3a_s37_0039m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/17ckip3a_rcm868.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip3a_an9_0038m.unqcd.cf.nc
serial_no=rcm9-868
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0038 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

