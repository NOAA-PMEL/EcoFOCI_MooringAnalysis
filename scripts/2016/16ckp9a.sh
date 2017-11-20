#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16ckp9a'
mooringYear='2016'
lat='72 27.822 N'
lon='156 32.880 W'
site_depth=1032
deployment_date='2016-09-08 21:15:00'
recovery_date='2017-08-03 20:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3768
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckp9a_sbe37_3768_501m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_s37_0460m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 460 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4078
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16ckp9a_sbe37_4078_110m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_s37_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "RCM9/11 Processing"
echo "-------------------------------------------------------------"

#
# Still use original rcm processing in mooringanalysis folder
#


echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=3180
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0090m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0090 -kw 0 1.0918619836E-03 5.3713222527E-04 2.1828049803E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0090 -kw 4386 1.0918619836E-03 5.3713222527E-04 2.1828049803E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=3194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0090m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0090 -kw 0 1.0901590186E-03 5.3953920653E-04 2.1113956923E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0090 -kw 10408 1.0901590186E-03 5.3953920653E-04 2.1113956923E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=3202
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0101m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0101 -kw 0 1.0919320803E-03 5.3798508599E-04 2.1422095129E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0101 -kw 4234 1.0919320803E-03 5.3798508599E-04 2.1422095129E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=3251
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0101m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0101 -kw 0 1.0771999608E-03 5.3922970737E-04 2.0931168959E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0101 -kw 5241 1.0771999608E-03 5.3922970737E-04 2.0931168959E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=3267
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0120m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0120 -kw 0 1.0621449839E-03 5.4444589290E-04 2.0204178279E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0120 -kw 5246 1.0621449839E-03 5.4444589290E-04 2.0204178279E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4004
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0120m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0120 -kw 0 1.1089194612E-03 5.2607395945E-04 2.3361551809E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0120 -kw 5007 1.1089194612E-03 5.2607395945E-04 2.3361551809E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4008
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0150m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0150 -kw 0 1.1143999233E-03 5.2524373361E-04 2.3452750731E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0150 -kw 4825 1.1143999233E-03 5.2524373361E-04 2.3452750731E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4016
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0150m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0150 -kw 0 1.1076863777E-03 5.2553104899E-04 2.3324931625E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0150 -kw 5096 1.1076863777E-03 5.2553104899E-04 2.3324931625E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4044
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0180m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0180 -kw 0 1.1168494135E-03 5.2261996352E-04 2.3792011917E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0180 -kw 4900 1.1168494135E-03 5.2261996352E-04 2.3792011917E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4046
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0180m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0180 -kw 0 1.1154487536E-03 5.2153187242E-04 2.3873158581E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0180 -kw 5248 1.1154487536E-03 5.2153187242E-04 2.3873158581E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4053
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0210m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0210 -kw 0 1.0681682897E-03 5.4240558306E-04 2.0485679452E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0210 -kw 4973 1.0681682897E-03 5.4240558306E-04 2.0485679452E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4054
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0210m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0210 -kw 0 1.1215708351E-03 5.2191358916E-04 2.3816773398E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0210 -kw 4998 1.1215708351E-03 5.2191358916E-04 2.3816773398E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4060
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0240m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0240 -kw 0 1.1150996602E-03 5.2357833241E-04 2.3717805482E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0240 -kw 4978 1.1150996602E-03 5.2357833241E-04 2.3717805482E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4065
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0240m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0240 -kw 0 1.1125488318E-03 5.2550104441E-04 2.3537404252E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0240 -kw 3965 1.1125488318E-03 5.2550104441E-04 2.3537404252E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4066
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0270m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0270 -kw 0 1.1203179241E-03 5.2480791788E-04 2.3549775480E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0270 -kw 4524 1.1203179241E-03 5.2480791788E-04 2.3549775480E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4067
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16ckp9a_mt${serial_no}_0270m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0270 -kw 0 1.1278549486E-03 5.1900463053E-04 2.4272852198E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0270 -kw 4864 1.1278549486E-03 5.1900463053E-04 2.4272852198E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
