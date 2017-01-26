#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

mooringID='16bspitae'
mooringYear='2016'
lat='56 52.08 N'
lon='164 03.16 W'
site_depth=71
deployment_date='2016-05-04 19:00:00'
recovery_date='2016-09-29 00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE16 Processing"
echo "-------------------------------------------------------------"

serial_no=6592
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe16/16bsitae_sbe16_6592_0m.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsitae_sc_0000m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc sc 0000 -kw 0 time_instrument_s False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc sc 0000 -kw 0 time_instrument_s True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=4739
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/SBE05604739_2016-10-25.cnv
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsitae_s56_0000m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0000 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

#4742 not recovered

echo "-------------------------------------------------------------"
echo "RCM Processing"
echo "-------------------------------------------------------------"

serial_no=1733SG
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/rcm_sg/16bsitae_rcm1733SG.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsitae_rcmsg_0054m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} rcmsg 0054 -dec 56.868 164.053 -kw false false -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth 
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1794
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bsitae_flsb1794_0m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsitae_ecf_0000m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0000 -kw 0 median 0.0075 48 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0000 -kw 0 median 0.0075 48 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=flsb_1796
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bsitae_flsb1796_52.25m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bsitae_ecf_0052m
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0052 -kw 0 median 0.0060 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0052 -kw 0 median 0.0060 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
