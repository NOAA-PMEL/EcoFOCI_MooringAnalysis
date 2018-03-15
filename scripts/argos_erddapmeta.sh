#!/bin/bash

# Purpose:
#       Script to run ARGOS_service_data_converter.py for each file in a directory
#       and output as independant file

year=2018
path="/Volumes/WDC_internal/Users/bell/ecoraid/${year}/Drifters/erddap/initial/"

argosID="122542 136863 136866 136867 136868 136869 148276 145474"

for files in $argosID
do
    names=(${files//\// })
    outfile=${names[${#names[@]} - 1]}
    echo "processing file: $files"
	python EPICCFcfrole2ERDDAP.py ${path}${files}.y${year}.nc record_number ${files} Trajectory
	python EPIC_Latitude2degeast.py ${path}${files}.y${year}.nc -m360
done

