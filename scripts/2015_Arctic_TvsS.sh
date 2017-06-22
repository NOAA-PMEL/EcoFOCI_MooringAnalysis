#!/bin/bash

data_dir="/Volumes/WDC_internal/Users/bell/ecoraid/2015/Moorings/"
prog_dir="/Volumes/WDC_internal/Users/bell/Programs/Python/EcoFOCI_MooringAnalysis/"

python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp1a/final_data/15ckp1a_sc_0039m.nc -timebounds 2016-02-01 2016-03-01 Feb
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp1a/final_data/15ckp1a_sc_0039m.nc -timebounds 2016-03-01 2016-04-01 Mar
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp1a/final_data/15ckp1a_sc_0039m.nc -timebounds 2016-04-01 2016-05-01 Apr
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp1a/final_data/15ckp1a_sc_0039m.nc -timebounds 2016-05-01 2016-06-01 May
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp1a/final_data/15ckp1a_sc_0039m.nc -timebounds 2016-06-01 2016-07-01 Jun
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp1a/final_data/15ckp1a_sc_0039m.nc -timebounds 2016-07-01 2016-08-01 Jul

python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp2a/final_data/15ckp2a_sc_0038m.nc -timebounds 2016-02-01 2016-03-01 Feb
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp2a/final_data/15ckp2a_sc_0038m.nc -timebounds 2016-03-01 2016-04-01 Mar
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp2a/final_data/15ckp2a_sc_0038m.nc -timebounds 2016-04-01 2016-05-01 Apr
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp2a/final_data/15ckp2a_sc_0038m.nc -timebounds 2016-05-01 2016-06-01 May
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp2a/final_data/15ckp2a_sc_0038m.nc -timebounds 2016-06-01 2016-07-01 Jun
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp2a/final_data/15ckp2a_sc_0038m.nc -timebounds 2016-07-01 2016-08-01 Jul

python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp4a/final_data/15ckp4a_sc_0045m.nc -timebounds 2016-02-01 2016-03-01 Feb
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp4a/final_data/15ckp4a_sc_0045m.nc -timebounds 2016-03-01 2016-04-01 Mar
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp4a/final_data/15ckp4a_sc_0045m.nc -timebounds 2016-04-01 2016-05-01 Apr
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp4a/final_data/15ckp4a_sc_0045m.nc -timebounds 2016-05-01 2016-06-01 May
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp4a/final_data/15ckp4a_sc_0045m.nc -timebounds 2016-06-01 2016-07-01 Jun
python ${prog_dir}timeseries_TvS.py ${data_dir}15ckp4a/final_data/15ckp4a_sc_0045m.nc -timebounds 2016-07-01 2016-08-01 Jul