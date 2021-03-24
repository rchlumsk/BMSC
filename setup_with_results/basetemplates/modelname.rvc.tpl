#########################################################################                                  
:FileType          rvc ASCII Raven rev217 (v2.9)                                                                             
:WrittenBy         James Craig, Juliane Mai and Robert Chlumsky                                                                      
:CreationDate      June 2020
#
# RAVEN run of WSC/USGS {props[id]} ({props[name]}) using weighted model options                                                              
#------------------------------------------------------------------------                                 
#

# tied parameters:
# (it is important for OSTRICH to find every parameter place holder somewhere in this file)
# (without this "par_x29" and "par_x30" wouldn't be detectable)
#    par_half_x29 = par_x29 * 1000. / 2. = {par[x29]} / 2. [m] = {dpar[half_x29]} [mm]
#    par_half_x30 = par_x30 * 1000. / 2. = {par[x30]} / 2. [m] = {dpar[half_x30]} [mm]

# initialize to 1/2 full
#:UniformInitialConditions SOIL[0] {dpar[half_x29]} # x(29)*1000/2 [mm]         
#:UniformInitialConditions SOIL[1] {dpar[half_x30]} # x(30)*1000/2 [mm]         

:HRUStateVariableTable # (formerly :IntialConditionsTable)
   :Attributes SOIL[0] SOIL[1]
   :Units mm mm
   1 par_half_x29 par_half_x30
#  1 {dpar[half_x29]} {dpar[half_x30]}
:EndHRUStateVariableTable
