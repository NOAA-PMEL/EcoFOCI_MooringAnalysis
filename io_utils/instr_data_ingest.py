#!/usr/bin/env python

"""
 Background:
 ===========
 mooring_data.py
 
 
 Purpose:
 ========
 Various Routines and Classes to read data from the many numbers of EcoFOCI instruments
 
 History:
 ========

 2018-12-28: add pre-sg rcm to options (calculate direction from mag corrected u/v not from data report)
 2018-11-19: change all dataframes dictionary exports to ordered dict exports
 2018-11-16: Add the 5k Generation MTR --> MTRduino
 2018-10-15: Add SBE26 - Wave and Tide routines
 2017-6-09: Error in time offset correction.  Time scaling factor was determined by clockerro (seconds) / total elapsed seconds
	but the total elapsed seconds determined by the difference in max and min times was only reporting elapsed seconds of 1day
	Likely only impacts seacat, mtr, and ecoflsb instruments when clock error is large
 2016-12-16: Move time functions to time_helper.py
 2016-11-22: Add SBE16 - Aandera oxygen optode to readin routines
 2016-11-10: Add SBE16 readin routines
 2016-11-09: Add SBE37 readin routines
 2016-10-13: Add a function that rounds datetimes to nearest minute interval
 2016-10-12: Add SBE39 readin routines
 2016-10-10: Add SBE56 readin routines


 Compatibility:
 ==============
 python >=3.6 - not tested, unlikely to work without updates
 python 2.7 - Tested and developed for

"""
import datetime
import numpy as np
import pandas as pd
from io import BytesIO
from netCDF4 import num2date
from collections import OrderedDict, defaultdict

from time_helper import roundTime, linear_clock_adjust, interp2hour

def available_data_sources():
	r"""List of acronyms and options for names for instruments"""
	sources = {
			   'seacat':sbe16, 'sbe16':sbe16, 'sbe-16':sbe16, 'SBE16':sbe16, 'SBE-16':sbe16,'sc':sbe16,
			   'sbe26':sbe26, 'sbe-26':sbe26, 'SBE26':sbe26, 'SBE-26':sbe26, 's26':sbe26,
			   'microcat':sbe37, 'sbe37':sbe37, 'sbe-37':sbe37, 'SBE37':sbe37, 'SBE-37':sbe37, 's37':sbe37, 
			   'sbe39':sbe39, 'sbe-39':sbe39, 'SBE39':sbe39, 'SBE-39':sbe39, 's39':sbe39,
			   'sbe56':sbe56, 'sbe-56':sbe56, 'SBE56':sbe56, 'SBE-56':sbe56, 's56':sbe56,
			   'rcm7':rcm,'rcm9':rcm, 'rcm11':rcm,
			   'rcmsg':rcmsg,'rcm-sg':rcmsg,'rcm_sg':rcmsg,'sg':rcmsg,
			   'wpak':wpak,'met':wpak, 'atrh':'atrh', 'prawler_met':'atrh',
			   'par':'par',
			   'isus':'isus','ISUS':'isus','SUNA':'suna','suna':'suna',
			   'adcp':adcp,'lwrcp':adcp,'wcp':adcp,'adcp_ice':adcp_ice,
			   'mtr':mtr,'MTR':mtr,
			   'mtrduino':mtrduino,'MTR5k':mtrduino,
			   'eco':ecoflsb,'ecf':ecoflsb,'ecoflsb':ecoflsb,'ecofluor':ecoflsb,
			   'ecoflntu':ecoflntu,
			   'prawler':'prawler'
			   }
	return sources

def data_source_instrumentconfig(ftype='yaml'):
	r"""List of acronyms and options for names for instruments"""
	if ftype in ['json','pyini']:
		sources = {
				   'seacat':'sbe16_epickeys.json', 'sbe16':'sbe16_epickeys.json', 'sbe-16':'sbe16_epickeys.json', 
				   'SBE16':'sbe16_epickeys.json', 'SBE-16':'sbe16_epickeys.json', 'sc':'sbe16_epickeys.json',
				   'sbe26':'sbe26_epickeys.json', 'sbe-26':'sbe26_epickeys.json', 'SBE26':'sbe26_epickeys.json', 'SBE-26':'sbe26_epickeys.json', 's26':'sbe26_epickeys.json',
				   'microcat':'sbe37_epickeys.json', 'sbe37':'sbe37_epickeys.json', 'sbe-37':'sbe37_epickeys.json',
				   'SBE37':'sbe37_epickeys.json', 'SBE-37':'sbe37_epickeys.json', 's37':'sbe37_epickeys.json', 
				   'sbe39':'sbe39_epickeys.json', 'sbe-39':'sbe39_epickeys.json', 'SBE39':'sbe39_epickeys.json', 'SBE-39':'sbe39_epickeys.json', 's39':'sbe39_epickeys.json',
				   'sbe56':'sbe56_epickeys.json', 'sbe-56':'sbe56_epickeys.json', 'SBE56':'sbe56_epickeys.json', 'SBE-56':'sbe56_epickeys.json', 's56':'sbe56_epickeys.json',
				   'rcm7':'rcm_epickeys.json','rcm9':'rcm_epickeys.json','rcm11':'rcm_epickeys.json','sg':'rcmsg_epickeys.json',
				   'rcmsg':'rcmsg_epickeys.json','rcm-sg':'rcmsg_epickeys.json',
				   'rcm_sg':'rcmsg_epickeys.json','sg':'rcmsg_epickeys.json',
				   'wpak':'wpak_epickeys.json','met':'wpak_epickeys.json', 'atrh':'atrh', 'prawler_met':'atrh',
				   'par':'par',
				   'isus':'isus','ISUS':'isus','SUNA':'suna','suna':'suna',
				   'adcp':'adcp','lwrcp':'adcp','wcp':'adcp','adcp_ice':'adcp_bottom_tracking_epickeys.json',
				   'mtr':'mtr_epickeys.json','MTR':'mtr_epickeys.json',
				   'mtrduino':'mtr_epickeys.json','MTR5k':'mtr_epickeys.json',
				   'eco':'fluor_std_epickeys.json','ecf':'fluor_std_epickeys.json','ecoflsb':'fluor_std_epickeys.json','ecofluor':'eco_epickeys',
				   'ecoflntu':'fluor_ntu_std_epickeys.json',
				   'prawler':'prawler_epickeys.json'
				   }
	elif ftype in ['yaml']:
		sources = {
				   'seacat':'sbe16_epickeys.yaml', 'sbe16':'sbe16_epickeys.yaml', 'sbe-16':'sbe16_epickeys.yaml', 
				   'SBE16':'sbe16_epickeys.yaml', 'SBE-16':'sbe16_epickeys.yaml', 'sc':'sbe16_epickeys.yaml',
				   'sbe26':'sbe26_epickeys.yaml', 'sbe-26':'sbe26_epickeys.yaml', 'SBE26':'sbe26_epickeys.yaml', 'SBE-26':'sbe26_epickeys.yaml', 's26':'sbe26_epickeys.json',
				   'microcat':'sbe37_epickeys.yaml', 'sbe37':'sbe37_epickeys.yaml', 'sbe-37':'sbe37_epickeys.yaml',
				   'SBE37':'sbe37_epickeys.yaml', 'SBE-37':'sbe37_epickeys.yaml', 's37':'sbe37_epickeys.yaml', 
				   'sbe39':'sbe39_epickeys.yaml', 'sbe-39':'sbe39_epickeys.yaml', 'SBE39':'sbe39_epickeys.yaml', 'SBE-39':'sbe39_epickeys.yaml', 's39':'sbe39_epickeys.yaml',
				   'sbe56':'sbe56_epickeys.yaml', 'sbe-56':'sbe56_epickeys.yaml', 'SBE56':'sbe56_epickeys.yaml', 'SBE-56':'sbe56_epickeys.yaml', 's56':'sbe56_epickeys.yaml',
				   'rcm7':'rcm_epickeys.yaml','rcm9':'rcm_epickeys.yaml','rcm11':'rcm_epickeys.yaml','sg':'rcmsg_epickeys.yaml',
				   'rcmsg':'rcmsg_epickeys.yaml','rcm-sg':'rcmsg_epickeys.yaml',
				   'rcm_sg':'rcmsg_epickeys.yaml','sg':'rcmsg_epickeys.yaml',
				   'wpak':'wpak_epickeys.yaml','met':'wpak_epickeys.yaml', 'atrh':'atrh', 'prawler_met':'atrh',
				   'par':'par',
				   'isus':'isus','ISUS':'isus','SUNA':'suna','suna':'suna',
				   'adcp':'adcp','lwrcp':'adcp','wcp':'adcp','adcp_ice':'adcp_bottom_tracking_epickeys.yaml',
				   'mtr':'mtr_epickeys.yaml','MTR':'mtr_epickeys.yaml',
				   'mtrduino':'mtr_epickeys.yaml','MTR5k':'mtr_epickeys.yaml',
				   'eco':'fluor_std_epickeys.yaml','ecf':'fluor_std_epickeys.yaml','ecoflsb':'fluor_std_epickeys.yaml','ecofluor':'eco_epickeys',
				   'ecoflntu':'fluor_ntu_std_epickeys.yaml',
				   'prawler':'prawler_epickeys.yaml'
				   }
	else:
		raise RuntimeError('{0} format not recognized'.format(infile))

	return sources

