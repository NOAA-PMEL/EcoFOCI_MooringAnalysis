#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='17bs8a'
mooringYear='2017'
lat='62 11.738 N'
lon='174 39.967 W'
site_depth=74
deployment_date='2017-09-29T23:00:00'
recovery_date='2018-10-12T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6629
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs8a_sbe16_6629_20m.clean.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_sc_0020m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0020 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0020 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=1804
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs8a_sbe37_1804_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2357
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/17bs8a_sbe37_2357_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=1420
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_1420_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1423
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_1423_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1424
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_1424_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1603
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_1603_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

#set to 60s sampling, just need to decimate to 10min and ignore time correction (74s)
serial_no=1624
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_1624_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
: '

serial_no=0805
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_805_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0814
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_814_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0023m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0023 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Offset --offset -1150
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0816
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/17bs8a_sbe39_816_67m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs8a_s39_0067m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0067 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

: '
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

'