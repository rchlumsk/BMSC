#########################################################################                                  
:FileType          rvi ASCII Raven rev217 (v2.9)                                                                             
:WrittenBy         James Craig, Juliane Mai and Robert Chlumsky                                                                      
:CreationDate      June 2020
#
# RAVEN run of WSC/USGS {props[id]} ({props[name]}) using weighted model options                                                    
#------------------------------------------------------------------------
#
:StartDate               1970-01-01 00:00:00 # 1954-01-01 00:00:00 
:EndDate                 1989-12-31 00:00:00  
# :EvaluationTime          1991-01-01 00:00:00                                                        
# :Duration              20819                                                                                   
:TimeStep                1.0                                                                                   
:Method                  ORDERED_SERIES 

:PotentialMeltMethod     POTMELT_HMETS
:RainSnowFraction        RAINSNOW_HBV
# :RainSnowFraction        RAINSNOW_DATA
:SWRadiationMethod       SW_RAD_NONE         # no radiation is faster
:Evaporation             PET_DATA
:CatchmentRoute          ROUTE_DUMP
:Routing                 ROUTE_NONE 
:SoilModel               SOIL_MULTILAYER 2

:Alias DELAYED_RUNOFF CONVOLUTION[1] 

:HydrologicProcesses
  :Precipitation   RAVEN_DEFAULT                         ATMOS_PRECIP   MULTIPLE 
  :ProcessGroup #infiltration group
                :Infiltration    INF_HMETS               PONDED_WATER   MULTIPLE 
                :Infiltration    INF_VIC_ARNO            PONDED_WATER   MULTIPLE 
                :Infiltration    INF_HBV                 PONDED_WATER   MULTIPLE 
  :EndProcessGroup CALCULATE_WTS par_x36 par_x37
                  :Overflow      OVERFLOW_RAVEN          SOIL[0]        DELAYED_RUNOFF
  :ProcessGroup #quickflow group
                :Baseflow        BASE_LINEAR_ANALYTIC    SOIL[0]        SURFACE_WATER   # interflow, really
                :Baseflow        BASE_VIC                SOIL[0]        SURFACE_WATER
                :Baseflow        BASE_TOPMODEL           SOIL[0]        SURFACE_WATER
  :EndProcessGroup CALCULATE_WTS par_x38 par_x39
  :Percolation                   PERC_LINEAR             SOIL[0]        SOIL[1]         # recharge
    :Overflow                    OVERFLOW_RAVEN          SOIL[1]        DELAYED_RUNOFF
  :ProcessGroup #evaporation group
                :SoilEvaporation SOILEVAP_ALL            SOIL[0]        ATMOSPHERE      # AET
                :SoilEvaporation SOILEVAP_TOPMODEL       SOIL[0]        ATMOSPHERE      # AET
  :EndProcessGroup CALCULATE_WTS  par_x40
  :Convolve                      CONVOL_GAMMA            CONVOLUTION[0] SURFACE_WATER   # 'surface runoff'
  :Convolve                      CONVOL_GAMMA_2          DELAYED_RUNOFF SURFACE_WATER   # 'delayed runoff'
  :ProcessGroup #quickflow group
                :Baseflow        BASE_LINEAR_ANALYTIC    SOIL[1]        SURFACE_WATER
                :Baseflow        BASE_POWER_LAW          SOIL[1]        SURFACE_WATER
  :EndProcessGroup CALCULATE_WTS  par_x41
  :ProcessGroup #snow balance group
                :SnowBalance     SNOBAL_HMETS            MULTIPLE       MULTIPLE
                :SnowBalance     SNOBAL_SIMPLE_MELT      SNOW           PONDED_WATER
                :SnowBalance     SNOBAL_HBV              MULTIPLE       MULTIPLE
                #:SnowBalance     SNOBAL_GAWSER           MULTIPLE       MULTIPLE
  :EndProcessGroup CALCULATE_WTS par_x42 par_x43
:EndHydrologicProcesses
#---------------------------------------------------------
# Output Options
#

:EvaluationMetrics NASH_SUTCLIFFE
:SilentMode
# :SuppressOutput
:DontWriteWatershedStorage
