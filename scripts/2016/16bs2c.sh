#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16bs2c'
mooringYear='2016'
lat='56 52.484 N'
lon='164 03.038 W'
site_depth=71
deployment_date='2016-09-29 03:00:00'
recovery_date='2017-04-27 02:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '
serial_no=4050
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4050_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt4050_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 1553 1.0770473740E-03 5.3517005849E-04 2.1611858499E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3276
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3276_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt3276_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.0317083617E-03 5.5483445803E-04 1.7758501673E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 452 1.0317083617E-03 5.5483445803E-04 1.7758501673E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}


input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4063_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt4063_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.0779442037E-03 5.3548888556E-04 2.2064398029E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 1332 1.0779442037E-03 5.3548888556E-04 2.2064398029E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=4068
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4068_post_deployment_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_mt4068_0032m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0032 -kw 0 1.0812165705E-03 5.3371445515E-04 2.1945931158E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0032 -kw 624 1.0812165705E-03 5.3371445515E-04 2.1945931158E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=1815
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bsm2a_sbe16_1815_11m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_sc_0011m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0011 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0011 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2026
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs2c_sbe37_2026_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1852
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs2c_sbe37_1852_m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=0581
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_0805_28m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'
serial_no=0804
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs2c_sbe39_0804_19m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_s39_0019m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0019 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=1636
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs2c_sbe39_1636_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=4611
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/16bsm2a_SBE56_4611_55m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s56_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0055 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4737
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/16bsm2a_SBE56_4737_47m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s56_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0047 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_3073
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs2c_flsb3073_23m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_ecf_0023m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0023 -kw 0 median 0.0074 41 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0023 -kw 247 median 0.0074 41 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_657
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs2c_flsb657_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0078 92 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 354 median 0.0078 92 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}