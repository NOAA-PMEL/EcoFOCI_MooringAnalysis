#!/bin/bash
data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2017/Moorings/17bsitae/initial_archive/erddap/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"


###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
echo "Adding ERDDAP id"
for files in $data_dir
do
	python ${prog_dir}EPICCFprawlerprofile2ERDDAP.py ${files} 'profile_id' 
done


###
# replace lat/lon values 
echo "adding lat/lon"
for files in $data_dir
do
	python ${prog_dir}NetCDF_ReplaceVarValue.py ${files} latitude 56.864 
	python ${prog_dir}NetCDF_ReplaceVarValue.py ${files} longitude 195.947 #east
done