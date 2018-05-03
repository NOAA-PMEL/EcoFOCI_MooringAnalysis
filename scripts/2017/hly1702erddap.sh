#!/bin/bash

data_dir="/Users/bell/ecoraid/2017/CTDcasts/he1702/final_data/erddap/*.nc"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

for files in $data_dir
do
    names=(${files//\// })
    outfile=${names[${#names[@]} - 1]}
    outfile=${outfile%%.*}
    echo "processing file: $files"
	python ${prog_dir}EPICCF2ERDDAP.py ${files} Profile depth ${outfile}
done
