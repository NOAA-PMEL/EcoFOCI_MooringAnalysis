#!/bin/bash

data_dir="/Users/bell/ecoraid/2017/CTDcasts/he1702/initial_archive/*.nc"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_Time_tools.py ${files} CF_Convert -isProfile
done
