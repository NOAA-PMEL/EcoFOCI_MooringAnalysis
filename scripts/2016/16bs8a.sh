#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16bs8a'
mooringYear='2016'
lat='62 11.615 N'
lon='174 41.302 W'
site_depth=68
deployment_date='2016-09-26 01:32:00'
recovery_date='2017-09-24 17:55:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=7020
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bs8a_sbe16_7020_20m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_sc_0020m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0020 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0020 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
:'
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3762
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs8a_sbe37_3762_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"


serial_no=1428
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_1428_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1433
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_1433_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1635
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_1635_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_1807_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0806
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_806_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_807_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0817
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_817_67m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0067m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0067 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=5286
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs8a_sbe39_5286_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3450
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs8a_flsb_3450_22m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs8a_ecf_0022m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0022 -kw 0 median 0.0074 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0022 -kw 364 median 0.0074 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
'
