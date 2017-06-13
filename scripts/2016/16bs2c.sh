#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

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


serial_no=3138
#cal'd July '16
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3138_download_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_mt3138_0060m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0060 -kw 0 1.0743519278E-03	5.3951922708E-04	2.1078285691E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0060 -kw 473 1.0743519278E-03 5.3951922708E-04 2.1078285691E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=3265
#cal'd July '14
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3265_download_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_mt3265_0060m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0060 -kw 0 1.0674691316E-03	5.3779220184E-04	2.0903779453E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0060 -kw 741 1.0674691316E-03	5.3779220184E-04	2.0903779453E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}


serial_no=4087
#cal'd July '06
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4087_download_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_mt4087_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0040 -kw 0 1.0617681468E-03	5.4179106334E-04	2.0582179706E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0040 -kw 778 1.0617681468E-03	5.4179106334E-04	2.0582179706E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4089
#cal'd april '13
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4089_download_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_mt4089_0050m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0050 -kw 0 1.0620535145E-03	5.4446349442E-04	2.0347961889E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0050 -kw 805 1.0620535145E-03	5.4446349442E-04	2.0347961889E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4117
#cal'd May '13
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4117_download_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_mt4117_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0040 -kw 0 1.0632642369E-03	5.4390350191E-04	2.0310834614E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0040 -kw 892 1.0632642369E-03	5.4390350191E-04	2.0310834614E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=4118
#cal'd May '13
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/4118_download_data.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_mt4118_0050m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0050 -kw 0 1.0592577053E-03	5.4198046856E-04	2.0492328692E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0050 -kw 885 1.0592577053E-03	5.4198046856E-04	2.0492328692E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

: '
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"


serial_no=1815
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bs2c_sbe16_7297_12m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_sc_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0012 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0012 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}


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
'
: '
FLOODED - NODATA
serial_no=0581
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bsm2a_sbe39_0805_28m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

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


serial_no=4591
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/SBE05604591_2017-06-07.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_s56_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0045 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
'
serial_no=flsb_3073
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs2c_flsb3073_23m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_ecf_0023m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0023 -kw 0 median 0.0074 41 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0023 -kw -1618 median 0.0074 41 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_657
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs2c_flsb657_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs2c_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0078 92 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 247 median 0.0078 92 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
