#!/bin/bash

site="16ckp9a"
qc_status="initial_archive"

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2016/Moorings/${site}/${qc_status}/CF_ERDDAP/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

###
# Converts EPIC two-word time code into CF compliant string format (days since)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_Time_tools.py ${files} CF_Convert
done

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2016/Moorings/${site}/${qc_status}/CF_ERDDAP/*.cf.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

###
# adds timeseries_id, profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFtimeseries2ERDDAP.py ${files} station_id ${site}
done

###
# Adds featuretype global attribute
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_global_atts_editor.py ${files} -in
done


###
# To do - add
###