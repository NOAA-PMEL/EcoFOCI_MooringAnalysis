#!/usr/bin/env python

"""
 adcp_processing.py
 
 adcp_processing.py /Users/bell/raw_data/moorings/2011/1296/ 11IPP-2A lrcp 1653 800 309 20.7
 adcp_processing.py {full directory to data} {MooringID} {instrument type} {distance to first bin} {bin depth} {inst depth} {declination correction + east}
 
 Built using Anaconda packaged Python:
 
** file name examples, with base name 4094
**   4094.bin	- bin number and distance in mm from instrument(minus numbers for upward looking)
**   4094.bt
**   4094.cor
**   4094.ein(echo intensity)
**   4094.pg - percent good file, column 1 of the data should be used as threshold for qc
**   4094.scal
**   4094.vel
**
**   variable code choices are
**      vel     - velocity
**      vvv     - velocity(using percent good 4 beam solutions >= 25%)
**      ein     - echo intensity[ein](0-255)
**      pg      - percent good
**      cor     - correletion(0-255)
**      btrack  - bottom track velocity and range
**      scalars - scalars measured at instrument, temp , heading,pitch,roll,
**                heading,pitch,roll(st_dev)
**
** ************************************************************************** */

Changes:
 09/29/2017 - Update indexing based on depth (depth index must be an integer)
 09/28/2017 - remove masking of ein file for percent good qc.  This is only valid for velocity solutions.
 02/05/2016 - created adcp_ein.json , adcp_scal.json, adcp_vel.json initialization files
    This simplifies the adcp2nc routine and puts all the EPIC/NETCDF meta info for variables
    in easy to modify, easy to read files.
 01/05/2015 - added percent good threshold to algorithm.  Mark data as bad (1e35) when channel 4 in .pg file is < 25
 11/13/2015 - error in depth conversion from bin number had depths skipping closest bin and thus
    there was an offset of the binlength being added to each depth.

Addtional Notes:
    Tested on python=2.7

TODO: support python3    
"""

import argparse
import datetime
import os

import numpy as np
import pymysql
from netCDF4 import Dataset

import adcp2nc
import utilities.ConfigParserLocal as ConfigParserLocal

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 11, 6)
__modified__ = datetime.datetime(2014, 11, 6)
__version__  = "0.1.0"
__status__   = "Development"

"""--------------------------------SQL Init----------------------------------------"""

def connect_to_DB(host, user, password, database, port):
    # Open database connection
    try:
        db = pymysql.connect(host, user, password, database, port)
    except:
        print "db error"
        
    # prepare a cursor object using cursor() method
    cursor = db.cursor(pymysql.cursors.DictCursor)
    return(db,cursor)
    
    
def close_DB(db):
    # disconnect from server
    db.close()
    
def read_mooring(db, cursor, table, MooringID):
    sql = ("SELECT * from `{0}` WHERE `MooringID`= '{1}'").format(table, MooringID)
    
    result_dic = {}
    try:
        # Execute the SQL command
        cursor.execute(sql)
        # Get column names
        rowid = {}
        counter = 0
        for i in cursor.description:
            rowid[i[0]] = counter
            counter = counter +1 
        #print rowid
        # Fetch all the rows in a list of lists.
        results = cursor.fetchall()
        for row in results:
            result_dic[row['MooringID']] ={keys: row[keys] for val, keys in enumerate(row.keys())} 
        return (result_dic)
    except:
        print "Error: unable to fecth data"

"""------------------------------- lat/lon ----------------------------------------"""

def latlon_convert(Mooring_Lat, Mooring_Lon):
    
    tlat = Mooring_Lat.strip().split() #deg min dir
    lat = float(tlat[0]) + float(tlat[1]) / 60.
    if tlat[2] == 'S':
        lat = -1 * lat
        
    tlon = Mooring_Lon.strip().split() #deg min dir
    lon = float(tlon[0]) + float(tlon[1]) / 60.
    if tlon[2] == 'E':
        lon = -1 * lon
        
    return (lat, lon)
    
"""------------------------------- rotate ----------------------------------------"""

