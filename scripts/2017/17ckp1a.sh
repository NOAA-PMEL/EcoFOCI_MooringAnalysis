#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17ckp1a'
mooringYear='2017'
lat='70 50.274 N'
lon='163 06.529 W'
site_depth=44
deployment_date='2017-08-09T03:14:00'
recovery_date='2018-08-14T16:38:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: "
serial_no=4424
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17ckp1a_sbe16_4424_40m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp1a_sc_0042m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0042 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0040 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#NetCDF_Trim was combined into NetCDF_Time_Tools --> below shows example of old and new api
#python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
"
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "   with triplet.  "
echo "-------------------------------------------------------------"

serial_no=bbfl2w_1419
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17ckp1a_bbfl2w_1419_40m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp1a_ecf_0040m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc ecobbfl2w 0040 -kw 0 median 0.0182 53 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc ecobbfl2w 0040 -kw 0 median 0.0182 53 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
: "

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

#2017-06-08 Cal
serial_no=3265
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/${mooringID}_mt${serial_no}_0042m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0042 -kw 0 1.0619398176E-03 5.3971302492E-04 2.0588816377E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0042 -kw 1571 1.0619398176E-03 5.3971302492E-04 2.0588816377E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

#2017-06-08 Cal
serial_no=4087
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/${mooringID}_mt${serial_no}_0042m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0042 -kw 0 1.0903720641E-03 5.3201982097E-04 2.2286983516E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0042 -kw 1649 1.0903720641E-03 5.3201982097E-04 2.2286983516E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
"