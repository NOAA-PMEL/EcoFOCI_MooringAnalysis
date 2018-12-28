#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckip1a'
mooringYear='2017'
lat='71 49.692 N'
lon='166 04.218 W'
site_depth=44
deployment_date='2017-08-09T04:00:00'
recovery_date='2018-08-14T16:58:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2318
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17CKIP1Asbe37.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip1a_s37_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/17ckip1a_rcm1199.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckip1a_an9_0038m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0038 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}
