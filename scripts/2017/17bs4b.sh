#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bs4b'
mooringYear='2017'
lat='57 52.3 N'
lon='168 53.540 W'
site_depth=71.59
deployment_date='2017-09-25T22:00:00'
recovery_date='2018-10-07T19:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

: '
echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=4031
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4031_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt4031_0059m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0059 -kw 0 1.0949896940E-03	5.2929816742E-04	2.2468847137E-06	 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0059 -kw 1172 1.0949896940E-03	5.2929816742E-04	2.2468847137E-06	 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4032
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4032_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt4032_0066m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0066 -kw 0 1.1042725574E-03	5.2788336610E-04	2.3179339664E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0066 -kw 1348	1.1042725574E-03	5.2788336610E-04	2.3179339664E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

serial_no=4033
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4033_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt4033_0049m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0049 -kw 0 1.1170183001E-03	5.2295716261E-04	2.3724557530E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0049 -kw 1372 1.1170183001E-03	5.2295716261E-04	2.3724557530E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

: '
serial_no=4050
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4050_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt4050_0022m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0022 -kw 0 1.0770473740E-03	5.3517005849E-04	2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0022 -kw 1495	1.0770473740E-03	5.3517005849E-04	2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4072
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4072_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt4072_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0039 -kw 0 1.1213063818E-03	5.2172449641E-04	2.3792052017E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0039 -kw 1369 1.1213063818E-03	5.2172449641E-04	2.3792052017E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "MTRduino Processing"
echo "-------------------------------------------------------------"

serial_no=5005
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/mtr/5005.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt5005_0059m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtrduino 0059 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5006
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/mtr/5006.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt5006_0066m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtrduino 0066 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5007
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/mtr/5007.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt5007_0049m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtrduino 0049 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5008
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/mtr/5008.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt5008_0022m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtrduino 0022 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5009
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/mtr/5009.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_mt5009_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtrduino 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=50217
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs4b_sbe16_50217_12.5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_sc_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0012 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0012 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2332
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs4b_sbe37_2332_18m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s37_0017m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0017 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1679
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs4b_sbe37_1679_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s37_0030m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0030 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=3979
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs4b_sbe37_3979_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s37_0054m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0054 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0509
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs4b_sbe39_509_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s39_0044m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0044 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0554
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs4b_sbe39_554_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s39_0014m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0014 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0562
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs4b_sbe39_562_19m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0563
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs4b_sbe39_563_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s39_0026m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0026 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0564
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs4b_sbe39_564_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_s39_0034m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0034 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3048
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bs4b_flsb_3048_13m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs4b_ecf_0012m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0012 -kw 0 median 0.0071 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0012 -kw 3502 median 0.0071 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
