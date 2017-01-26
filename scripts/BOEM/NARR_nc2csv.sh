#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/in_and_outbox/2016/BOEM_arcwest_chaosx/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/EcoFOCI_MooringAnalysis/"

python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2010.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2010.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2011.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2011.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2012.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2012.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2013.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2013.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2014.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2014.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2015.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2015.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C2_2016.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C2_2016.csv

python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2010.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2010.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2011.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2011.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2012.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2012.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2013.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2013.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2014.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2014.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2015.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2015.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C7_2016.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C7_2016.csv

python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2010.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2010.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2011.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2011.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2012.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2012.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2013.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2013.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2014.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2014.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2015.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2015.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_SFCuv_daily/NARR_C12_2016.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_SFCuv_daily/NARR_C12_2016.csv

python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2010.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2010.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2011.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2011.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2012.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2012.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2013.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2013.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2014.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2014.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2015.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2015.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C2_2016.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C2_2016.csv

python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2010.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2010.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2011.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2011.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2012.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2012.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2013.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2013.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2014.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2014.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2015.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2015.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C7_2016.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C7_2016.csv

python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2010.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2010.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2011.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2011.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2012.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2012.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2013.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2013.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2014.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2014.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2015.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2015.csv
python ${prog_dir}nc2csv.py -timeseries -units_meta ${data_dir}NARR_solarrad_daily/NARR_C12_2016.nc -EPIC WU_422 WV_423 > ${data_dir}NARR_solarrad_daily/NARR_C12_2016.csv
