#!/bin/bash
data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2017/Profilers/OculusGliders/bering_sea_fall17/erddap/sg401/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"


###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP.py ${files} 'profile_id' 
done

