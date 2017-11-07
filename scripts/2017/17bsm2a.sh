#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bsm2a'
mooringYear='2017'
lat='56 52.060 N'
lon='164 03.340 W'
site_depth=71
deployment_date='2017-04-27 22:00:00'
recovery_date='2017-09-23 17:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '
serial_no=4134
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4134_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_mt4134_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 1553 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4070
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4070_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_mt4070_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.0317083617E-03 5.5483445803E-04 1.7758501673E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 452 1.0317083617E-03 5.5483445803E-04 1.7758501673E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4063
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4063_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_mt4063_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.0779442037E-03 5.3548888556E-04 2.2064398029E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 1332 1.0779442037E-03 5.3548888556E-04 2.2064398029E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4068
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4068_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_mt4068_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.0812165705E-03 5.3371445515E-04 2.1945931158E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 624 1.0812165705E-03 5.3371445515E-04 2.1945931158E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=0653
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bsm2a_sbe16_653_44m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_sc_0044m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0044 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0044 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4139
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bsm2a_sbe16_3114_6m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_sc_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0006 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0006 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2025
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bsm2a_sbe37_2025_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s37_0012m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0012 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2022
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bsm2a_sbe37_2022_24m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s37_0024m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0024 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1866
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bsm2a_sbe37_1866_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s37_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2329
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bsm2a_sbe37_2329_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s37_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=1422
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bsm2a_sbe39_1422_21m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1802
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bsm2a_sbe39_1802_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0015 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=5285
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bsm2a_sbe39_5285_18m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0808
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bsm2a_sbe39_808_28m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0812
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bsm2a_sbe39_812_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=0815
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bsm2a_sbe39_815_39m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s39_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4611
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/17bsm2a_SBE56_4611_47m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s56_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0047 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4739
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/17bsm2a_SBE56_4739_9m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s56_0009m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0009 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4593
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/17bsm2a_SBE56_4593_55m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_s56_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0055 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bsm2a_flsb_1794_55m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_ecf_0055m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0055 -kw 0 median 0.0075 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0055 -kw 175 median 0.0075 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_1838
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bsm2a_flsb_1838_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0073 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 28 median 0.0073 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_3047
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bsm2a_flsb_3047_24m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_ecf_0024m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0024 -kw 0 median 0.0077 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0024 -kw 597 median 0.0077 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}