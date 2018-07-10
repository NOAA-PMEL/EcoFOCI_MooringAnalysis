#!/bin/bash
base_path=/home/pavlof
### SG403
data_dir=/home/ecoraid/data/2018/Profilers/OculusGliders/PS_Spring/erddap/sg403/p*.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/2018/Profilers/OculusGliders/PS_Spring/sg403/p*.nc \
	/home/ecoraid/data/2018/Profilers/OculusGliders/PS_Spring/erddap/sg403/

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

### SG403
data_dir=/home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/erddap/sg403/p*.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/sg403/p*.nc \
	/home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/erddap/sg403/

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

### SG401
data_dir=/home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/erddap/sg401/p*.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/sg401/p*.nc \
	/home/ecoraid/data/2018/Profilers/OculusGliders/BS_Summer/erddap/sg401/

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


### SG401
data_dir=/home/ecoraid/data/2018/Profilers/OculusGliders/BF_Summer/erddap/sg404/p*.nc
prog_dir=${base_path}/bell/Programs/Python/EcoFOCI_MooringAnalysis/

cp -u /home/ecoraid/data/2018/Profilers/OculusGliders/BF_Summer/sg404/p*.nc \
	/home/ecoraid/data/2018/Profilers/OculusGliders/BF_Summer/erddap/sg404/

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