def rotate_coord(u,v, declination_corr=0):
    """ 
    Positive corr for east
    
    """
    u_ind = (u == 1e35)
    v_ind = (v == 1e35)
    mag = np.sqrt(u**2 + v**2)
    direc = np.arctan2(u,v)
    direc =  direc + np.deg2rad(declination_corr)
    uu = mag * np.sin(direc)
    vv = mag * np.cos(direc)
    
    uu[u_ind] = 1e35
    vv[v_ind] = 1e35
    return (uu, vv)
"""------------------------------- MAIN ----------------------------------------"""

parser = argparse.ArgumentParser(description='ADCP processing')
parser.add_argument('DataPath', metavar='DataPath', type=str,
               help='full path to file')
parser.add_argument('MooringID', metavar='MooringID', type=str,
               help='MooringID 13BSM-2A')               
parser.add_argument('InstrumentType', metavar='InstrumentType', type=str,
               help='wcp or lrcp')
parser.add_argument('DistancetoFirstBin', metavar='DistancetoFirstBin', type=float,
               help='value from .rpt file in cm')
parser.add_argument('BinLength', metavar='BinLength', type=float,
               help='value from .rpt file in cm')               
parser.add_argument('Depth', metavar='Depth', type=float,
               help='Deployed Depth')
parser.add_argument('DeclinationAngle', metavar='DeclinationAngle', type=float,
               help='Positive Eastward')
parser.add_argument('-id','--invert_depth', action="store_true",
               help='Invert Depths')                              
args = parser.parse_args()

data_path = args.DataPath
inst_type = args.InstrumentType

############################################
#                                          #
# Retrieve initialization paramters from 
#   various external files
### EPIC Dictionary definitions for ADCP data ###
# If these variables are not defined, no data will be archived into the nc file for that parameter.
EPIC_VARS_dict_ein = ConfigParserLocal.get_config('adcp_ein.json')
EPIC_VARS_dict_scal = ConfigParserLocal.get_config('adcp_scal.json')
EPIC_VARS_dict_vel = ConfigParserLocal.get_config('adcp_vel.json')

###################################################################
### All meta information is maintained on Pavlof in a MySQL database
### get db meta information for mooring
#get information from local config file - a json formatted file
db_config = ConfigParserLocal.get_config('EcoFOCI_config/db_config_mooring_data.pyini')

(db,cursor) = connect_to_DB(db_config['host'], db_config['user'], db_config['password'], db_config['database'], db_config['port'])
table = 'mooringdeploymentlogs'
Mooring_Meta = read_mooring(db, cursor, table, args.MooringID)
close_DB(db)

####### pg files #########
"""
the four Percent Good values represent (in order): 
1) The percentage of good three beam solutions (one beam rejected); 
2) The percentage of good transformations (error velocity threshold not exceeded); 
3) The percentage of measurements where more than one beam was bad;
4) The percentage of measurements with four beam solutions. <--- use this to qc data stream
"""
bin, pg1, pg2, pg3, pg4,time1,time2 = {},{},{},{},{},{},{}
tk = 0

data_in = [data_path + fi for fi in os.listdir(data_path) if fi.lower().endswith('.pg')]
data_in = data_in[0]
print data_in
with open(data_in) as f:

    for k, line in enumerate(f.readlines()):
        line = line.strip().split()
        
        bin[k] = np.float(line[2])
        pg1[k] = np.float(line[3])
        pg2[k] = np.float(line[4])
        pg3[k] = np.float(line[5])
        pg4[k] = np.float(line[6])

                
    print ("Read in {0} lines of the .pg file").format(k)

#cycle through and build data arrays

depth = np.array(bin.values(), dtype='f8') #save bin as depth values to be updated later
pg4 = np.array(pg4.values(), dtype='f8')
pg4 = np.reshape(pg4, (-1,int(np.max(depth))))

#build array of indexes where pg is less then 25
pg_ind = (pg4 < 25)


####### ein files #########

#output_file - 13bsm2a_wcp_ein.nc
data_out = args.MooringID.replace("-", "") + '_'+inst_type+'_ein.unqcd.nc'
data_out = data_out.lower()

