#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bsm2a'
mooringYear='2018'
lat='56 51.820 N'
lon='164 03.930 W'
site_depth=71
deployment_date='2018-05-02T00:00:00'
recovery_date='2018-10-03T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3122
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3122_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_mt3122_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.1022964994E-03	5.3563313544E-04	2.2150037879E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 255 1.1022964994E-03	5.3563313544E-04	2.2150037879E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}


serial_no=3167M
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3167M_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_mt3167_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.1133320621E-03	5.3112833794E-04	2.2584713475E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 321 1.1133320621E-03	5.3112833794E-04	2.2584713475E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4022
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4022_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_mt4022_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.1076441535E-03	5.3300822761E-04	2.1964012355E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 270 1.1076441535E-03	5.3300822761E-04	2.1964012355E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

: '
#No Clock / Batteries Dead
serial_no=4081
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4081_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_mt4120_0057m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0057 -kw 0 1.0868933592E-03	5.3333862062E-04	2.2130718757E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0057 -kw 583 1.0868933592E-03	5.3333862062E-04	2.2130718757E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

: '

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=0653
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bsm2a_sbe16_653_44m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_sc_0044m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0044 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0044 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4139
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bsm2a_sbe16_3114_6m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_sc_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0006 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0006 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1853
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_1853_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0060 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset 116
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


serial_no=1869
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_1869_24m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0024m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc s37 0024 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Offset --offset 119
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc RoundTime 
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}


serial_no=2321
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_2321_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc s37 0012 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Offset --offset 31922
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Interpolate 
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.interp.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2355
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_2355_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0050 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset 27
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0504
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_504_21m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -19
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0992
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_992_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0015 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -25
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0570
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_570_18m.timefix.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -17
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0580
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_580_28m.cap
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -23
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0569
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_569_35m.timefix.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -2
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0514
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_514_39m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0039 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -3
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4739
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/18bsm2a_sbe56_4739_9m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s56_0009m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0009 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4593
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/18bsm2a_sbe56_4593_47m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s56_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0047 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4593
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/18bsm2a_sbe56_2453_55m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s56_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0055 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1837
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bsm2a_flsb1837_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0073 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 157 median 0.0073 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py Trim ${output}.interpolated.nc --trim_bounds ${deployment_date} ${recovery_date}

serial_no=flsb_3047
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bsm2a_flsb3718_25m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_ecf_0025m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0025 -kw 0 median 0.0076 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0025 -kw 4 median 0.0076 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py Trim ${output}.interpolated.nc --trim_bounds ${deployment_date} ${recovery_date}

serial_no=flsb_3047
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bsm2a_flsb3047_55m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_ecf_0055m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0055 -kw 0 median 0.0072 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0055 -kw 389 median 0.0072 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py Trim ${output}.interpolated.nc --trim_bounds ${deployment_date} ${recovery_date}
'

