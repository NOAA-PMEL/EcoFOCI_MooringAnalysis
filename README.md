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

-----

*** (truncate report)
`
.
├── Docs   
│   └── instrument_depth_config.readme   
├── EcoFOCI_config   
│   ├── db_config   
│	***   
│   ├── epickeys   
│	***   
│   ├── instr_config   
│	***   
│   ├── mooring_config   
│	***   
│   └── nc_edit_config   
│	***   
├── calc   
│   ├── geomag   
│	***   
│   ├── EPIC2Datetime.py   
│   ├── EPIC2Datetime.pyc   
│   ├── __init__.py   
│   └── __init__.pyc   
├── data   
│   ***   
├── examples   
├── images   
│   ***   
├── io_utils   
│   ├── ConfigParserLocal.py   
│   ├── ConfigParserLocal.pyc   
│   ├── EcoFOCI_db_io.py   
│   ├── EcoFOCI_db_io.pyc   
│   ├── EcoFOCI_netCDF_read.py   
│   ├── EcoFOCI_netCDF_read.pyc   
│   ├── EcoFOCI_netCDF_write.py   
│   ├── EcoFOCI_netCDF_write.pyc   
│   ├── __init__.py   
│   ├── __init__.pyc   
│   ├── grid_mooring2nc.py   
│   ├── instr_data_ingest.py   
│   └── instr_data_ingest.pyc   
├── plots   
│   ├── __init__.py   
│   ├── __init__.pyc   
│   ├── instrument_plot.py   
│   ├── instrument_plot.pyc   
│   └── ncgridded2image.py   
├── scripts   
│   ├── 2016   
│   └── BOEM   
├── EPIC_xlsx2nc.py   
├── EPIC_xlsx2nc_update.py   
├── EcoFOCIraw2nc.py   
├── NetCDF_2Dto1D.py   
├── NetCDF_UV2CSCD.py   
├── NetCDF_file_combine.py   
├── NetCDF_global_atts_editor.py   
├── NetCDF_variable_add.py   
├── NetCDF_variable_editor.py   
├── PlotMooringMultiInst.py   
├── Trim_netcdf.py   
├── __init__.py   
├── epic2cftime.py   
├── grid_mooring.py   
├── nc2csv.py   
├── timeseries_1varplot.py   
├── timeseries_2varplot.py   
└── timeseries_3varplot.py   
`