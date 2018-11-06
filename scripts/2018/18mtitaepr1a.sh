#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18mtitaepr1a'
mooringYear='2018'
lat='60 01.70 N'
lon='172 47.33 W'
site_depth=71
deployment_date='2018-05-05T02:00:00'
recovery_date='2018-08-18T18:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3200
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3200_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_mt3200_0052m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0052 -kw 0 1.1176061626E-03	5.3109857490E-04	2.2632054726E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0052 -kw 260 1.1176061626E-03	5.3109857490E-04	2.2632054726E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}


serial_no=4041
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4041_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_mt4041_0062m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0062 -kw 0 1.0966941715E-03	5.2982399741E-04	2.2533252559E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0062 -kw 0 1.0966941715E-03	5.2982399741E-04	2.2533252559E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
serial_no=4070
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4070_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_mt4070_0062m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0062 -kw 0 1.1035390933E-03	5.2929871073E-04	2.2657265735E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0062 -kw 536 1.1035390933E-03	5.2929871073E-04	2.2657265735E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

: '
serial_no=4120
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4120_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_mt4120_0057m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0057 -kw 0 1.0868933592E-03	5.3333862062E-04	2.2130718757E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0057 -kw 583 1.0868933592E-03	5.3333862062E-04	2.2130718757E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4121
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4121_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_mt4121_0057m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0057 -kw 0 1.0842492768E-03	5.3502826412E-04	2.1835588489E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0057 -kw 586 1.0842492768E-03	5.3502826412E-04	2.1835588489E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=7021
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/18mtitaepr1a_sbe16_7021_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_sc_0000m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0000 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0000 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=2452
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/18mtitaepr1a_sbe56_2452_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_s56_0000m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0000 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1838
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_flour/18mtitaepr1a_flsb_1838_0m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18mtitaepr1a_flsb_0000m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0000 -kw 0 median 0.0074 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0000 -kw -8 median 0.0074 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

'