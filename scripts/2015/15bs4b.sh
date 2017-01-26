#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

mooringID='15bs4b'
mooringYear='2015'
lat='57 53.397 N'
lon='168 52.309 W'
site_depth=70
deployment_date='2015-09-26 23:00:00'
recovery_date='2016-09-27 22:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=4019
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4019_recovery_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_mt4019_0050m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0050 -kw 0 1.0858724332E-03 5.3405799965E-04 2.1580591791E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0050 -kw 1553 1.0858724332E-03 5.3405799965E-04 2.1580591791E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4031
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4031_recovery_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_mt4031_0050m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0050 -kw 0 1.1097966691E-03 5.2421942619E-04 2.3334233951E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0050 -kw 1200 1.1097966691E-03 5.2421942619E-04 2.3334233951E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4032
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4032_recovery_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_mt4032_0067m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0067 -kw 0 1.0726700727E-03 5.3865922941E-04 2.1301817133E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0067 -kw 1332 1.0726700727E-03 5.3865922941E-04 2.1301817133E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}


serial_no=4033
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4033_recovery_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_mt4033_0067m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0067 -kw 0 1.0858816578E-03 5.3405819115E-04 2.1579413683E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0067 -kw 1224 1.0858816578E-03 5.3405819115E-04 2.1579413683E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=655
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/15bs4b_sbe16_655_12p5m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_sc_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0012 -kw time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0012 -kw time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1678
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs4b_sbe37_1678_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=2336
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs4b_sbe37_2336_17p75m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s37_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4285
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs4b_sbe37_4285_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=1637
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_1637_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3775
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_3775_19m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0019m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0019 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=5287
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_5287_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=5288
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_5288_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=5473
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_5473_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0023m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0023 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=5474
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_5474_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0015 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=561
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs4b_sbe39_561_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4593
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/SBE05604593_2016-10-28.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs4b_s56_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0040 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
'
: '
NO Valid Data
'
