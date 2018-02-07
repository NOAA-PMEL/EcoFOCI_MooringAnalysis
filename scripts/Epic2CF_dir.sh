#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/in_and_outbox/2017/stabeno/BeringM8_Historic/M2M8_NARRWinds/NARR_M8_*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}NetCDF_Time_tools.py ${files} CF_Convert
done
