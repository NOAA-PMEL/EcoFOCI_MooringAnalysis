#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckp2a'
mooringYear='2018'
lat='71 13.201 N'
lon='164 15.158 W'
site_depth=45
deployment_date='2018-08-13T19:00:00'
recovery_date='2019-08-14T02:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6826
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp2a_sbe16_6826_39.25m_3600.edit.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp2a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=ecobbfl2w_1307
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp2a_bbfl2wb_1307_39.25m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp2a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc ecobbfl2w 0039 -kw 0 median 0.0186 54 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc ecobbfl2w 0039 -kw 801  median 0.0186 54 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


##########################################################################################
# same code as above but creates cf compliant files - well, time var anyways
#
### CF

echo "---------------CF Time Format--------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6826
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18ckp2a_sbe16_6826_39.25m_3600.edit.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp2a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc sc 0039 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc sc 0039 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
 echo "-------------------------------------------------------------"
#Need to add CDOM and NTU channels
# calibration used is from 2016

serial_no=ecobbfl2w_1307
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckp2a_bbfl2wb_1307_39.25m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckp2a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc ecobbfl2w 0039 -kw 0 median 0.0186 54 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc ecobbfl2w 0039 -kw 801  median 0.0186 54 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
