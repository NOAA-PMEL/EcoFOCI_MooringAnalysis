#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp3a'
mooringYear='2018'
lat='71 49.491 N'
lon='166 03.508 W'
site_depth=47
deployment_date='2018-08-12T19:00:00'
recovery_date='2019-08-13T15:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6592
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp3a_sbe16_6902_42.25m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp3a_sc_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0040 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0040 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
# unknown cal factor
serial_no=flntusb_4878
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp3a_flntusb_4878_42.25m
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp3a_eco_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc ecoflntu 0040 -kw 0 median 0.0183 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc ecoflntu 0040 -kw 575  median 0.0183 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6592
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp3a_sbe16_6902_42.25m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp3a_sc_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0040 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0040 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
 echo "-------------------------------------------------------------"
# unknown cal factor
serial_no=flntusb_4878 
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp3a_flntusb_4878_42.25m
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp3a_eco_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc ecoflntu 0040 -kw 0 median 0.0183 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc ecoflntu 0040 -kw 575  median 0.0183 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
