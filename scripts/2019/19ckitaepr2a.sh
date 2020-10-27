#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19ckitaepr2a'
mooringYear='2019'
lat='71 12.739 N'
lon='164 13.341 W'
site_depth=71
deployment_date='2019-08-18T21:00:00'
recovery_date='2020-09-12T23:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4621
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/SBE-56/SBE05604621_2020-10-09.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsitae_s56_0000m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0000 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
