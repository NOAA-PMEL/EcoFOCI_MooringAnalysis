#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2016/Moorings/16bs2c/final_data/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_Time_tools.py ${files} CF_Convert
done