def get_inst_data(filename, MooringID=None, source='seacat', **kwargs):
	r"""

	Parameters
	----------
	filename : string
		complete path to file to be ingested

	MooringID : string
		Unique MooringID (EcoFOCI format for cross referencing with meta database)

	source : string
		Matches available data sources to determine class instantiation
	kwargs
		Arbitrary keyword arguments to use to initialize source

	Returns
	-------
	Dataset : dictionary of dictionaries
		time : dictionary
			key: 	dataindex
			value:	datetime type
		variables : dictionary of dictionaries
			key: 	dataindex
			value:	float, int, string (depending on instrument)

	"""
	
	src = available_data_sources().get(source)
	if src is None:
		raise ValueError('Unknown source for data: {0}'.format(str(source)))

	fobj = src.get_data(filename, MooringID)
	Dataset = src.parse(fobj, **kwargs)


	return Dataset


class mtr(object):
	r""" MicroTemperature Recorders (MTR)
	Collection of static methods to define MTR processing and conversion"""

	@staticmethod
	def parse(fobj, add_seconds=0, **kwargs):
		r"""Parse MTR Data

			kwargs
			mtr_coef : list
			[CoefA, CoefB, CoefC]

		"""

		skiprows = ''
		lines = {}

		for k, line in enumerate(fobj.readlines()):
			line = line.strip()
			
			if ('READ' in line):  # Get end of header.
				skiprows = k
				print "skipping {0} header rows".format(k)

			if ('CMD' in line) and k > skiprows:  # Get end of file.
				break

			if (k > skiprows) and (skiprows != ''):
				lines[k] = line
		hexlines = lines
		declines = mtr.MTRhex2dec(hexlines)

		if not 'mtr_coef' in kwargs.keys():
			raise UnboundLocalError('No MTR Coefficients where passed as kwargs')

		for sam_num in declines:
			for k,v in declines[sam_num].items():
				if not k == 'time':
					declines[sam_num][k] = [mtr.steinhart_hart(x,kwargs['mtr_coef']) for x in declines[sam_num][k] ]

		### create time and data streams
		count = 0
		time = {}
		temp = {}
		deltat = 0 #10 min usually
		for sam_num in declines:
			time[count] = declines[sam_num]['time']
			try:
				deltat = (declines[count+1]['time'] - declines[count]['time']) # in seconds
				deltat = deltat / 120  # number of samples per record and convert 
			except:
				datetime.timedelta(0)
			#loop through dictionary rows
			for i_row in range(0,10,1): #loop through rows
				for i_col in range(0,12,1):
					temp[count] = declines[sam_num]['resistance_'+str(i_row)][i_col]        
					count +=1
					time[count] = time[count -1] + deltat
		time.pop(time.keys()[-1]) #delta function adds an extra step so remove last entry
	
		#(max time - min time) / add_seconds
		date_diff = np.max(time.values()) - np.min(time.values()) 
		add_delta_seconds = float(add_seconds) / ((date_diff.days * 24.*60.*60.)+date_diff.seconds) 
		time_orig = np.min(time.values())
		time_corr = {k:linear_clock_adjust(time_orig, v, add_delta_seconds) for k,v in time.iteritems()}


		if kwargs['tenmin_interp']:
			#put data on hourly grid
			min_t = min(time_corr.values())
			basedate = datetime.datetime( min_t.year , min_t.month , 
										  min_t.day, min_t.hour)
			rng = pd.date_range(basedate, max(time_corr.values()), freq='10min').to_pydatetime()
			trng = {k:v for k,v in enumerate(rng)}
			data = {'temperature':temp.values()}
			data_interp = interp2hour(rng, time_corr.values(), data, vlist=['temperature'])

			return ({'time':trng, 'temperature':data_interp['temperature']})

		else:			

			return ({'time':time_corr, 'temperature':temp})



	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod
	def MTRhex2dec(data_dic, model_factor=4.0e+08):
		'''
		model factor parameter is based on serial number range 
		for counts to resistance conversion
		if (args.SerialNo / 1000 == 3) or (args.SerialNo / 1000 == 4):
			model_factor = 4.0e+08
		'''
		sample_num = 0
		data = {}
		for k,v in data_dic.items():
			if len(v) == 16: #timeword mmddyyhhmmssxxxx
			 	try:
					print(datetime.datetime.strptime(v[:-4],'%m%d%y%H%M%S'))
					data[sample_num] = {'time':datetime.datetime.strptime(v[:-4],'%m%d%y%H%M%S')}
				except:
					print(datetime.datetime.strptime(v[:-6],'%m%d%y%H%M%S'))
				sample_num += 1
				start_data = 0
			elif len(v) == 4: #checksum
				continue
			elif len(v) == 48: 
				#resistance values - 4char hex, 12 measurements, 10 consecutive lines
				#break string into chunks with 4char 
				count = 4
				row = [''.join(x) for x in zip(*[list(v[z::count]) for z in range(count)])]
				#convert to decimal
				row = [int(x, 16) for x in row]
				data[sample_num -1]['resistance_'+str(start_data)] = [(model_factor / x) if x != 0 else 0 for x in row ]
				start_data += 1
			else: 
				print "This line {0} hasn't enough values".format(v)
				#periodically, it is known that a measurement gets dropped and the line needs
				# to be filled to 48 characters
			
		return data

	@staticmethod   
	def steinhart_hart(resistance, mtr_coef):
		'''mtr_coef - 3 parameters pass as a list in kwargs'''

		if resistance <= 0:
			shhh = 0
		else:
			shhh = 1.0 / (float(mtr_coef[0]) + (float(mtr_coef[1]) * np.log10(resistance)) + (float(mtr_coef[2]) * np.log10(resistance)**3)) - 273.15

		return shhh

