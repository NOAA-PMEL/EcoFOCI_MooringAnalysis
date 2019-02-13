#!/usr/bin/env

"""
ConfigParser.py

 Parse .pyini files (custom generated user ini files)

 These files are JSON created and are flat files which can be edited by any text reader
 
Using Anaconda packaged Python 
"""

#System Stack
import json

def get_config(infile):
    """ Input - full path to config file
    
        Output - dictionary of file config parameters
    """
    infile = str(infile)
    
    try:
        d = json.load(open(infile))
    except:
        raise RuntimeError('{0} not found'.format(infile))
        
    return d
    
def write_config(infile, d):
    """ Input - full path to config file
        Dictionary of parameters to write
        
        Output - None
    """
    infile = str(infile)
    
    try:
        d = json.dump(d, open(infile,'w'), sort_keys=True, indent=4)
    except:
        raise RuntimeError('{0} not found'.format(infile))
        