bin, ein1, ein2, ein3, ein4,time1,time2 = {},{},{},{},{},{},{}
tk = 0

data_in = [data_path + fi for fi in os.listdir(data_path) if fi.lower().endswith('.ein')]
data_in = data_in[0]
print data_in
with open(data_in) as f:

    for k, line in enumerate(f.readlines()):
        line = line.strip().split()
        
        bin[k] = np.float(line[2])
        ein1[k] = np.float(line[3])
        ein2[k] = np.float(line[4])
        ein3[k] = np.float(line[5])
        ein4[k] = np.float(line[6])

        if bin[k] == bin[0]: #assume max bins is reported as first bin value
            dtime = adcp2nc.DataTimes(line[0]+' '+line[1], isyyyymmdd=True).get_EPIC_date()
            time1[tk] = dtime[0]
            time2[tk] = dtime[1]   
            tk = tk+1

                
    print ("Read in {0} lines of the .ein file").format(k)


depth = np.array(bin.values(), dtype='f8') #save bin as depth values to be updated later
ein1 = np.array(ein1.values(), dtype='f8')
ein1 = np.reshape(ein1, (-1,int(np.max(depth))))
ein2 = np.array(ein2.values(), dtype='f8')
ein2 = np.reshape(ein2, (-1,int(np.max(depth))))
ein3 = np.array(ein3.values(), dtype='f8')
ein3 = np.reshape(ein3, (-1,int(np.max(depth))))
ein4 = np.array(ein4.values(), dtype='f8')
ein4 = np.reshape(ein4, (-1,int(np.max(depth))))

###
#apply percent good qc
###
#ein1[pg_ind] = 1e35
#ein2[pg_ind] = 1e35
#ein3[pg_ind] = 1e35
#ein4[pg_ind] = 1e35

#cycle through and build data arrays
#create a "data_dic" and associate the data with an epic key
#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
# if it is below but not the epic dic, it will not make it to the nc file
data_dic = {}
data_dic['AGC1_1221'] = ein1
data_dic['AGC2_1222'] = ein2
data_dic['AGC3_1223'] = ein3
data_dic['AGC4_1224'] = ein4

### determine bin depth from spacing and initialization information
#1/9/2015 - depths may be upsidedown for some setups - flip
if not args.invert_depth:
    #highest numbered bin is the top (near surface) so data is presented top to bottom
    #depth_range = np.arange(np.max(depth),np.min(depth)-1,-1)
    depth_val = np.round(np.arange(args.Depth - args.DistancetoFirstBin / 100, args.Depth - args.DistancetoFirstBin / 100 - ((args.BinLength -1) /100)*np.max(depth), -1 * args.BinLength /100))
    depth_val = depth_val[::-1]
else:
    print "Inverting Depths"
    #depth_range = np.arange(np.min(depth)-1,np.max(depth),1)
    depth_val = np.round(np.arange(args.Depth - args.DistancetoFirstBin / 100, args.Depth - args.DistancetoFirstBin / 100 - ((args.BinLength -1) /100)*np.max(depth), -1 * args.BinLength /100))
    
time1 = np.array(time1.values(), dtype='f8')
time2 = np.array(time2.values(), dtype='f8')

Mooring_Lat = Mooring_Meta[args.MooringID]['Latitude']
Mooring_Lon = Mooring_Meta[args.MooringID]['Longitude']

(lat,lon) = latlon_convert(Mooring_Lat, Mooring_Lon)
                
ncinstance = adcp2nc.ADCP_NC(savefile=data_out)
ncinstance.file_create()
ncinstance.sbeglobal_atts(raw_data_file=data_in.split('/')[-1], Station_Name = args.MooringID, Water_Depth=Mooring_Meta[args.MooringID]['DeploymentDepth'], InstType=inst_type)
ncinstance.dimension_init(time_len=len(time1),depth_len=np.max(depth))
ncinstance.variable_init(EPIC_VARS_dict_ein)
ncinstance.add_coord_data(depth=depth_val, latitude=lat, longitude=lon, time1=time1, time2=time2)
ncinstance.add_data(EPIC_VARS_dict_ein,data_dic=data_dic)
ncinstance.close()

