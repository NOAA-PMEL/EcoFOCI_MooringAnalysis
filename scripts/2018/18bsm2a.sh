#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

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
'
echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"
: '
serial_no=1853
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_1853_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1869
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_1869_24m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0024m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0024 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2321
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_2321_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0012m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0012 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2355
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bsm2a_sbe37_2355_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s37_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}



echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=0504
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_504_21m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0992
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_992_15m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0015 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0570
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_570_18m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
serial_no=0580
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_580_28m.cap
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0569
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_569_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0514
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bsm2a_sbe39_514_39m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_s39_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0039 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


: '
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1837
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bsm2a_flsb1837_11m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0075 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 175 median 0.0075 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_3047
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bsm2a_flsb3047_55m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bsm2a_ecf_0055m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0073 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 28 median 0.0073 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_3047
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/17bsm2a_flsb_3047_24m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bsm2a_ecf_0024m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0024 -kw 0 median 0.0077 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0024 -kw 597 median 0.0077 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}

'