class mtrduino(object):
	r""" MicroTemperature Recorders (MTR) - 5k / MTRduino generation
	Collection of static methods to define MTR processing and conversion

	It is assumed the data passed here is preliminarily processed and has calibration
	functions already applied

	ToDO:  Allow raw data to be passed"""
	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, **kwargs):
		r"""
		Basic Method to open and read mtrduino raw converted csv files
			
			kwargs:
				round_10min_interval - force small deviations to 10min intervals.  Actually rounds all so it
					is user responisbility to make sure values are representative first.

		"""

		rawdata = pd.read_csv(fobj,delimiter=',',
                 parse_dates=['date_time'],index_col='date_time')

		if kwargs['round_10min_interval']:
			rawdata.index=rawdata.index.round('10min',inplace=True)

		rawdata['date_time'] = rawdata.index

		return({'time':rawdata['date_time'].to_dict(into=OrderedDict),
				'Temperature':rawdata['ave'].to_dict(into=OrderedDict)})

class prawler(object):
	r"""PICO realtime transmitted data / SBE files
	The prawler project is run by PMEL/Engineering.

	Data is available internally at http://ketch.pmel.noaa.gov/~taodata/view-picoprawl.html"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod
	def parse(fobj, prawler_interp_time=False, prawler_grid_press=True, FillGaps=True):
		r"""Parse Prawler Data

			Code is biased to 2016 Bering ITAE mooring (for depth and timescales)

			kwargs
			prawler_interp_time : Boolean
				TODO:
				True - interpolates to a fixed time (likely hourly samples)
				False - no time interpolation (default)
			prawler_grid_press : Boolean
				True - interpolates to a fixed pressure grid (coded to be 0.5m)

		"""
		data_dic = {}
		startrow = ''
		data_field = False
		prw_cast_id = 1

		for k, line in enumerate(fobj.readlines()):
			line = line.strip()

			if 'Suspect' in line:
				continue

			if '<PRE>' in line:
				data_field = True
			if '</PRE>' in line:
				data_field = False
				line = []

			if '>' in line and data_field:  # get start line of data
				startrow = k + 1
				sample, Date, Time, Depth, Temp, Cond, Salinity = [], [], [], [], [], [], []
				DO, DO_Temp, DO_Sat, Chl, Turb, SigmaT  = [], [], [], [], [], []

			if (len(line) == 0):
				startrow = ''
				data_dic[prw_cast_id] = [{'sample':sample, 
										'Date':Date, 'Time':Time,
										'Depth':Depth, 
										'Temp':Temp, 
										'Cond':Cond, 
										'Salinity':Salinity, 
										'DO':DO, 
										'DO_Temp':DO_Temp, 
										'Chl':Chl, 
										'Turb':Turb,
										'SigmaT':SigmaT,
										'DO_Sat':DO_Sat}]
			prw_cast_id += 1            

			if (k >= startrow) and (startrow != '') and data_field:
				sample = sample + [line.strip().split()[0]]
				Date = Date + [line.strip().split()[1]]
				Time = Time + [line.strip().split()[2]]
				Depth = Depth + [np.float(line.strip().split()[3])]
				Temp = Temp + [np.float(line.strip().split()[4])]
				Cond = Cond + [np.float(line.strip().split()[5])]
				Salinity = Salinity + [np.float(line.strip().split()[6])]
				DO = DO + [np.float(line.strip().split()[7])]
				DO_Temp = DO_Temp + [np.float(line.strip().split()[8])]
				Chl = Chl + [np.float(line.strip().split()[9])]
				Turb = Turb + [np.float(line.strip().split()[10])]
				# calculate sigmaT at 0db gauge pressure (s, t, p=0)
				SigmaT = SigmaT + [sw.eos80.dens0(np.float(line.strip().split()[6]),np.float(line.strip().split()[4]))-1000.]
				DO_Sat = DO_Sat + [oxy_percent_sat(np.float(line.strip().split()[4]),np.float(line.strip().split()[6]),np.float(line.strip().split()[3]),np.float(line.strip().split()[7]))]
		# remove first entry for files from html/wget routines with 
		data_dic.pop(1)

		##### return here if only raw data is to be kept
		if not prawler_interp_time and not prawler_grid_press:
			return (data_dic)

		if prawler_grid_press:
			### vertically grid data to evenly space gridspoints
			pressure_grid_interval = 0.5 #m
			press_grid = np.arange(0,48,pressure_grid_interval) 

			mesh_grid_s, mesh_grid_t, mesh_grid_o, mesh_grid_chl = [], [], [], []
			mesh_grid_sig, mesh_grid_turb, mesh_grid_osat, mesh_grid_stats = [], [], [], []
			date_time = []

			for k in data_dic.keys():
				mesh_depth_s, mesh_depth_t, mesh_depth_o, mesh_depth_chl = [], [], [], []
				mesh_depth_sig, mesh_depth_turb, mesh_depth_osat, mesh_depth_stats = [], [], [], []
				irreg_depth = np.array(data_dic[k][0]['Depth'])
				irreg_sal   = np.array(data_dic[k][0]['Salinity'])
				irreg_temp  = np.array(data_dic[k][0]['Temp'])
				irreg_oxy   = np.array(data_dic[k][0]['DO'])
				irreg_osat  = np.array(data_dic[k][0]['DO_Sat'])
				irreg_chlor = np.array(data_dic[k][0]['Chl'])
				irreg_sigmat= np.array(data_dic[k][0]['SigmaT'])
				irreg_turb  = np.array(data_dic[k][0]['Turb'])
				cast_date   = mpl.dates.date2num(datetime.datetime.strptime(data_dic[k][0]['Date'][0] + ' ' + data_dic[k][0]['Time'][0],'%Y-%m-%d %H:%M:%S'))
				for pg in press_grid:
					ireg_ind = np.where((irreg_depth > pg) & (irreg_depth <= pg+pressure_grid_interval))
					mesh_depth_s = np.hstack((mesh_depth_s, np.median(irreg_sal[ireg_ind])))
					mesh_depth_sig = np.hstack((mesh_depth_sig, np.median(irreg_sigmat[ireg_ind])))
					mesh_depth_t = np.hstack((mesh_depth_t, np.median(irreg_temp[ireg_ind])))
					mesh_depth_o = np.hstack((mesh_depth_o, np.median(irreg_oxy[ireg_ind])))
					mesh_depth_osat = np.hstack((mesh_depth_osat, np.median(irreg_osat[ireg_ind])))
					mesh_depth_chl = np.hstack((mesh_depth_chl, np.median(irreg_chlor[ireg_ind])))
					mesh_depth_turb = np.hstack((mesh_depth_turb, np.median(irreg_turb[ireg_ind])))
					mesh_depth_stats = np.hstack((mesh_depth_stats, ireg_ind[0].size))
				
				if FillGaps:
					mask = np.isnan(mesh_depth_s)
					mesh_depth_s[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_s[~mask])
					mask = np.isnan(mesh_depth_t)
					mesh_depth_t[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_t[~mask])
					mask = np.isnan(mesh_depth_o)
					try:
						mesh_depth_o[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_o[~mask])
					except ValueError: #handles samples with all nan's
						mesh_depth_o[0]  = 0.0
						mesh_depth_o[-1] = 0.0
						mask = np.isnan(mesh_depth_o)
						mesh_depth_o[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_o[~mask])
					mask = np.isnan(mesh_depth_osat)
					try:
						mesh_depth_osat[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_osat[~mask])
					except ValueError: #handles samples with all nan's
						mesh_depth_osat[0]  = 0.0
						mesh_depth_osat[-1] = 0.0
						mask = np.isnan(mesh_depth_osat)
						mesh_depth_osat[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_osat[~mask])
					mask = np.isnan(mesh_depth_chl)
					try:
						mesh_depth_chl[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_chl[~mask])
					except ValueError: #handles samples with all nan's
						mesh_depth_chl[0]  = 0.0
						mesh_depth_chl[-1] = 0.0
						mask = np.isnan(mesh_depth_chl)
						mesh_depth_chl[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_chl[~mask])
					mask = np.isnan(mesh_depth_turb)
					try:
						mesh_depth_turb[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_turb[~mask])
					except ValueError: #handles samples with all nan's
						mesh_depth_turb[0]  = 0.0
						mesh_depth_turb[-1] = 0.0
						mask = np.isnan(mesh_depth_turb)
						mesh_depth_turb[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_turb[~mask])
					mask = np.isnan(mesh_depth_sig)
					mesh_depth_sig[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_depth_sig[~mask])        

				date_time = date_time + [cast_date]

				mesh_grid_s = mesh_grid_s + [mesh_depth_s]
				mesh_grid_t = mesh_grid_t + [mesh_depth_t]
				mesh_grid_o = mesh_grid_o + [mesh_depth_o]
				mesh_grid_osat = mesh_grid_osat + [mesh_depth_osat]
				mesh_grid_chl = mesh_grid_chl + [mesh_depth_chl]
				mesh_grid_sig = mesh_grid_sig + [mesh_depth_sig]
				mesh_grid_turb = mesh_grid_turb + [mesh_depth_turb]
				mesh_grid_stats = mesh_grid_stats + [mesh_depth_stats]

			date_time = np.array(date_time)

			return()
		#grid time data
		if prawler_interp_time:
			# put data on a regular time grid (needed for imageshow() but not for contourf )
			dt = 1.0/24.0
			time_grid = np.arange(date_time.min(),date_time.max(),dt)
			#grid_bounds = np.meshgrid(time_grid,press_grid)
			mesh_grid_sf = interpolate.interp2d(press_grid,date_time,mesh_grid_s, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_s = mesh_grid_sf(press_grid,time_grid)
			mesh_grid_tf = interpolate.interp2d(press_grid,date_time,mesh_grid_t, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_t = mesh_grid_tf(press_grid,time_grid)
			mesh_grid_of = interpolate.interp2d(press_grid,date_time,mesh_grid_o, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_o = mesh_grid_of(press_grid,time_grid)
			mesh_grid_osatf = interpolate.interp2d(press_grid,date_time,mesh_grid_osat, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_osat = mesh_grid_osatf(press_grid,time_grid)
			mesh_grid_chlf = interpolate.interp2d(press_grid,date_time,mesh_grid_chl, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_chl = mesh_grid_chlf(press_grid,time_grid)
			mesh_grid_sigf = interpolate.interp2d(press_grid,date_time,mesh_grid_sig, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_sig = mesh_grid_sigf(press_grid,time_grid)
			mesh_grid_turbf = interpolate.interp2d(press_grid,date_time,mesh_grid_turb, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_turb = mesh_grid_turbf(press_grid,time_grid)
			mesh_grid_statsf = interpolate.interp2d(press_grid,date_time,mesh_grid_stats, kind='linear', copy=True, fill_value=np.nan)
			mesh_grid_stats = mesh_grid_statsf(press_grid,time_grid)

			date_time = time_grid

class seabird_header(object):
	r""" Seabird Instruments have a header usually defined by *END with a significant amount of
	information imbedded.  Send a flag to parse seabird headers.  Better yet may be to combine seabird gear
	into classes and subclasses.
	"""
	pass

class sbe16(object):
	r"""Seacat / SBE-16 files with optional ancillary sensors"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, add_seconds=0, hourly_interp=True, **kwargs):
		r"""
		Basic Method to open and read sbe16 cnv files

		Variations:
			The listing of available instruments comes from the header of the seabird file.

		"""

		endheaderrows = ''
		var_names = {}
		data = {}

		for k, line in enumerate(fobj.readlines()):
			line = line.strip()

			if '# name' in line:
				var_names[int(line.split('=')[0].split()[-1])] = line.split('=')[1].split()[0]
			if '# start_time' in line:
				start_time = line.split('[')[0].split('=')[-1].strip()
			if line == '*END*':  # Get end of header.
				endheaderrows = k

			if (k > endheaderrows) and (endheaderrows != ''):
				data[k-endheaderrows-1] = line.split()

		#
		(k, var_id, sbe16data) = (k-endheaderrows-1, var_names, data)


		### cycle through variable names in header to retrieve which column they are in for ingest
		cond, sal, temp = {}, {}, {}
		par, V0, depth = {}, {}, {}
		chl_a, aan_opt_4831, sbe47_oxyconc = {}, {}, {}
		print ("Variables in SBE file are {0}").format(" ".join(var_id.values()))
		for var_index in sorted(var_id.keys()):
			if var_id[var_index] == 'c0mS/cm:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					cond[k] = float(v[var_index])
			elif var_id[var_index] == 'c0S/m:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					cond[k] = float(v[var_index]) 
				for k in cond:
					cond[k] = float(cond[k]) * 10.0 #scale to keep units as mS/cm
			elif var_id[var_index] == 'sal00:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					sal[k] = float(v[var_index])
			elif (var_id[var_index] == 'tv290C:') or (var_id[var_index] == 't090C:'):
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					temp[k] = float(v[var_index])        
			elif var_id[var_index] == 'par:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					par[k] = float(v[var_index])
			elif var_id[var_index] == 'v0:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					V0[k] = float(v[var_index])
			elif var_id[var_index] == 'prDM:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					depth[k] = float(v[var_index])
				depth_flag = True
			elif var_id[var_index] == 'wetStar:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					#chl_a[k] = float(v[var_index]) / 1000. #units are ug/m^3 -> converted to ug/l
					chl_a[k] = float(v[var_index])  #units are mg/m^3 -> converted to ug/l
			elif var_id[var_index] == 'flECO-AFL:':
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					chl_a[k] = float(v[var_index])  #units are mg/m^3 -> equivalent to ug/l
			elif var_id[var_index] == 'upoly0:': #likely aanderaa optode
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					aan_opt_4831[k] = float(v[var_index])  #units are mg/m^3 -> equivalent to ug/l
			elif var_id[var_index] == 'sbeox0Mm/Kg:': #likely sbe-49 oxy
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					sbe47_oxyconc[k] = float(v[var_index])  #units are Mm/Kg
			elif var_id[var_index] == 'sbox0Mm/Kg:': #likely sbe-49 oxy
				print "Processing {0}".format(var_id[var_index])
				for k,v in sbe16data.items():
					sbe47_oxyconc[k] = float(v[var_index])  #units are Mm/Kg
			#### Following ifs are all relevant to a variety of time output fields                
			elif var_id[var_index] == 'timeS:': #elapsed time since instrument turned on... not date aware
				print "Processing {0}".format(var_id[var_index])
				timeelapseds,delta_time = {},{}
				for k,v in sbe16data.items():
					timeelapseds[k] = float(v[var_index])
					delta_time[k] = datetime.timedelta(0,timeelapseds[k]) 
	   
			elif var_id[var_index] == 'timeJV2:': # timeJV2 for julian days
				print "Processing {0}".format(var_id[var_index])
				time_instrument_doy = {}
				for k,v in sbe16data.items():
					time_instrument_doy[k] = float(v[var_index])

			elif var_id[var_index] == 'timeK:': # Time, Instrument [seconds] is a serial date based on seconds since 2000-1-1
				print "Processing {0}".format(var_id[var_index])
				time_instrument_s = {}
				for k,v in sbe16data.items():
					time_instrument_s[k] = num2date(float(v[var_index]),"seconds since 2000-01-01")

			else:
				print "Currently skipping {0}".format(var_id[var_index])  

		#use start time and elapsed time in seconds to get timestamp
		if kwargs['time_stamp'] == 'time_elapsed_s':
			print "Converting elapsed time to python datetime object"
			time = {}
			for k,v in delta_time.items():
				time[k]  = v + datetime.datetime.strptime(start_time, '%b %d %Y %H:%M:%S')
		elif kwargs['time_stamp'] == 'time_instrument_s':
			print "Converting instrument time in seconds to python datetime object"
			time = {}
			for k,v in time_instrument_s.items():
				time[k] = v
		elif kwargs['time_stamp'] == 'time_instrument_doy':
			print "Converting instrument time in fractional_doy to python datetime object"
			time = {}
			for k,v in time_instrument_doy.items():
				time[k] = datetime.datetime(datetime.datetime.strptime(start_time, '%b %d %Y %H:%M:%S').year,1,1) + datetime.timedelta(v -1)

		#(max time - min time) / add_seconds
		date_diff = np.max(time.values()) - np.min(time.values()) 
		add_delta_seconds = float(add_seconds) / ((date_diff.days * 24.*60.*60.)+date_diff.seconds) 
		time_orig = np.min(time.values())
		time_corr = {k:linear_clock_adjust(time_orig, v, add_delta_seconds) for k,v in time.iteritems()}


		if hourly_interp:
			#put data on hourly grid
			min_t = min(time_corr.values())
			basedate = datetime.datetime( min_t.year , min_t.month , 
										  min_t.day, min_t.hour)
			rng = pd.date_range(basedate, max(time_corr.values()), freq='H').to_pydatetime()
			trng = {k:v for k,v in enumerate(rng)}
			data = {'Temperature':temp.values(), 'Pressure':depth.values(), 
				'Conductivity':cond.values(), 'Salinity':sal.values(),
				'Chlor_a':chl_a.values(), 'PAR':par.values(), 'OXY_CONC':sbe47_oxyconc.values(),
				'Volts0':V0.values(), 'AAN_OXY':aan_opt_4831.values()}
			data_interp = interp2hour(rng, time_corr.values(), data, vlist=['Temperature', 'Pressure', 
				'Conductivity', 'Salinity', 'Chlor_a', 'PAR', 'Volts0', 'AAN_OXY', 'OXY_CONC'])
			
			return ({'time':trng, 'Temperature':data_interp['Temperature'], 'Pressure':data_interp['Pressure'], 
				'Conductivity':data_interp['Conductivity'], 'Salinity':data_interp['Salinity'], 'OXY_CONC':data_interp['OXY_CONC'], 
				'Chlor_a':data_interp['Chlor_a'], 'PAR':data_interp['PAR'], 'Volts0':data_interp['Volts0'], 'AAN_OXY':data_interp['AAN_OXY']})
		else:			
			return ({'time':time, 'Temperature':temp.values(), 'Pressure':depth.values(), 
				'Conductivity':cond.values(), 'Salinity':sal.values(), 'Chlor_a':chl_a.values(), 
				'PAR':par.values(), 'OXY_CONC':sbe47_oxyconc.values(),
				'Volts0':V0.values(),'AAN_OXY':aan_opt_4831.values()})

