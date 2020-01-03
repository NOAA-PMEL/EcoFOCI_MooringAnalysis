#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19bsitaepr2a'
mooringYear='2019'
lat='56 52.369 N'
lon='164 03.905 W'
site_depth=71
deployment_date='2019-04-25T00:00:00'
recovery_date='2019-09-20T23:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=7020
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/19bsitaepr2a_sbe16_7021_1m_redownload.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsitaepr2a_sc_0001m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0001 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0001 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4611
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/19bsitaepr2a_SBE05604611_2019-09-26.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsitae_s56_0052m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0052 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=7021
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/19bsitaepr2a_sbe16_7021_1m_redownload.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsitaepr2a_sc_0001m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0001 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0001 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4611
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/19bsitaepr2a_SBE05604611_2019-09-26.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsitae_s56_0052m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0052 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
