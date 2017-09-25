#!/bin/bash

site="16ckp9a"
qc_status="initial_archive"
data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2016/Moorings/${site}/${qc_status}/CF_ERDDAP/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFtimeseries2ERDDAP.py ${files} station_id ${site}
done

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_global_atts_editor.py ${files} -in
done