class sbe26(object):
	r""" Seabird 26 Wave and Tide GuageTemperature (with optional pressure)
		
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments

			kwargs
			truncate_seconds : boolean -> sbe26.parse()

	"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, **kwargs):
		r"""
		Basic Method to open and read sbe56 csv files
			
			kwargs
			truncate_seconds : boolean (truncates down to nearest minute)

		"""

		rawdata = pd.read_csv(fobj, delimiter='\s+', skiprows=1,
									names=['date','time','psia','degC']) 
		rawdata = rawdata.set_index(pd.DatetimeIndex(rawdata['date']+' '+rawdata['time']))
		rawdata.drop(['date','time'],1,inplace=True)

		rawdata['mbar'] = rawdata['psia'] * 0.689476

		if kwargs['round_quarter_hour']:
			rawdata.index=rawdata.index.round('15min',inplace=True)

		rawdata['date_time'] = rawdata.index

		return({'time':rawdata['date_time'].to_dict(into=OrderedDict),
			 	'Pressure':rawdata['mbar'].to_dict(into=OrderedDict),
				'Temperature':rawdata['degC'].to_dict(into=OrderedDict)})

class sbe37(object):
	r"""Seabird 37 Microcat / SBE-37 Temperature/Conductivity (with optional pressure)"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())


	@staticmethod	
	def parse(fobj, sal_output=False, press_output=False, **kwargs):
		r"""
		Basic Method to open and read sbe37 csv files

		Variations:
			Not all instruments have a pressure sensor and some older versions cannot
			output salinity directly.  This leads to variable data entries in columns

			Look for key words in the meta data to try to determine which variation to run 
			or pass kwargs in
		"""
		depth,cond,salinity,temp,time = {},{},{},{},{}
		skiprows = ''

		for k, line in enumerate(fobj.readlines()):

			line = line.strip()

			if line == '*END*':  # Get end of header.
				skiprows = k + 3

			if '* output salinity' in line:
				sal_output = True

			if '* pressure' in line:
				press_output = True

			if (k > skiprows) and (skiprows != ''):
				if sal_output and press_output: #temp, cond, press, sal, date, time
					temp[k - skiprows] = np.float(line.strip().split(',')[0].strip())
					cond[k - skiprows] = np.float(line.strip().split(',')[1].strip()) * 10. #scale to mmho
					depth[k - skiprows] = np.float(line.strip().split(',')[2].strip())
					salinity[k - skiprows] = np.float(line.strip().split(',')[3].strip())

					if kwargs['truncate_seconds']:
						t = datetime.datetime.strptime(line.strip().split(',')[4].strip() + ' ' + line.strip().split(',')[5].strip(),"%d %b %Y %H:%M:%S")
						time[k - skiprows] = t - datetime.timedelta(seconds=t.second)
					else:
						time[k - skiprows] = datetime.datetime.strptime(line.strip().split(',')[4].strip() + ' ' + line.strip().split(',')[5].strip(),"%d %b %Y %H:%M:%S")

				if sal_output and not press_output: #temp, cond, sal, date, time
					temp[k - skiprows] = np.float(line.strip().split(',')[0].strip())
					cond[k - skiprows] = np.float(line.strip().split(',')[1].strip()) * 10. #scale to mmho
					depth[k - skiprows] = -9999.
					salinity[k - skiprows] = np.float(line.strip().split(',')[2].strip())
					dt = line.strip().split(',')[3].strip() + ' ' + line.strip().split(',')[4].strip()             		

					if kwargs['truncate_seconds']:
						t = datetime.datetime.strptime(line.strip().split(',')[3].strip() + ' ' + line.strip().split(',')[4].strip(),"%d %b %Y %H:%M:%S")
						time[k - skiprows] = t - datetime.timedelta(seconds=t.second)
					else:
						time[k - skiprows] = datetime.datetime.strptime(line.strip().split(',')[3].strip() + ' ' + line.strip().split(',')[4].strip(),"%d %b %Y %H:%M:%S")

				if not sal_output and not press_output: #temp, cond, press, date, time
					temp[k - skiprows] = np.float(line.strip().split(',')[0].strip())
					cond[k - skiprows] = np.float(line.strip().split(',')[1].strip()) * 10. #scale to mmho
					depth[k - skiprows] = -9999.
					salinity[k - skiprows] = -9999.
					dt = line.strip().split(',')[2].strip() + ' ' + line.strip().split(',')[3].strip()             		

					if kwargs['truncate_seconds']:
						t = datetime.datetime.strptime(line.strip().split(',')[2].strip() + ' ' + line.strip().split(',')[3].strip(),"%d %b %Y %H:%M:%S")
						time[k - skiprows] = t - datetime.timedelta(seconds=t.second)
					else:
						time[k - skiprows] = datetime.datetime.strptime(line.strip().split(',')[2].strip() + ' ' + line.strip().split(',')[3].strip(),"%d %b %Y %H:%M:%S")

		return ({'time':time, 'Temperature':temp, 'Pressure':depth, 'Conductivity':cond, 'Salinity':salinity })

