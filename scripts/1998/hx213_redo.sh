#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/1998/CTDCasts/hx213/working/*.xlsx"
meta_dir="/Volumes/WDC_internal/Users/bell/ecoraid/1998/CTDCasts/hx213/final_data/ctd/"
out_dir="/Volumes/WDC_internal/Users/bell/ecoraid/1998/CTDCasts/hx213/working/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"


for files in $data_dir
do
    names=${files##*/}
    outfile=${names%%.*}
    echo "processing file: $outfile"
	#python ${prog_dir}EPIC_xlsx2nc.py ${files} 0 ${out_dir}${outfile}.nc ctd/98HX213_epickeys.json -ctd
	#python ${prog_dir}NetCDF_global_atts_editor.py ${meta_dir}${outfile}.nc -o -ah
	python ${prog_dir}NetCDF_global_atts_editor.py ${out_dir}${outfile}.nc -in
done