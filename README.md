# EcoFOCI_MooringAnalysis
EcoFOCI timeseries processing tools


### Convert raw instrument retrieved data files to initial archive netcdf files

	python EcoFOCIraw2nc.py -h

	`Convert raw data from variety of instruments to netcdf archive format
	
	positional arguments:
	  DataFile              full path to data file
	  OutDataFile           full path to output data file
	  InstType              Instrument Type - run program with -ih flag to get
	                        list
	  InstDepth             Nominal Instrument Depth

	optional arguments:
	  -h, --help            show this help message and exit
	  -ih, --InstTypeHelp   Instrument Type - run program with -ih flag to get
	                        list
	  -conv CONVENTION, --convention CONVENTION
	  						EPIC or CF/COARDS format (defaults to epic)
	  -dec DECLINATION DECLINATION, --declination DECLINATION DECLINATION
	                        magnetic declination correction [lat.dd lon.dd] +N,+W
	  -kw KEYWORDARGS [KEYWORDARGS ...], --keywordargs KEYWORDARGS [KEYWORDARGS ...]
	                        instrument dependent kword args - see readme for help
	  -latlon LATLON [LATLON ...], --latlon LATLON [LATLON ...]
	                        add to output file variables [lat mm.mm lon mm.mm]
	                        +N,+W
	  -add_meta ADD_META ADD_META ADD_META, --add_meta ADD_META ADD_META ADD_META
	                        MooringID serial_no water_depth`

	Instrument Dependent KEYWORDARGS: (replace the variable name after -kw with desired value)
		mtr : -kw clock_corr coef1 coef2 coef3 10min_interp (clock_corr - time to add to ecf clock in seconds, 10min_interp - True/False)
		
		prawler : -kw interp_time pressure_grid_interp (eg True True - actual values are hardcoded to hourly and 0.5m grid) 
		
		rcm_sg : -kw turbidity pressure (eg true if sensor is attached)

		rcm_sg : -kw truncate_time (True/False) interpolate_time (true/false)
		
		sbe16 : -kw clock_corr time_stamp (time_elapsed_s, time_instrument_s, time_instrument_doy), hourly_interp (True/False)

		sbe37/sbe39 : -kw truncate_seconds (true / false - true if truncated and truncates down to nearest minute)
		
		sbe56 : -kw roundTime (true / false - rounds time to nearest minute) filetype (csv / cnv - type of exported file)
		
		ecf : -kw clock_corr ave_scheme scale_factor dark_count hourly_interp (clock_corr - time to add to ecf clock in seconds , ave_scheme - median / mean, cal scale factor, cal dark count , hourly_interp - True/False) 

		wpak : -kw argos (true/false) 

		adcp_ice: -kw roundTime (roundTime - True/False rounds to nearest hour) 
	`

###

	python NetCDF_Time_Tools.py -h

	`Interpolate or adjust times

	positional arguments:
	  sourcefile            complete path to epic file
	  operation             CF_Convert, RoundUp to nearest hour, RoundDown to
	                        nearest hour, Interpolate to nearest hour

	optional arguments:
	  -h, --help            show this help message and exit

	CF_Convert optional arguments
	  --time_since_str TIME_SINCE_STR [TIME_SINCE_STR ...]
	                        cf compliant time since str (eg. "days since
	                        1800-01-01"
	  -is2D, --is2D         convert files like ADCP that have two varying
	                        dimensions
	`


config file examples can be found in the repository - EcoFOCI_FieldOps_Documentation

-----

################

Legal Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration (NOAA), or the United States Department of Commerce (DOC). All NOAA GitHub project code is provided on an 'as is' basis and the user assumes responsibility for its use. Any claims against the DOC or DOC bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation, or favoring by the DOC. The DOC seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by the DOC or the United States Government.