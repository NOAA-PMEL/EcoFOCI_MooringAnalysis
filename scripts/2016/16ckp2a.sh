#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp2a'
mooringYear='2016'
lat='71 13.929 N'
lon='164 13.022 W'
site_depth=41
deployment_date='2016-09-14 22:00:00'
recovery_date='2017-08-08 18:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"


serial_no=3167
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3167M_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp2a_mt3167_0041m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0041 -kw 0 1.0629639103E-03	5.4840114661E-04	1.9572186761E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0041 -kw 857 1.0629639103E-03	5.4840114661E-04	1.9572186761E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4022
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4022_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp2a_mt4022_0041m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0041 -kw 0 1.0609758535E-03	5.4911101365E-04	1.9117141004E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0041 -kw 769 1.0609758535E-03	5.4911101365E-04	1.9117141004E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6826
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16ckp2a_sbe16_6826_38m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp2a_sc_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0040 -kw 0 time_elapsed_s false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0040 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"


serial_no=flsb_1795
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16ckp2a_flsb_1795_38m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp2a_ecf_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0040 -kw 0 median 0.0077 49 false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0040 -kw 818  median 0.0077 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=3764
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckt2a_sbe37_3764_37m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp5a_s37_0044.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0044 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'