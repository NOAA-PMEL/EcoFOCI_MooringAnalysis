#!/usr/bin/env python

"""
 mag_declination_correction.py
 
  
 Built using Anaconda packaged Python:
 

"""

# Standard library.
import datetime

# System Stack
import argparse
import pymysql


# User Stack
import utilities.ConfigParserLocal as ConfigParserLocal
import geomag.geomag.geomag as geomag


__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 01, 13)
__modified__ = datetime.datetime(2014, 01, 29)
__version__  = "0.2.0"
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
"""------------------------------- MAIN ----------------------------------------"""

parser = argparse.ArgumentParser(description='Magnetic Declination Correction')
parser.add_argument('MooringID', metavar='MooringID', type=str,
               help='MooringID 13BSM-2A')       
               
args = parser.parse_args()


#get information from local config file - a json formatted file
db_config = ConfigParserLocal.get_config('EcoFOCI_config/db_config_mooring_data.pyini')

#get db meta information for mooring
### connect to DB
(db,cursor) = connect_to_DB(db_config['host'], db_config['user'], db_config['password'], db_config['database'], db_config['port'])
table = 'mooringdeploymentlogs'
Mooring_Meta = read_mooring(db, cursor, table, args.MooringID)
close_DB(db)

Mooring_Lat = Mooring_Meta[args.MooringID]['Latitude']
Mooring_Lon = Mooring_Meta[args.MooringID]['Longitude']  

dep_date = Mooring_Meta[args.MooringID]['DeploymentDateTimeGMT'].date()

(lat,lon) = latlon_convert(Mooring_Lat, Mooring_Lon)

t = geomag.GeoMag()
dec = t.GeoMag(lat,-1 * lon,time=dep_date).dec

print ("At Mooring {0}, with lat: {1} (N) , lon: {2} (W) the declination correction is {3}").format(args.MooringID, lat, lon, dec)