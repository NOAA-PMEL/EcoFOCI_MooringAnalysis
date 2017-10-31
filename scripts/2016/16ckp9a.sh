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
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0080m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0080 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0080 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0080m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0080 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0080 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3202
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0091m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0091 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0091 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3251
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0091m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0091 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0091 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3267
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0110m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0110 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0110 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4004
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0110m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0110 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0110 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4008
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0140m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0140 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0140 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4016
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0140m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0140 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0140 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4044
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0170m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0170 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0170 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4046
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0170m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0170 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0170 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4053
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0200m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0200 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0200 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4054
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0200m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0200 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0200 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4060
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0230m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0230 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0230 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4065
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_0230m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0230 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0230 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4066
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_260m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 260 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 260 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4067
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}_Data_Read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17ckp9a_mt${serial_no}_260m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 260 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 260 -kw 4386 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
