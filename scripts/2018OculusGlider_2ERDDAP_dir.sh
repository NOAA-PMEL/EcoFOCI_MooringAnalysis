#!/bin/bash
base_path=""
data_dir="${base_path}/Users/bell/ecoraid/2018/Profilers/OculusGliders/PS_Spring/erddap/sg403/*.nc"
prog_dir="${base_path}/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

cp "/home/ecoraid/data/2018/Profilers/OculusGliders/PS_Spring/sg403/*.nc" \
	"/home/ecoraid/data/2018/Profilers/OculusGliders/PS_Spring/erddap/sg403/"

###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_v2.py ${files} 'profile_id' 
done

