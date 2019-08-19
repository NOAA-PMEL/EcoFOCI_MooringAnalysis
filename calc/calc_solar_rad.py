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
# System Stack
import datetime

import numpy as np

from pysolar_0p6 import Pysolar

__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2016, 11, 1)
__modified__ = datetime.datetime(2016, 11, 1)
__version__ = "0.1.0"
__status__ = "Development"
__keywords__ = "solar radiation", "theoretical"


"""------------------------------------- Shear Calc -----------------------------------"""


def incoming_solar_rad(time, lat, lon, sol0=1000.0):
    """

    sol0 - W*m^-2
    """
    sol_time = Pysolar.GetSolarTime(
        lon,
        datetime.datetime.fromordinal(int(time))
        + datetime.timedelta(0, time - int(time)) * 86400,
    )

    doy = datetime.datetime.fromordinal(int(time)).timetuple().tm_yday
    solar_dec = Pysolar.GetDeclination(doy)  # deg
    hour_dec = 15 * (sol_time - 12.0)

    zenith_angle = np.sin(np.deg2rad(lat)) * np.sin(np.deg2rad(solar_dec)) + np.cos(
        np.deg2rad(lat)
    ) * np.cos(np.deg2rad(solar_dec)) * np.cos(np.deg2rad(hour_dec))

    Irr = sol0 * np.sin(zenith_angle)
    if Irr <= 0:
        Irr = 0

    return Irr
