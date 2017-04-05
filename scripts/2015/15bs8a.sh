#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='15bs8a'
mooringYear='2015'
lat='62 11.561 N'
lon='174 41.272 W'
site_depth=73
deployment_date='2015-09-24 20:00:00'
recovery_date='2016-09-25 17:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=658
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/15bs8a_sbe16_658_20m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_sc_0020m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0020 -kw time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0020 -kw time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2329
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs8a_sbe37_2329_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=3767
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs8a_sbe37_3767_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"


serial_no=1420
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_1420_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1421
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_1421_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1423
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_1423_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1423
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_1424_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1638
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_1638_67m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0067m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0067 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=809
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_809_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=810
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_810_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=814
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs8a_sbe39_814_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_s39_0023m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0023 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_158
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/15bs8a_flsb158_22m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs8a_ecf_0022m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0022 -kw 0 median 0.0076 46 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0022 -kw 389 median 0.0076 46 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

