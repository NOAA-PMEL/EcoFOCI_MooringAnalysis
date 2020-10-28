#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19ckp2a'
mooringYear='2019'
lat='71 13.203 N'
lon='164 15.088 W'
site_depth=45
deployment_date='2019-08-18T21:00:00'
recovery_date='2020-09-13T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2979
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19ckp2a_sbe37_3979_41.25m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s37_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0039 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
