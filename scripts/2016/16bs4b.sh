#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16bs4b'
mooringYear='2016'
lat='57 53.811 N'
lon='168 52.919 W'
site_depth=68
deployment_date='2016-09-27 23:06:00'
recovery_date='2017-09-25 23:24:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6902
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bs4b_sbe16_6902_12p5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_sc_0011m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0011 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0011 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1805
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs4b_sbe37_1805_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s37_0053m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0053 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2024
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs4b_sbe37_2024_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s37_0029m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0029 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2341
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs4b_sbe37_2341_17p75m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s37_0016m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0016 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"


serial_no=0504
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs4b_sbe39_504_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s39_0025m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0025 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0514
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs4b_sbe39_514_19m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s39_0017m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0017 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0570
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs4b_sbe39_570_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s39_0033m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0033 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0580
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs4b_sbe39_580_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s39_0013m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0013 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0986
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs4b_sbe39_986_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_s39_0043m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0043 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '

'
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1837
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs4b_flsb_1837_13m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0073 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 194 median 0.0073 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
