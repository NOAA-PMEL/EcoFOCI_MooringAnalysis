README
======

Converting ADCP ascii output data into NetCDF files


SYSTEM REQUIREMENTS
===================

Written for Pavlof (linux) and Downdraft (MacOSX - Shaun Bell's system)

With the necessary packages, these scripts should work on any system.

Scripts are written using Python (Anaconda Scientific Distribution) and require the following non-system packages:
argparse
MySQLDB (MySQL-Python)
netCDF4

The working system must also have access to the ecoFOCI instrument/mooring database (currently housed on pavlof)
MySQL port - 3306

{
    "database": "EcoFOCI", 
    "host": "pavlof.pmel.noaa.gov", 
    "password": "e43mqS4fusEaGJLE", 
    "user": "pythonuser",
    "port": 8889
}

Programs are currently in '/home/pavlof/bell/Python/MooringDataProcessing/adcp/' - output from the programs goes into the local
path so other users should make a copy of the folder to their local preferred working directory.



PROGRAM SETUP
=============

Create a directory in your local path (lets call it ecofoci_processing)

copy the adcp routines to this directory (cp /home/pavlof/bell/Python/MooringDataProcessing/adcp -r ~/ecofoci_processing/)

run all scripts out of this directory (cd ~/ecofoci_processing/)

There is a db_config_mooring_data.pyini file (json formatted) with login information for the database on pavlof.  This should be
modified if using a different database source (such as a local hosted version) or a different user account

RUNNING THE ROUTINES
====================

You will need the magnetic declination angle of the site in question for complete analysis.  If you don't know this already
you can run the 'mag_declination_correction.py' routine

'python mag_declination_correction.py 14UP-3A'

example output --> At Mooring 14UP-3A, with lat: 54.3016833333 (N) , lon: 164.748216667 (W) the declination correction is 10.9090246492

To process the ascii ADCP data (one mooring at a time):

python adcp_processing.py {full directory to data} {MooringID} {instrument type} {distance to first bin} {bin depth} {inst depth} {declination correction + east}

details in curly braces {} are user inputs.  Some of them are found in the reports file (.rpt)
'python adcp_processing.py -h' has help on the flags for the command line input

example:
 adcp_processing.py /home/ecoraid/data/2014/Moorings/14bsp2b/rawconverted/3072/ 14BSP-2B wcp 614 400 0062 11.43

this will output three .nc files: {MooringID}_wcp_ein.unqcd.nc , {MooringID}_wcp_ein.unqcd.nc
copy these files to the ecoraid archive

/home/ecoraid/data/{year}/Moorings/{MooringID}/initialarchive/  (<- this is where the first archival netcdf files start.  
DO NOT MODIFY these files once you've created them.  Copy a version to the /home/ecoraid/data/{year}/Moorings/{MooringID}/working/ directory or your local working directory)

It is suggested to keep track of the parameters used for future reference.  To this end there is a folder called 'scripts' where
one can build shell scripts to run the routines repeatedly and for multiple moorings at a time.

Heres and example for a few sites in 2014:
(copy of a file called 2014_Moorings_pt2.sh)
---------------------------------------------

#!/bin/bash

## on microburst
#data_dir="/Users/bell/ecoraid/"
#prog_dir="/Users/bell/Programs/Python/MooringDataProcessing/adcp/"

## on pavlof/ecorad
data_dir="/home/ecoraid/data/"
prog_dir="/home/pavlof/bell/Python/MooringDataProcessing/adcp/"


echo "ADCP Processing"
mooringYear='2014'

echo $prog_dir
echo $mooringYear

mooringID='14bsp2b'
adcpID='3072'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='614'
bin_length='400'
depth='0062'
dec_cor='11.43'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14BSP-2A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}


mooringID='14bsp6a'
adcpID='5501'

echo "-------------------------------------------------------------"
echo $mooringID $adcpID
echo $mooringYear
echo "-------------------------------------------------------------"

instrument_type='wcp'
start_bin='614'
bin_length='400'
depth='0150'
dec_cor='9.08'

python ${prog_dir}adcp_processing.py ${data_dir}${mooringYear}/Moorings/${mooringID}/rawconverted/${adcpID}/ 14BSP-2A ${instrument_type} ${start_bin} ${bin_length} ${depth} ${dec_cor}



TODO / Additional Processing:
=============================

There are not quality control routines or time check / interpolation routines existant in this folder.  These steps must
be performed using additional software (either EPIC routines developed by D. Kachel or other Python routines by S. Bell)
