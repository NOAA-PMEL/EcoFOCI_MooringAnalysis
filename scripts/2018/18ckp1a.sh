#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp1a'
mooringYear='2018'
lat='70 50.141 N'
lon='163 07.403 W'
site_depth=44
deployment_date='2018-08-14T17:00:00'
recovery_date='2019-08-14T14:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=6826
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp2a_sbe16_6826_39.25m_3600.edit.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp2a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=flntusb_4877
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp1a_flntusb_4877_39.75m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp1a_eco_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc ecobbfl2w 0040 -kw 0 median 0.0186 54 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc ecobbfl2w 0040 -kw 799  median 0.0186 54 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=6826
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp2a_sbe16_6826_39.25m_3600.edit.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp2a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0039 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
'

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
 echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=flntusb_4877 
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp1a_flntusb_4877_39.75m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp1a_eco_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc ecobbfl2w 0040 -kw 0 median 0.0186 54 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc ecobbfl2w 0040 -kw 799  median 0.0186 54 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
