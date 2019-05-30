#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18bs2c'
mooringYear='2018'
lat='56 52.118 N'
lon='164 03.608 W'
site_depth=74
deployment_date='2018-10-02T11:00:00'
recovery_date='2019-04-24T16:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth


echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"
: '
serial_no=7297
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/17bs2c_sbe16_7297_12m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_sc_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0012 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0012 -kw 0 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

#from uaf
serial_no=6957
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01606957_2018_05_02.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/17bs2c_sc_0067m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0067 -kw 0 time_instrument_doy False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py $	{input} ${output}.interpolated.nc sc 0067 -kw 0 time_instrument_doy True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2026
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs2c_s37_2026_0055m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s37_0055m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str 'days since 1900-01-01T00:00:00Z'

serial_no=2323
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs2c_s37_2323_0031m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s37_0031m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str 'days since 1900-01-01T00:00:00Z'

serial_no=2336
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs2c_s37_2336_0066m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s37_0066m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0066 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} --iscf --time_since_str 'days since 1900-01-01T00:00:00Z'

: '
echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

serial_no=1422
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_1422_0040m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1777
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_1777_0035m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5288
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_5288_0027m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0818
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_0818_0050m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=5286
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_5286_0045m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1773
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_1773_0060m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=3501
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/18bs2c_s39_3501_0019m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s39_0019m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0019 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bs2c_ecoflsb1794_0011m.redownload.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0077 46 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 3554 median 0.0077 46 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=flsb_1795
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18bs2c_ecoflsb1795_0023m.redownload.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_ecf_0023m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0023 -kw 0 median 0.0089 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0023 -kw 123 median 0.0089 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'