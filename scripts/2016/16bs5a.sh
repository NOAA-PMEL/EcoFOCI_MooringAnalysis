#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

mooringID='16bs5a'
mooringYear='2016'
lat='59 54.770 N'
lon='171 44.164 W'
site_depth=68
deployment_date='2016-09-26 22:00:00'
recovery_date='2017-09-27 00:00:00'

echo $prog_dir
echo $mooringID
echo $mooringYear
echo $lat $lon
echo $site_depth

echo "-------------------------------------------------------------"
echo "SBE37 Processing"
echo "-------------------------------------------------------------"

serial_no=1858
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs5a_sbe16_1858_55m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s37_0055m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0055 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2331
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/sbe37_2330.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s37_0015m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0015 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=3770
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe37/16bs5a_sbe37_3770_31m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s37_0031m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s37 0031 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "SBE39 Processing"
echo "-------------------------------------------------------------"


serial_no=3501
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs5a_sbe39_3501_60m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s39_0059m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0059 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=3769
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs5a_sbe39_3769_20m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s39_0018m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0018 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=3774
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs5a_sbe39_3774_67m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s39_0066m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0066 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=5286
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/sbe39/16bs5a_sbe39_5286_23m.asc
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s39_0021m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s39 0021 -kw True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}


echo "-------------------------------------------------------------"
echo "SBE56 Processing"
echo "-------------------------------------------------------------"

serial_no=2452
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s56_0039m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0039 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=2453
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s56_0049m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0049 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4627
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s56_0026m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0026 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4736
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s56_0035m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0035 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

serial_no=4740
input=${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/sbe56/
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_s56_0045m.unqcd.nc
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output} s56 0045 -kw True cnv -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output} -sd ${deployment_date} -ed ${recovery_date}

echo "-------------------------------------------------------------"
echo "Wetlabs Processing"
echo "-------------------------------------------------------------"

serial_no=flsb_1984
input=${data_dir}${mooringYear}/Moorings/${mooringID}/raw/eco_fluor/16bs5a_flsb_1984_18m.txt.txt
output=${data_dir}${mooringYear}/Moorings/${mooringID}/working/16bs5a_ecf_0016m

python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.unqcd.nc eco 0016 -kw 0 median 0.0074 50 False -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}EcoFOCIraw2nc.py ${input} ${output}.interpolated.nc eco 0016 -kw 87 median 0.0074 50 True -latlon $lat $lon -add_meta $mooringID $serial_no $site_depth
python ${prog_dir}NetCDF_Trim.py ${output}.interpolated.nc -sd ${deployment_date} -ed ${recovery_date}