class sbe39(object):
	r""" Seabird 39 Temperature (with optional pressure)
		
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments

			kwargs
			truncate_seconds : boolean -> sbe39.parse()

	"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, **kwargs):
		r"""
		Basic Method to open and read sbe56 csv files
			
			kwargs
			truncate_seconds : boolean (truncates down to nearest minute)

		"""


		temp,depth,time = {},{},{}
		skiprows = ''

		for k, line in enumerate(fobj.readlines()):
			line = line.strip()
			if len(line.strip().split(',') ) == 4:
				has_pressure = True
			elif len(line.strip().split(',') ) == 3:
				has_pressure = False


			if '*END*' in line:  # Get end of header.
				skiprows = k + 3

			if (k > skiprows) and (skiprows != ''):
				if has_pressure: 
					temp[k - skiprows] = np.float(line.strip().split(',')[0].strip())
					depth[k - skiprows] = np.float(line.strip().split(',')[1].strip())
					date = line.strip().split(',')[2].strip()

					if kwargs['truncate_seconds']:
						t = datetime.datetime.strptime(date + ' ' + line.strip().split(',')[3].strip(),"%d %b %Y %H:%M:%S")
						time[k - skiprows] = t - datetime.timedelta(seconds=t.second)
					else:
						time[k - skiprows] = datetime.datetime.strptime(date + ' ' + line.strip().split(',')[3].strip(),"%d %b %Y %H:%M:%S")

				elif not has_pressure: 
					temp[k - skiprows] = np.float(line.strip().split(',')[0].strip())
					depth[k - skiprows] = -9999.
					date = line.strip().split(',')[1].strip()

					if kwargs['truncate_seconds']:
						t = datetime.datetime.strptime(date + ' ' + line.strip().split(',')[2].strip(),"%d %b %Y %H:%M:%S")
						time[k - skiprows] = t - datetime.timedelta(seconds=t.second)
					else:
						time[k - skiprows] = datetime.datetime.strptime(date + ' ' + line.strip().split(',')[2].strip(),"%d %b %Y %H:%M:%S")


		return ({'time':time, 'Temperature':temp, 'Pressure':depth})

class sbe56(object):
	r""" Seabird 56 Temperature probe

	Data is output via a usb connection into an .xml format which can then be converted to a .csv for 
	ingestion and processing"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())


	@staticmethod	
	def parse(fobj, filetype='csv', **kwargs):
		r"""
		Basic Method to open and read sbe56 csv files or sbe56 cnv files
		"""



		if filetype == 'csv':

			temp,time = {},{}
			skiprows = ''
			for k, line in enumerate(fobj.readlines()):
				line = line.strip()

				if line == '"Date","Time","Temperature"':  # Get end of header.
					skiprows = k

				if (k > skiprows) and (skiprows != ''):

					temp[k - skiprows] = np.float(line.strip().split(',')[2].strip('"'))
					date = line.strip().split(',')[0].strip('"')
				if kwargs['roundTime']:
					time[k - skiprows] = roundTime(datetime.datetime.strptime(date + ' ' + line.strip().split(',')[1].strip('"'),'%Y-%m-%d %H:%M:%S'))
				else:
					time[k - skiprows] = datetime.datetime.strptime(date + ' ' + line.strip().split(',')[1].strip('"'),'%Y-%m-%d %H:%M:%S')
					
			print ("Read in {0} lines of the file").format(k)

			return ({'time':time, 'temperature':temp})

		elif filetype == 'cnv':

			endheaderrows = ''
			var_names = {}
			data = {}

			for k, line in enumerate(fobj.readlines()):
				line = line.strip()

				if '# name' in line:
					var_names[int(line.split('=')[0].split()[-1])] = line.split('=')[1].split()[0]
				if '# start_time' in line:
					start_time = line.split('[')[0].split('=')[-1].strip()
				if line == '*END*':  # Get end of header.
					endheaderrows = k

				if (k > endheaderrows) and (endheaderrows != ''):
					data[k-endheaderrows-1] = line.split()

			#
			(k, var_id, sbe16data) = (k-endheaderrows-1, var_names, data)

			### cycle through variable names in header to retrieve which column they are in for ingest
			temp = {}
			print ("Variables in SBE file are {0}").format(" ".join(var_id.values()))
			for var_index in sorted(var_id.keys()):
				if (var_id[var_index] == 'tv290C:') or (var_id[var_index] == 't090C:'):
					print "Processing {0}".format(var_id[var_index])
					for k,v in sbe16data.items():
						temp[k] = float(v[var_index])   
				elif var_id[var_index] == 'timeJ:': # timeJV2 for julian days
					print "Processing {0}".format(var_id[var_index])
					time_instrument_doy = {}
					for k,v in sbe16data.items():
						time_instrument_doy[k] = float(v[var_index])

			print "Converting instrument time in fractional_doy to python datetime object"
			time = {}
			for k,v in time_instrument_doy.items():
				time[k] = datetime.datetime(datetime.datetime.strptime(start_time, '%b %d %Y %H:%M:%S').year,1,1) + datetime.timedelta(v -1)

				if kwargs['roundTime']:
					time[k] = roundTime(datetime.datetime(datetime.datetime.strptime(start_time, '%b %d %Y %H:%M:%S').year,1,1) + datetime.timedelta(v -1))
				else:
					time[k] = datetime.datetime(datetime.datetime.strptime(start_time, '%b %d %Y %H:%M:%S').year,1,1) + datetime.timedelta(v -1)
					
			return ({'time':time, 'temperature':temp})

