
### writes the template files (.tpl) to main folder
## also writes rvt and rvh to model folder

## read in information ----
arrayid <- as.numeric(read.csv("array_id.txt", header=F)[1])
catchid <- as.numeric(read.csv("catch_id.txt", header=F)[1])
basin_chars <- read.table("basin_physical_characteristics.txt", sep=";", header=T)

### Write rvi.tpl file ----
ffbase <- "../basetemplates/modelname.rvi.tpl"
basefile <- readLines(ffbase)

basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                 replacement=sprintf("%08d",basin_chars$basin_id[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                 replacement=as.character(basin_chars$basin_name[catchid]),
                 fixed=T)

ffwrite <- "modelname.rvi.tpl"
fw <- file(ffwrite,"w+")
writeLines(basefile,fw)
close(fw)

### Write rvc.tpl file ----
ffbase <- "../basetemplates/modelname.rvc.tpl"
basefile <- readLines(ffbase)

basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                 replacement=sprintf("%08d",basin_chars$basin_id[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                 replacement=as.character(basin_chars$basin_name[catchid]),
                 fixed=T)

ffwrite <- "modelname.rvc.tpl"
fw <- file(ffwrite,"w+")
writeLines(basefile,fw)
close(fw)

### Write rvp.tpl file ----
ffbase <- "../basetemplates/modelname.rvp.tpl"
basefile <- readLines(ffbase)

basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                 replacement=sprintf("%08d",basin_chars$basin_id[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                 replacement=as.character(basin_chars$basin_name[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[forest_frac]}"), 
                 replacement=as.character(basin_chars$forest_frac[catchid]),
                 fixed=T)

ffwrite <- "modelname.rvp.tpl"
fw <- file(ffwrite,"w+")
writeLines(basefile,fw)
close(fw)


### Write rvt.tpl file ----
ffbase <- "../basetemplates/modelname.rvt.tpl"
basefile <- readLines(ffbase)

basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                 replacement=sprintf("%08d",basin_chars$basin_id[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                 replacement=as.character(basin_chars$basin_name[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[lat_deg]}"), 
                 replacement=as.character(basin_chars$lat[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[lon_deg]}"), 
                 replacement=as.character(basin_chars$lon[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[elevation_m]}"), 
                 replacement=as.character(basin_chars$elevation_m[catchid]),
                 fixed=T)

ffwrite <- "modelname.rvt.tpl"
fw <- file(ffwrite,"w+")
writeLines(basefile,fw)
close(fw)

### Write rvh file ----
ffbase <- "../basetemplates/modelname.rvh.tpl"
basefile <- readLines(ffbase)

basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                 replacement=sprintf("%08d",basin_chars$basin_id[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                 replacement=as.character(basin_chars$basin_name[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[lat_deg]}"), 
                 replacement=as.character(basin_chars$lat[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[lon_deg]}"), 
                 replacement=as.character(basin_chars$lon[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[elevation_m]}"), 
                 replacement=as.character(basin_chars$elevation_m[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[area_km2]}"), 
                 replacement=as.character(basin_chars$area_km2[catchid]),
                 fixed=T)
basefile <- gsub(x=basefile, pattern=as.character("{props[slope_deg]}"), 
                 replacement=as.character(basin_chars$slope_deg[catchid]),
                 fixed=T)

ffwrite <- "model/modelname.rvh"
fw <- file(ffwrite,"w+")
writeLines(basefile,fw)
close(fw)

### Copy relevent data_obs
system(sprintf("cp ../data_obs/General-ObsWeights_Qdaily.rvt model/data_obs/."))
system(sprintf("cp -rp ../data_obs/%08d* model/data_obs/.",basin_chars$basin_id[catchid]))

### Copy other data
system("cp ../run_mode.txt .")

### finished message ----
print("Rscript aa_write_input_files_01.R run")
