#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2016/Moorings/16bs2c/working/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFtimeseries2ERDDAP.py ${files} --add_dsg_idvar station_id --fill_value 16bs2c
done

