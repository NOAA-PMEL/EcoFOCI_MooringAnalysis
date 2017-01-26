#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

mooringID='15bs5a'
mooringYear='2015'
lat='59 54.684 N'
lon='171 44.124 W'
site_depth=68
deployment_date='2015-09-25 20:00:00'
recovery_date='2016-09-26 20:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=2322
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs5a_sbe37_2322_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=2323
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs5a_sbe37_2323_32m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s37_0032m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0032 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/15bs5a_sbe37_3769_17m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s37_0017m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0017 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"


serial_no=1425
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_1425_67m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0067m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0067 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1426
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_1426_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0023m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0023 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1574
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_1574_27m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0027m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0027 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1623
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_1623_35m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0035 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1773
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_1773_45m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0045 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=1778
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_1778_50m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0050m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0050 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=3759
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_3759_20m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0020m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0020 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=816
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_816_40m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0040m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0040 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}

serial_no=818
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/15bs5a_sbe39_818_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_s39_0060m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0060 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output} $mooringID -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1838
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/15bs5a_flsb1838_18m.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/15bs5a_ecf_0018m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0018 -kw 0 median 0.0072 49 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0018 -kw 137 median 0.0072 49 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}Trim_netcdf.py ${output}.interpolated.nc $mooringID -sd ${deployment_date} -ed ${recovery_date}
