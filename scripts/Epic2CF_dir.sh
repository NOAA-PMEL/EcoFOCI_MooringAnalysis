#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/in_and_outbox/2017/stabeno/jan/M2_M8_SSTTemp_analysis/mooringdata/M2/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_Time_tools.py ${files} CF_Convert
done