####### vel files #########
#11/03/15 12:00:00  16  99999  99999  99999  99999
#11/03/15 12:00:00  15  99999  99999  99999  99999

#output_file - 13bsm2a_wcp_vel.nc
data_out = args.MooringID.replace("-", "") + '_'+inst_type+'_vel.unqcd.nc'
data_out = data_out.lower()

bin, vel1, vel2, vel3, vel4,time1,time2 = {},{},{},{},{},{},{}
tk = 0

data_in = [data_path + fi for fi in os.listdir(data_path) if fi.lower().endswith('.vel')]
data_in = data_in[0]
print data_in
with open(data_in) as f:

    for k, line in enumerate(f.readlines()):
        line = line.strip().split()
        
        bin[k] = np.float(line[2])
        #scale vel by 10 mm/s -> cm/s
        vel1[k] = np.float(line[3]) /10.
        vel2[k] = np.float(line[4]) /10.
        vel3[k] = np.float(line[5]) /10.
        vel4[k] = np.float(line[6]) /10.

        if bin[k] == bin[0]: #assume max bins is reported as first bin value
            dtime = adcp2nc.DataTimes(line[0]+' '+line[1], isyyyymmdd=True).get_EPIC_date()
            time1[tk] = dtime[0]
            time2[tk] = dtime[1]   
            tk = tk+1

                
    print ("Read in {0} lines of the .vel file").format(k)

#cycle through and build data arrays
depth = np.array(bin.values(), dtype='f8') #save bin as depth values to be updated later

vel1 = np.array(vel1.values(), dtype='f8')
vel1[vel1 == 9999.9] = 1e35
vel2 = np.array(vel2.values(), dtype='f8')
vel2[vel2 == 9999.9] = 1e35

# apply magnetic declination correction
vel1,vel2 = rotate_coord(vel1,vel2,args.DeclinationAngle)

vel1 = np.reshape(vel1, (-1,int(np.max(depth))))
vel2 = np.reshape(vel2, (-1,int(np.max(depth))))

vel3 = np.array(vel3.values(), dtype='f8')
vel3[vel3 == 9999.9] = 1e35
vel3 = np.reshape(vel3, (-1,int(np.max(depth))))
vel4 = np.array(vel4.values(), dtype='f8')
vel4[vel4 == 9999.9] = 1e35
vel4 = np.reshape(vel4, (-1,int(np.max(depth))))

#apply percent good qc
vel1[pg_ind] = 1e35
vel2[pg_ind] = 1e35
vel3[pg_ind] = 1e35
vel4[pg_ind] = 1e35

#cycle through and build data arrays
#create a "data_dic" and associate the data with an epic key
#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
# if it is below but not the epic dic, it will not make it to the nc file
data_dic = {}
data_dic['u_1205'] = vel1
data_dic['v_1206'] = vel2
data_dic['w_1204'] = vel3
data_dic['Werr_1201'] = vel4

### determine bin depth from spacing and initialization information
#1/9/2015 - depths may be upsidedown for some setups - flip
if not args.invert_depth:
    #highest numbered bin is the top (near surface) so data is presented top to bottom
    #depth_range = np.arange(np.max(depth),np.min(depth)-1,-1)
    depth_val = np.round(np.arange(args.Depth - args.DistancetoFirstBin / 100, args.Depth - args.DistancetoFirstBin / 100 - ((args.BinLength -1) /100)*np.max(depth), -1 * args.BinLength /100))
    depth_val = depth_val[::-1]
else:
    print "Inverting Depths"
    #depth_range = np.arange(np.min(depth)-1,np.max(depth),1)
    depth_val = np.round(np.arange(args.Depth - args.DistancetoFirstBin / 100, args.Depth - args.DistancetoFirstBin / 100 - ((args.BinLength -1) /100)*np.max(depth), -1 * args.BinLength /100))
    
time1 = np.array(time1.values(), dtype='f8')
time2 = np.array(time2.values(), dtype='f8')

Mooring_Lat = Mooring_Meta[args.MooringID]['Latitude']
Mooring_Lon = Mooring_Meta[args.MooringID]['Longitude']

