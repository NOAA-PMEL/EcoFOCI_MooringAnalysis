#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2017/CTDcasts/os1701l3/final_data/erddap/*.nc"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
    names=(${files//\// })
    outfile=${names[${#names[@]} - 1]}
    outfile=${outfile%%.*}
    echo "processing file: $files"
	python ${prog_dir}EPICCF2ERDDAP.py ${files} Profile depth ${outfile}
    #echo "processing file: $outfile"
	#python EPIC_Latitude2degeast.py ${files} -m360
done
