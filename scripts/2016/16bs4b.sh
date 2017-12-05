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

: '
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
'

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=3122
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3122_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt3122_0065m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0065 -kw 0 1.10092E-03 5.36172E-04 2.20297E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0065 -kw 756 1.10092E-03 5.36172E-04 2.20297E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=3200
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3200_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt3200_0058m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0058 -kw 0 1.06827E-03 5.48189E-04 1.95864E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0058 -kw 714 1.06827E-03 5.48189E-04 1.95864E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4034
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4034_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4034_0065m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0065 -kw 0 1.04338E-03 5.48153E-04 1.92837E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0065 -kw 1109 1.04338E-03 5.48153E-04 1.92837E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4041
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4041_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4041_0038m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0038 -kw 0 1.05790E-03 5.43134E-04 2.02200E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0038 -kw 1465 1.05790E-03 5.43134E-04 2.02200E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4081
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4081_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4081_0058m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0058 -kw 0 1.03851E-03 5.48188E-04 1.93381E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0058 -kw 1333 1.03851E-03 5.48188E-04 1.93381E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4083
## no cal exists
#input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4083_data_read.TXT
#output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4083_0038m
#python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0038 -kw 0 0.001037242 0.000549406 1.89983E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0038 -kw 1434 0.001037242 0.000549406 1.89983E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4104
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4104_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4104_0021m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0021 -kw 0 1.04263E-03 5.50027E-04 1.90026E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0021 -kw 1228 1.04263E-03 5.50027E-04 1.90026E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4110
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4110_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4110_0048m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0048 -kw 0 1.04752E-03 5.50042E-04 1.92192E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0048 -kw 1450 1.04752E-03 5.50042E-04 1.92192E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4120
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4120_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4120_0021m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0021 -kw 0 1.04016E-03 5.49429E-04 1.93055E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0021 -kw 1329 1.04016E-03 5.49429E-04 1.93055E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4121
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4121_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_mt4121_0048m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0048 -kw 0 1.02748E-03 5.54510E-04 1.84337E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0048 -kw 1377 1.02748E-03 5.54510E-04 1.84337E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_1837
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs4b_flsb_1837_13m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs4b_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0073 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 194 median 0.0073 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
'
