#!/usr/bin/env python

"""
calc_shear.py

calculate the verticle shear of ocean currents from two dimensional data.

shear defined as magnitude of the shear vector / depth of the layer

    EPIC_KEY - information:
        rec_vars.append('Shr_466')
        rec_var_name.append( 'Shr' )
        rec_var_longname.append( 'Shear (s-1)' )
        rec_var_generic_name.append( '' )
        rec_var_units.append( 's-1' )
        rec_var_FORTRAN.append( '' )
        rec_var_epic.append( 466 )
"""
#System Stack
import datetime

import numpy as np

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2016, 11, 1)
__modified__ = datetime.datetime(2016, 11, 1)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'adcp', 'shear', 'vector', 'derivations'


"""------------------------------------- Shear Calc -----------------------------------"""

def calc_shear(uvect, vvect, depth):
    
    #find and replace missing data with nan for now
    uvect[np.where(uvect >1e34)] = np.nan
    vvect[np.where(vvect >1e34)] = np.nan
    
    # Vector difference
    # SQRT( (U2-U1)**2 + (V2-V1)**2 ) / depth of layer
    shear = np.sqrt( (np.diff(uvect))**2 + (np.diff(vvect))**2) / np.abs(np.diff(depth))
    
    #replace values larger than 1e35 with 1e35
    shear[np.where(shear > 1e35 )] = 1e35
    #replace missing values with 1e35
    shear[np.where(np.isnan(shear))] = 1e35
    
    shear_depthm = ( depth[:-1]+np.diff(depth)/2 ) / 100 # return in meters
    
    return shear, shear_depthm


