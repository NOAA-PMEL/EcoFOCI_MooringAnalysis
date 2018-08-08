#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bs2c'
mooringYear='2017'
lat='56 52.080 N'
lon='164 03.280 W'
site_depth=72.6
deployment_date='2017-10-02 02:00:00'
recovery_date='2018-04-30 23:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=7297
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs2c_sbe16_7297_12m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_sc_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0012 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0012 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1678
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs2c_sbe37_1678_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2026
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs2c_sbe37_2026_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2336
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs2c_sbe37_2336_66m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s37_0066m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0066 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0507
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_507_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0508
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_508_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0510
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_510_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0512
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_512_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0515
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_515_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0520
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_520_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0568
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs2c_sbe39_568_19m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_s39_0019m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0019 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bs2c_flsb_657_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0078 92 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 1801 median 0.0078 92 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_1838
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bs2c_flsb_3073_23m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_ecf_0023m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0023 -kw 0 median 0.0074 41 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0023 -kw 214 median 0.0074 41 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