class rcmsg(object):
	r""" Anderaa Seaguard instruments"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, turbidity=False, pressure=False):
		r"""
		Basic Method to open and read seaguard csv files - depends on pandas

		Second row has variables to be used as header and variable names

		Oxygen should be corrected for salinity values
		"""
		rawdata = pd.read_csv(fobj, header=1, delimiter='\t')        
		rawdata['Time tag (Gmt)']=pd.to_datetime(rawdata['Time tag (Gmt)'],format='%d.%m.%y %H:%M:%S')
		time = { k:v.to_pydatetime() for k,v in (rawdata['Time tag (Gmt)'].to_dict(into=OrderedDict)).iteritems() }

		if turbidity and pressure:
			return({'time':time, 'Temperature':rawdata['Temperature'].to_dict(into=OrderedDict),
				'Pressure':rawdata['Pressure'].to_dict(into=OrderedDict),
				'East':rawdata['East'].to_dict(into=OrderedDict), 'North':rawdata['North'].to_dict(into=OrderedDict),
				'Turbidity':rawdata['Turbidity'].to_dict(into=OrderedDict),
				'O2Concentration':rawdata['O2Concentration'].to_dict(into=OrderedDict),
				'AirSaturation':rawdata['AirSaturation'].to_dict(into=OrderedDict)})
		elif (not turbidity) and pressure:
			return({'time':time, 'Temperature':rawdata['Temperature'].to_dict(into=OrderedDict),
				'Pressure':rawdata['Pressure'].to_dict(into=OrderedDict),
				'East':rawdata['East'].to_dict(into=OrderedDict), 'North':rawdata['North'].to_dict(into=OrderedDict),
				'O2Concentration':rawdata['O2Concentration'].to_dict(into=OrderedDict),
				'AirSaturation':rawdata['AirSaturation'].to_dict(into=OrderedDict)})
		elif turbidity and (not pressure):
			return({'time':time, 'Temperature':rawdata['Temperature'].to_dict(into=OrderedDict),
				'Turbidity':rawdata['Turbidity'].to_dict(into=OrderedDict),
				'East':rawdata['East'].to_dict(into=OrderedDict), 'North':rawdata['North'].to_dict(into=OrderedDict),
				'O2Concentration':rawdata['O2Concentration'].to_dict(into=OrderedDict),
				'AirSaturation':rawdata['AirSaturation'].to_dict(into=OrderedDict)})
		else:
			return({'time':time, 'Temperature':rawdata['Temperature'].to_dict(into=OrderedDict),
				'East':rawdata['East'].to_dict(into=OrderedDict), 'North':rawdata['North'].to_dict(into=OrderedDict),
				'O2Concentration':rawdata['O2Concentration'].to_dict(into=OrderedDict),
				'AirSaturation':rawdata['AirSaturation'].to_dict(into=OrderedDict)})

class rcm(object):
	r""" Anderaa instruments (RCM 4, 7, 9, 11's
	EcoFOCI QC procedure developed by Dave P. and done within excel spreadsheet

	This should be a replacement of the original rcm mooring analyis software"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())


	@staticmethod	
	def parse(fobj, subsampleint_str='10T', sampleint_str='1H', truncate_time=True, interpolate_time=False):
		r"""
		Basic Method to open and read rcm excel files
		"""

		rawdata = pd.read_excel(fobj, 
			  skiprows=4,
			  parse_dates=['date/time'], 
			  index_col='date/time')
		rawdata.rename_axis('date_time', inplace=True)

		if truncate_time:
			rs_data = rawdata.resample(sampleint_str).mean()
		if interpolate_time:
			rs_data = rawdata.resample(subsampleint_str).mean().interpolate(method='time').resample(sampleint_str).median()

		rs_data['date_time'] = rs_data.index
		time = OrderedDict( (k,v.to_pydatetime()) for k,v in (rs_data['date_time'].to_dict(into=OrderedDict)).iteritems() )

		return({'time':time, 'Temperature':rs_data['temperature'].to_dict(into=OrderedDict),
			'Salinity':rs_data['salinity'].to_dict(into=OrderedDict),
			'Pressure':rs_data['pressure'].to_dict(into=OrderedDict),
			'East':rs_data['east true'].to_dict(into=OrderedDict), 'North':rs_data['north true'].to_dict(into=OrderedDict),
			'Turbidity':rs_data['turbidity'].to_dict(into=OrderedDict),
			'O2Concentration':rs_data['o2concentration'].to_dict(into=OrderedDict),
			'AirSaturation':rs_data['o2saturation'].to_dict(into=OrderedDict)})

class wpak(object):
	r""" MetOcean WeatherPak"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, argos_file=False):
		r"""
		Basic Method to open and read wpak csv files 

		Alternatively we can pass ARGOS retrieved data in 
		"""

		rawdata = pd.read_csv(fobj, header=0, delimiter='\s+')
		rawdata['date_time'] = pd.to_datetime(rawdata['DATE']+' '+rawdata['TIME'], format="%y/%m/%d %H:%M:%S")

		time = { k:v.to_pydatetime() for k,v in (rawdata['date_time'].to_dict(into=OrderedDict)).iteritems() }

		if not argos_file:
			return({'time':time, 'TA':rawdata['TA'].to_dict(into=OrderedDict),
				'BP':rawdata['BP'].to_dict(into=OrderedDict), 'BT':rawdata['BT'].to_dict(into=OrderedDict),
				'TI':rawdata['TI'].to_dict(into=OrderedDict), 'RH':rawdata['RH'].to_dict(into=OrderedDict),
				'WS':rawdata['WS'].to_dict(into=OrderedDict), 'WD':rawdata['WD'].to_dict(into=OrderedDict),
				'SR':rawdata['SR'].to_dict(into=OrderedDict), 'AZ':rawdata['AZ'].to_dict(into=OrderedDict),
				'WT':rawdata['WT'].to_dict(into=OrderedDict), 'WC':rawdata['WC'].to_dict(into=OrderedDict),
				'WT_conv':rawdata['WT_conv'].to_dict(into=OrderedDict), 'WC_conv':rawdata['WC_conv'].to_dict(into=OrderedDict)})

class ecoflsb(object):
	r""" Wetlabs ecofluorometer"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, add_seconds=0, ave_scheme='median', scale_factor=0, dark_count=0, hourly_interp=True, verbose=False):
		r"""
		Basic Method to open and read wetlabs eco-fluorometer csv files

		expects only fluorometer counts - use eco_flntu, eco_cdom or eco_triplet for other combos
		"""

		print add_seconds

		counts_ave,counts_std,time_ave = {},{},{}

		#### data readin
		skiprows = -2
		index = 0
		new_data = True
		time_threshold = datetime.timedelta(seconds=60)

		for k, line in enumerate(fobj.readlines()):

			line = line.strip()

			if ('records to read' in line):  # Get end of header.
				skiprows = k

			if ('etx' in line):  # Get end of file.
				continue

			if verbose:
				if k%1000 == 0:
					print "Reading Record Line {l}".format(l=k)

			#once data is read from file, it needs to be averaged.  
			#There are n associated measurements every hour (usually between 5-10)
			#fls: date, time, wavelength, counts, thermistor
				
			if (k == skiprows+1) or (new_data == True): #intial data 
				line_array = line.strip().split()
				if len( line_array ) == 5: 
					date = line_array[0]+ ' '
					time = line_array[1]
					dtime = datetime.datetime.strptime(date+time,'%m/%d/%y %H:%M:%S' )

					counts = np.int(line_array[3])

					prev_time = dtime
					new_data = False

			if (k > skiprows+1) and (new_data == False):
				line_array = line.strip().split()

				if len( line_array ) == 5: 	                
					date = line_array[0]+ ' '
					time = line_array[1]
					sample_time = datetime.datetime.strptime(date+time,'%m/%d/%y %H:%M:%S' )
					if (sample_time - prev_time) > time_threshold: #average and start again
						if ave_scheme == 'mean':
							counts_ave[index] = counts.mean()
							counts_std[index] = counts.std()
						elif ave_scheme == 'median':
							counts_ave[index] = np.median(counts)
							counts_std[index] = counts.std()
						tref = datetime.datetime(2000,1,1)

						time_ave[index] = (np.sum([(x-tref) for x in dtime])/len(dtime))+tref
						index += 1
						new_data = True
					dtime = np.vstack((dtime,dtime,sample_time))

					counts = np.vstack((counts,np.int(line_array[3])))

		chlor = scale_factor * (np.array(counts_ave.values()) - dark_count)

		#(max time - min time) / add_seconds
		date_diff = np.max(time_ave.values()) - np.min(time_ave.values()) 
		add_delta_seconds = float(add_seconds) / ((date_diff.days * 24.*60.*60.)+date_diff.seconds) 
		time_orig = np.min(time_ave.values())
		time_corr = {k:linear_clock_adjust(time_orig, v, add_delta_seconds) for k,v in time_ave.iteritems()}

		if hourly_interp:
			#put data on hourly grid
			min_t = min(time_corr.values())
			basedate = datetime.datetime( min_t.year , min_t.month , 
										  min_t.day, min_t.hour)
			rng = pd.date_range(basedate, max(time_corr.values()), freq='H').to_pydatetime()
			trng = {k:v for k,v in enumerate(rng)}
			data = {'counts':counts_ave.values(),'counts_std':counts_std.values(), 'chlor':chlor}
			data_interp = interp2hour(rng, time_corr.values(), data, vlist=['counts','counts_std','chlor'])
			
			return ({'time':trng, 'counts':data_interp['counts'],
					 'counts_std':data_interp['counts_std'], 
					 'chlor':data_interp['chlor']})

		else:			

			return ({'time':time_corr, 'counts':counts_ave.values(),
					 'counts_std':counts_std.values(), 'chlor':chlor})

class ecoflntu(object):
	r""" Wetlabs ecofluorometer with ntu channel"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, add_seconds=0, ave_scheme='median', scale_factor=0, dark_count=0, hourly_interp=True, verbose=False):
		r"""
		Basic Method to open and read wetlabs eco-fluorometer csv files with ntu channel
		"""

		print add_seconds

		ntu_counts_ave,nut_counts_std,counts_ave,counts_std,time_ave = {},{},{},{},{}

		#### data readin
		skiprows = -2
		index = 0
		new_data = True
		time_threshold = datetime.timedelta(seconds=60)

		for k, line in enumerate(fobj.readlines()):

			line = line.strip()

			if ('records to read' in line):  # Get end of header.
				skiprows = k

			if ('etx' in line):  # Get end of file.
				continue

			if verbose:
				if k%1000 == 0:
					print "Reading NTU Record Line {l}".format(l=k)

			#once data is read from file, it needs to be averaged.  
			#There are n associated measurements every hour (usually between 5-10)
			#fls: date, time, wavelength, counts, wavelength, counts,thermistor
			
			if (k == skiprows+1) or (new_data == True): #intial data 
				line_array = line.strip().split()
				if len( line_array ) == 7: 
					date = line_array[0]+ ' '
					time = line_array[1]
					dtime = datetime.datetime.strptime(date+time,'%m/%d/%y %H:%M:%S' )

					counts = np.int(line_array[3])

					prev_time = dtime
					new_data = False

			if (k > skiprows+1) and (new_data == False):
				line_array = line.strip().split()

				if len( line_array ) == 7: 	                
					date = line_array[0]+ ' '
					time = line_array[1]
					sample_time = datetime.datetime.strptime(date+time,'%m/%d/%y %H:%M:%S' )
					if (sample_time - prev_time) > time_threshold: #average and start again
						if ave_scheme == 'mean':
							counts_ave[index] = counts.mean()
							counts_std[index] = counts.std()
						elif ave_scheme == 'median':
							counts_ave[index] = np.median(counts)
							counts_std[index] = counts.std()
						tref = datetime.datetime(2000,1,1)

						time_ave[index] = (np.sum([(x-tref) for x in dtime])/len(dtime))+tref
						index += 1
						new_data = True
					dtime = np.vstack((dtime,dtime,sample_time))

					counts = np.vstack((counts,np.int(line_array[3])))

		chlor = scale_factor * (np.array(counts_ave.values()) - dark_count)

		#(max time - min time) / add_seconds
		date_diff = np.max(time_ave.values()) - np.min(time_ave.values()) 
		add_delta_seconds = float(add_seconds) / ((date_diff.days * 24.*60.*60.)+date_diff.seconds) 
		time_orig = np.min(time_ave.values())
		time_corr = {k:linear_clock_adjust(time_orig, v, add_delta_seconds) for k,v in time_ave.iteritems()}

		if hourly_interp:
			#put data on hourly grid
			min_t = min(time_corr.values())
			basedate = datetime.datetime( min_t.year , min_t.month , 
										  min_t.day, min_t.hour)
			rng = pd.date_range(basedate, max(time_corr.values()), freq='H').to_pydatetime()
			trng = {k:v for k,v in enumerate(rng)}
			data = {'counts':counts_ave.values(),'counts_std':counts_std.values(), 'chlor':chlor}
			data_interp = interp2hour(rng, time_corr.values(), data, vlist=['counts','counts_std','chlor'])
			
			return ({'time':trng, 'counts':data_interp['counts'],
					 'counts_std':data_interp['counts_std'], 
					 'chlor':data_interp['chlor']})

		else:			

			return ({'time':time_corr, 'counts':counts_ave.values(),
					 'counts_std':counts_std.values(), 'chlor':chlor})

class adcp(object):
	r""" ADCP"""

class adcp_ice(object):
	r""" Teledynde ADCP Bottom tracking (ICE)"""

	@staticmethod
	def get_data(filename=None, MooringID=None, **kwargs):
		r"""
		Basic Method to open files.  Specific actions can be passes as kwargs for instruments
		"""

		fobj = open(filename)
		data = fobj.read()


		buf = data
		return BytesIO(buf.strip())

	@staticmethod	
	def parse(fobj, **kwargs):
		r"""

		adcp bottom tracking readin
		Num,Year,Month,Day,Hour,Min,Sec,BTVelEast,BTVelNorth,BTVelUp,BTVelErr,AvgBeamDepth,BTSpeed,BTDirection
		"""

		rawdata = pd.read_csv(fobj, dtype=str)
		rawdata['date_time'] = pd.to_datetime(rawdata['Year']+'/'+rawdata['Month']+'/'+rawdata['Day']+' '+\
			rawdata['Hour']+':'+rawdata['Min']+':'+rawdata['Sec'], format="%Y/%m/%d %H:%M:%S")

		

		if kwargs['roundTime']:
			time = { k:roundTime(v.to_pydatetime(),3600) for k,v in (rawdata['date_time'].to_dict(into=OrderedDict)).iteritems() }
						
			return({'time':time, 'U':rawdata['BTVelEast'].to_dict(into=OrderedDict),
				'V':rawdata['BTVelNorth'].to_dict(into=OrderedDict), 'W':rawdata['BTVelUp'].to_dict(into=OrderedDict),
				'Werr':rawdata['BTVelErr'].to_dict(into=OrderedDict), 'Spd':rawdata['BTSpeed'].to_dict(into=OrderedDict),
				'Dir':rawdata['BTDirection'].to_dict(into=OrderedDict)})

		else:
			time = { k:v.to_pydatetime() for k,v in (rawdata['date_time'].to_dict(into=OrderedDict)).iteritems() }
			return({'time':time, 'U':rawdata['BTVelEast'].to_dict(into=OrderedDict),
				'V':rawdata['BTVelNorth'].to_dict(into=OrderedDict), 'W':rawdata['BTVelUp'].to_dict(into=OrderedDict),
				'Werr':rawdata['BTVelErr'].to_dict(into=OrderedDict), 'Spd':rawdata['BTSpeed'].to_dict(into=OrderedDict),
				'Dir':rawdata['BTDirection'].to_dict(into=OrderedDict)})