(lat,lon) = latlon_convert(Mooring_Lat, Mooring_Lon)
                
ncinstance = adcp2nc.ADCP_NC(savefile=data_out)
ncinstance.file_create()
ncinstance.sbeglobal_atts(raw_data_file=data_in.split('/')[-1], Station_Name = args.MooringID, Water_Depth=Mooring_Meta[args.MooringID]['DeploymentDepth'], InstType=inst_type, Declination_Correction=args.DeclinationAngle)
ncinstance.dimension_init(time_len=len(time1),depth_len=np.max(depth))
ncinstance.variable_init(EPIC_VARS_dict_vel)
ncinstance.add_coord_data(depth=depth_val, latitude=lat, longitude=lon, time1=time1, time2=time2)
ncinstance.add_data(EPIC_VARS_dict_vel,data_dic=data_dic)
ncinstance.close()

####### scalar files #########
#11/03/15 12:00:00 1  7.35 355.81 -21.36  19.46     0     0     0
#11/03/15 13:00:00 1  7.56 355.77 -21.36  19.46     0     0     0
# scalar files are instrument oriented - not depth dependant

#output_file - 13bsm2a_wcp_vel.nc
data_out = args.MooringID.replace("-", "") + '_'+inst_type+'_scal.unqcd.nc'
data_out = data_out.lower()

temp, heading, pitch, role, heading_std, pitch_std, role_std ,time1,time2 = {},{},{},{},{},{},{},{},{}

data_in = [data_path + fi for fi in os.listdir(data_path) if fi.lower().endswith('.scal') or fi.lower().endswith('.sca')]
data_in = data_in[0]
print data_in
with open(data_in) as f:

    for k, line in enumerate(f.readlines()):
        line = line.strip().split()
        
        temp[k] = np.float(line[3])
        heading[k] = np.float(line[4])
        pitch[k] = np.float(line[5])
        role[k] = np.float(line[6])
        heading_std[k] = np.float(line[7])
        pitch_std[k] = np.float(line[8])
        role_std[k] = np.float(line[9])
        dtime = adcp2nc.DataTimes(line[0]+' '+line[1], isyyyymmdd=True).get_EPIC_date()
        time1[k] = dtime[0]
        time2[k] = dtime[1]   

                
    print ("Read in {0} lines of the .vel file").format(k)

#cycle through and build data arrays
#create a "data_dic" and associate the data with an epic key
#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
# if it is below but not the epic dic, it will not make it to the nc file
data_dic = {}
data_dic['T_20'] = np.array(temp.values(), dtype='f8')
data_dic['Hdg_1215'] = np.array(heading.values(), dtype='f8')
data_dic['Ptch_1216'] = np.array(pitch.values(), dtype='f8')
data_dic['Roll_1217'] = np.array(role.values(), dtype='f8')
data_dic['HSD_1218'] = np.array(heading_std.values(), dtype='f8')
data_dic['PSD_1219'] = np.array(pitch_std.values(), dtype='f8')
data_dic['RSD_1220'] = np.array(role_std.values(), dtype='f8')

time1 = np.array(time1.values(), dtype='f8')
time2 = np.array(time2.values(), dtype='f8')

Mooring_Lat = Mooring_Meta[args.MooringID]['Latitude']
Mooring_Lon = Mooring_Meta[args.MooringID]['Longitude']

(lat,lon) = latlon_convert(Mooring_Lat, Mooring_Lon)
                
ncinstance = adcp2nc.ADCP_NC(savefile=data_out)
ncinstance.file_create()
ncinstance.sbeglobal_atts(raw_data_file=data_in.split('/')[-1], Station_Name = args.MooringID, Water_Depth=Mooring_Meta[args.MooringID]['DeploymentDepth'], InstType=inst_type, Declination_Correction=args.DeclinationAngle)
ncinstance.dimension_init(time_len=len(time1))
ncinstance.variable_init(EPIC_VARS_dict_scal)
ncinstance.add_coord_data(depth=args.Depth, latitude=lat, longitude=lon, time1=time1, time2=time2)
ncinstance.add_data(EPIC_VARS_dict_scal,data_dic=data_dic)
ncinstance.close()
