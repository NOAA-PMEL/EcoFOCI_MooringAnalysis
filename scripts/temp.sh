#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2014/Moorings/14bs8a/final_data/decimate/"

#python EPIC_xlsx2nc.py ${data_dir}14bs8a_s39_0023m.xlsx 0 ${data_dir}14bs8a_s39_0023m.1H.nc instr_config/sbe39_epickeys.json
for file in "14bs8a_s39_0023m" "14bs8a_s39_0035m" "14bs8a_s39_0040m"
do
	echo "processing file: $file"
	python EPIC_xlsx2nc.py ${data_dir}${file}.xlsx 0 ${data_dir}${file}.1H.nc instr_config/sbe39_epickeys.json
	python NetCDF_global_atts_editor.py -o ${data_dir}${file}.nc
	python NetCDF_global_atts_editor.py -in ${data_dir}${file}.1H.nc
	python NetCDF_variable_editor.py  -o ${data_dir}${file}.nc lat
	python NetCDF_variable_editor.py  -o ${data_dir}${file}.nc lon
	python NetCDF_variable_editor.py  -o ${data_dir}${file}.nc depth
	python NetCDF_variable_editor.py  -in lat ${data_dir}${file}.1H.nc lat
	python NetCDF_variable_editor.py  -in ${data_dir}${file}.1H.nc lon
	python NetCDF_variable_editor.py  -in ${data_dir}${file}.1H.nc depth
done

