#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='18ckv2a'
mooringYear='2018'
lat='71 13.010 N'
lon='164 14.972 W'
site_depth=46
deployment_date='2018-08-13T21:05:00'
recovery_date='2019-08-14T03:04:31'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"



echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3763
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckv2a_sbe37_3763_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_s37_0014m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0014 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckv2a_flsb_158_14m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_ecf_0016m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0016 -kw 0 median 0.0080 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0016 -kw 407 median 0.0080 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

: '
serial_no=rcm9_875
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18CKV2A_rcm9_875.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_an9_0012m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0012 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 
'

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=3194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt3194_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0006 -kw 0 1.0751976368E-03	5.4467353970E-04	2.0225420764E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0006 -kw 1121 1.0751976368E-03	5.4467353970E-04	2.0225420764E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4019
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4019_0008m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0008 -kw 0 1.0781872759E-03	5.3682510668E-04	2.1086343519E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0008 -kw 1845 1.0781872759E-03	5.3682510668E-04	2.1086343519E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4034
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4034_0010m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0010 -kw 0 1.0548110466E-03	5.4416160093E-04	2.0009640657E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0010 -kw 1290 1.0548110466E-03	5.4416160093E-04	2.0009640657E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4063
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4063_0019m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0019 -kw 0 1.0347395462E-03	5.5029779681E-04	1.9497161548E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0019 -kw 1415 1.0347395462E-03	5.5029779681E-04	1.9497161548E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4118
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4118_0025m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0025 -kw 0 1.0709531147E-03	5.3810618831E-04	2.1135753438E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0025 -kw 1635 1.0709531147E-03	5.3810618831E-04	2.1135753438E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4104
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4104_0028m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0028 -kw 0 1.0543379808E-03	5.4595473848E-04	1.9733893463E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0028 -kw 2084 1.0543379808E-03	5.4595473848E-04	1.9733893463E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4100
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4100_0031m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0031 -kw 0 1.0230934321E-03	5.5460358646E-04	1.8274835665E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0031 -kw 1565 1.0230934321E-03	5.5460358646E-04	1.8274835665E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4083
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4083_0034m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0034 -kw 0 1.0372657271E-03	5.5046825917E-04	1.8921143779E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0034 -kw 1700 1.0372657271E-03	5.5046825917E-04	1.8921143779E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4134
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4134_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0040 -kw 0 8.4458048704E-04	6.1173750284E-04	9.7099151278E-07 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0040 -kw 1594 8.4458048704E-04	6.1173750284E-04	9.7099151278E-07 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=3267
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt3267_0043m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0043 -kw 0 1.0503135958E-03	5.4849160128E-04	1.9522200350E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0043 -kw 1604 1.0503135958E-03	5.4849160128E-04	1.9522200350E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=3202
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt3202_0043m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0043 -kw 0 1.0766157369E-03	5.4323465842E-04	2.0513253294E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0043 -kw 695 1.0766157369E-03	5.4323465842E-04	2.0513253294E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}


### CF Convention

echo "------CF Convention------------------------------------------"
echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"



echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3763
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/18ckv2a_sbe37_3763_12m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_s37_0014m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0014 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
'
echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/18ckv2a_flsb_158_14m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_ecf_0016m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc eco 0016 -kw 0 median 0.0080 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc eco 0016 -kw 407 median 0.0080 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
'
echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

: '
serial_no=rcm9_875
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm/18CKV2A_rcm9_875.xlsx
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_an9_0012m.unqcd.cf.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcm9 0012 -kw True False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"
'

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

serial_no=3194
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt3194_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0006 -kw 0 1.0751976368E-03	5.4467353970E-04	2.0225420764E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0006 -kw 1121 1.0751976368E-03	5.4467353970E-04	2.0225420764E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4019
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4019_0008m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0008 -kw 0 1.0781872759E-03	5.3682510668E-04	2.1086343519E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0008 -kw 1845 1.0781872759E-03	5.3682510668E-04	2.1086343519E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4034
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4034_0010m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0010 -kw 0 1.0548110466E-03	5.4416160093E-04	2.0009640657E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0010 -kw 1290 1.0548110466E-03	5.4416160093E-04	2.0009640657E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4063
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4063_0019m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0019 -kw 0 1.0347395462E-03	5.5029779681E-04	1.9497161548E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0019 -kw 1415 1.0347395462E-03	5.5029779681E-04	1.9497161548E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4118
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4118_0025m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0025 -kw 0 1.0709531147E-03	5.3810618831E-04	2.1135753438E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0025 -kw 1635 1.0709531147E-03	5.3810618831E-04	2.1135753438E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4104
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4104_0028m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0028 -kw 0 1.0543379808E-03	5.4595473848E-04	1.9733893463E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0028 -kw 2084 1.0543379808E-03	5.4595473848E-04	1.9733893463E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4100
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4100_0031m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0031 -kw 0 1.0230934321E-03	5.5460358646E-04	1.8274835665E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0031 -kw 1565 1.0230934321E-03	5.5460358646E-04	1.8274835665E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4083
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4083_0034m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0034 -kw 0 1.0372657271E-03	5.5046825917E-04	1.8921143779E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0034 -kw 1700 1.0372657271E-03	5.5046825917E-04	1.8921143779E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=4134
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt4134_0040m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0040 -kw 0 8.4458048704E-04	6.1173750284E-04	9.7099151278E-07 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0040 -kw 1594 8.4458048704E-04	6.1173750284E-04	9.7099151278E-07 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=3267
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt3267_0043m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0043 -kw 0 1.0503135958E-03	5.4849160128E-04	1.9522200350E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0043 -kw 1604 1.0503135958E-03	5.4849160128E-04	1.9522200350E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

serial_no=3202
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/${serial_no}.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/18ckv2a_mt3202_0043m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.cf.nc mtr 0043 -kw 0 1.0766157369E-03	5.4323465842E-04	2.0513253294E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.cf.nc mtr 0043 -kw 695 1.0766157369E-03	5.4323465842E-04	2.0513253294E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth -conv CF
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.cf.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}  --iscf --time_since_str "days since 1900-01-01T00:00:00Z"

