#!/bin/bash

####################################################################################
#
# Prepare glider dataset for errdap hosting
#
#
####################################################################################

base_path=/home/pavlof
year=2019

### sg401
sglider=sg401
data_dir=/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/*timeseries.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/${year}/Profilers/OculusGliders/${sglider}/*timeseries.nc \
	/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/

###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_V2.py ${files} 'profile_id' 
done

### sg402
sglider=sg402
data_dir=/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/*timeseries.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/${year}/Profilers/OculusGliders/${sglider}/*timeseries.nc \
	/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/

###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_V2.py ${files} 'profile_id' 
done

### sg403
sglider=sg403
data_dir=/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/*timeseries.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/${year}/Profilers/OculusGliders/${sglider}/*timeseries.nc \
	/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/

###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_V2.py ${files} 'profile_id' 
done

### sg404
sglider=sg404
data_dir=/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/*timeseries.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/${year}/Profilers/OculusGliders/${sglider}/*timeseries.nc \
	/home/ecoraid/data/${year}/Profilers/OculusGliders/erddap/${sglider}/

###
# adds profile_id, or other to be ERDDAP/CF compliant
#
# adds missing data flag (data_fill=1.0E35)
###
for files in $data_dir
do
	echo "processing file: $files"
	python ${prog_dir}EPICCFgliderprofile2ERDDAP_V2.py ${files} 'profile_id' 
done