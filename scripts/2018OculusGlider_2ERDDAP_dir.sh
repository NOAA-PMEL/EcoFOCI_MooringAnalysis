#!/bin/bash
base_path="/home/pavlof"
data_dir="/home/ecoraid/2018/Profilers/OculusGliders/PS_Spring/erddap/sg403/*.nc"
prog_dir="${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

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
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_V2.py ${files} 'profile_id' 
done

"---"
data_dir="/home/ecoraid/2018/Profilers/OculusGliders/BS_Summer/erddap/sg403/*.nc"
prog_dir="${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

cp "/home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/sg403/*.nc" \
	"/home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/erddap/sg403/"

###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_V2.py ${files} 'profile_id' 
done

