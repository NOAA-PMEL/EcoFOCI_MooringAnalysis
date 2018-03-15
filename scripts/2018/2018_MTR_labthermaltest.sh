#!/bin/bash

# Peter ran a thermal test on 12 MTR's to evaluate the impact of the current flow
#  on the temperature.

data_dir="/Volumes/WDC_internal/Users/bell/in_and_outbox/2018/proctor/mar/Thermal_heating_test/data_reads/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='lab'
mooringYear='2018'
lat='47 36.372 N'
lon='122 19.926 W'
site_depth=0


echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=3167
input=${data_dir}3167_data.TXT
output=${data_dir}lab_mt3167
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0629639103E-03	5.4840114661E-04	1.9572186761E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=3200
input=${data_dir}3200_data.TXT
output=${data_dir}lab_mt3200
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0682669921E-03	5.4818947393E-04	1.9586421776E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4022
input=${data_dir}4022_data.TXT
output=${data_dir}lab_mt4022
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0609758535E-03	5.4911101365E-04	1.9117141004E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4041
input=${data_dir}4041_data.TXT
output=${data_dir}lab_mt4041
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0579008889E-03	5.4313360622E-04	2.0219986143E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4070
input=${data_dir}4070_data.TXT
output=${data_dir}lab_mt4070
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.1010443637E-03	5.3009599104E-04	2.2539687675E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4081
input=${data_dir}4081_data.TXT
output=${data_dir}lab_mt4081
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0385135016E-03	5.4818755525E-04	1.9338075099E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

: '
#no known calibration records for this instrument
serial_no=4083
input=${data_dir}4083_data.TXT
output=${data_dir}lab_mt4083
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0604544267E-03 5.4101047901E-04 2.0954837715E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
'

serial_no=4104
input=${data_dir}4104_data.TXT
output=${data_dir}lab_mt4104
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0426279672E-03	5.5002731135E-04	1.9002602699E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4110
input=${data_dir}4110_data.TXT
output=${data_dir}lab_mt4110
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0475197600E-03	5.5004216053E-04	1.9219203364E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4120
input=${data_dir}4120_data.TXT
output=${data_dir}lab_mt4120
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0401580263E-03	5.4942936059E-04	1.9305493987E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4121
input=${data_dir}4121_data.TXT
output=${data_dir}lab_mt4121
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0274782097E-03	5.5450982505E-04	1.8433722761E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth

serial_no=4134
input=${data_dir}4134_data.TXT
output=${data_dir}lab_mt4134
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0000 -kw 0 1.0183235883E-03	5.5551405913E-04	1.8404508229E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
