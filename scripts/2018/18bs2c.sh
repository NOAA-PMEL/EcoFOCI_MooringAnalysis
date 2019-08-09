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
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/SBE16plus_01607297_2019_07_24.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_sc_0012m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0012 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0012 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=2026
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs2c_s37_2026_0055m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2323
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs2c_s37_2323_0031m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=2336
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18bs2c_s37_2336_0066m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s37_0066m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0066 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"
: '
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
'
echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"
: '
serial_no=4737
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/SBE05604737_2019-07-11.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_s56_0023m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0023 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"
: '
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

echo "-------------------------------------------------------------"
echo "Seaguard Processing"
echo "-------------------------------------------------------------"

serial_no=1951
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/curr_oxy.csv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18bs2c_sg_0015.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0015 -dec 0 0 -kw false false indiv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth 
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
