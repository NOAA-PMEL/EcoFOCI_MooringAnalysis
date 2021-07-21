#!/bin/bash

data_dir="/Users/bell/ecoraid/"
prog_dir="/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='19bsm2a'
mooringYear='2019'
lat='56 52.270 N'
lon='164 04.191 W'
site_depth=71
deployment_date='2019-04-25T05:00:00'
recovery_date='2019-09-20T00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "MTR Processing"
echo "-------------------------------------------------------------"

: '
serial_no=3122
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/mtr/3122_data_read.TXT
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_mt3122_0004m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc mtr 0004 -kw 0 1.1022964994E-03	5.3563313544E-04	2.2150037879E-06 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc mtr 0004 -kw 255 1.1022964994E-03	5.3563313544E-04	2.2150037879E-06 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

'

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=0655
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/19bsm2a_sbe16_655_44m_wetstar.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_sc_0044m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0044 -kw 0 time_elapsed_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0044 -kw -88 time_elapsed_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}


serial_no=50236
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/19bsm2a_sbe16_50236_6m_redo.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_sc_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0006 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0006 -kw 2 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}
'

#uaf
serial_no=50236
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/19bsm2a_sbe16_50236_6m_redo.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_sc_0006m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0006 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0006 -kw 2 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py ${output}.interpolated.nc Trim --trim_bounds ${deployment_date} ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=2333
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19bsm2a_s37_2333_0012m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s37_0012m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0012 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1853
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19bsm2a_s37_1852_0027m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s37_0027m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc s37 0027 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
#python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Offset --offset 119
#python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc RoundTime 
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.unqcd.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1869
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19bsm2a_s37_1869_0050m.2019.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s37_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py   ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date} 

serial_no=1804
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/19bsm2a_s37_1804_0060m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s37_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0060 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=0806
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/19bsm2a_s39_0806_0018m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1424
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/19bsm2a_s39_1424_0015m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s39_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0015 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0815
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/19bsm2a_s39_0815_0021m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0814
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/19bsm2a_s39_0814_0028m.cap
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s39_0028m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0028 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=0805
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/19bsm2a_s39_0805_0035m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=1635
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/19bsm2a_s39_1635_0039m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s39_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0039 -kw False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

: '
serial_no=4736
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/19bsm2a_0009m_SBE05604736_2019-09-26.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s56_0009m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0009 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4740
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/19bsm2a_0047m_SBE05604740_2019-09-26.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s56_0047m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0047 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=4627
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/19bsm2a_0055m_SBE05604627_2019-09-26.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_s56_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0055 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output} Trim  --trim_bounds ${deployment_date} ${recovery_date}
'
echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

: '
serial_no=flsb_3047
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/19bsm2a_ecoflsb_3047_0011m.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_ecf_0011m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0011 -kw 0 median 0.0072 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0011 -kw 365 median 0.0072 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=flsb_3718
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/19bsm2a_ecoflsb_3718_0025m.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_ecf_0025m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0025 -kw 0 median 0.0076 47 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0025 -kw 146 median 0.0076 47 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

serial_no=flsb_1837
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/19bsm2a_ecoflsb_1837_0055m.dat
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/19bsm2a_ecf_0055m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0055 -kw 0 median 0.0073 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0055 -kw 44 median 0.0073 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Time_Tools.py  ${output}.interpolated.nc Trim  --trim_bounds ${deployment_date} ${recovery_date}

'