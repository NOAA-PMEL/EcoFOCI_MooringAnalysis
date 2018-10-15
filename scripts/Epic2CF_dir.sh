#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2017/CTDcasts/os1702/final_data/ctd/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_Time_tools.py ${files} CF_Convert -isProfile
done
