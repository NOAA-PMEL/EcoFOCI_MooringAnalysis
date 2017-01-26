#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

mooringID='16bsm2a'
mooringYear='2016'
lat='56 52.1729 N'
lon='164 02.8716 W'
site_depth=71
deployment_date='2016-05-05 06:00:00'
recovery_date='2016-09-29 04:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '
NO DATA
serial_no=4050
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4050_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt4050_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 1553 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'
serial_no=3276
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3276_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt3276_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.0317083617E-03 5.5483445803E-04 1.7758501673E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 452 1.0317083617E-03 5.5483445803E-04 1.7758501673E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

: '
CLOCK ERROR
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4063_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt4063_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.0779442037E-03 5.3548888556E-04 2.2064398029E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 1332 1.0779442037E-03 5.3548888556E-04 2.2064398029E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'

serial_no=4068
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4068_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt4068_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.0812165705E-03 5.3371445515E-04 2.1945931158E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 624 1.0812165705E-03 5.3371445515E-04 2.1945931158E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=1815
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bsm2a_sbe16_1815_11m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_sc_0011m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0011 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0011 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4139
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bsm2a_sbe16_4139_44m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_sc_0044m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0044 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0044 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=653
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bsm2a_sbe16_653_6m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_sc_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0006 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0006 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1807
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bsm2a_sbe37_1807_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s37_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1850
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bsm2a_sbe37_1850_24m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s37_0024m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0024 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0805
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_0805_28m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=0813
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_0813_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=0990
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_0990_18m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1603
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_1603_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0015 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1640
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_1640_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1777
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_1777_21m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=0992
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_992_39m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4611
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/16bsm2a_SBE56_4611_55m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s56_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0055 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4737
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/16bsm2a_SBE56_4737_47m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s56_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0047 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_2693
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bsm2a_flsb2693_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0070 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 254 median 0.0070 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_2694
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bsm2a_flsb2694_24m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_ecf_0024m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0024 -kw 0 median 0.0072 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0024 -kw 354 median 0.0072 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'