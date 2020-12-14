#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19ckp2a'
mooringYear='2019'
lat='71 13.203 N'
lon='164 15.088 W'
site_depth=45
deployment_date='2019-08-18T21:00:00'
recovery_date='2020-09-13T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6629
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/rawconverted19ckp2a_sbe16_6629_41.25m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp2a_sc_0039m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0039 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0039 -kw -41 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=bbfl2wb_1755
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/19ckp2a_bbfl2wb_1755.redownload.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp2a_ecf_0039m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc ecobbfl2w 0039 -kw 0 median 0.182 47 0.0487 40 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc ecobbfl2w 0039 -kw 705 median 0.182 47 0.0487 40 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: "
serial_no=2979
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19ckp2a_sbe37_3979_41.25m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp2a_s37_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0039 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
"
echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

: "
serial_no=1199
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/19ckp2a_rcm1199.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19ckp2a_an9_0042m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0042 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output} Trim --trim_bounds ${deployment_date} ${recovery_date}
"