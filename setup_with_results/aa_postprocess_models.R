
# library(magrittr)

options(stringsAsFactors = F)

### set array number ----
# note that this needs to be consistent with that in the sub_array_run.sh file
# number_arrays <- 20
# number_models <- 109
# number_models <- 3

for (i in 1:20) { # arrayid
  for (k in 1:12){ # catchid
    
    setwd(sprintf("calibration_%02d_%03d",k,i))
    
    arrayid <- i
    catchid <- k

    ## run Raven to get Hydrographs ----
    #
    for (j in 1:number_models) {
      
      dd_calib <- sprintf("calib_runs_%02d_%03d/modelrun_%04d/best",k,i,j)
      dd_model <- sprintf("../model_%02d_%03d",k,i)
      
      system2(command=sprintf("./%s/Raven.exe",dd_model),
              args=sprintf("%s/08KC001 -o %s/output/ -h %s/08KC001.rvh -t %s/08KC001.rvt",
                           dd_calib, dd_calib, dd_model, dd_model))
      
      system(sprintf("rm %s/output/Diagnostics.csv",dd_calib))
      system(sprintf("rm %s/output/solution.rvc",dd_calib))
      system(sprintf("rm %s/output/WatershedStorage.csv",dd_calib))
      system(sprintf("rm %s/output/Raven_errors.txt",dd_calib))
      
    }
    
    ## calculate average model 110 (SMA) ----
    #
    
    mm <- data.frame(matrix(NA,nrow=7305,ncol=number_models))
        
    for (j in 1:number_models) {
      
      dd_calib <- sprintf("calib_runs_%02d_%03d/modelrun_%04d/best",k,i,j)
      
      if (file.exists(sprintf("%s/output/Hydrographs.csv",dd_calib))) {
        tt <- read.csv(sprintf("%s/output/Hydrographs.csv",dd_calib),
                       header=T)
        mm[,j] <- tt[,5]
        
      } else {
        print(sprintf("file %s does not exist", sprintf("%s/output/Hydrographs.csv",dd_calib)))
      }
    }
    
    avgmodel <- round(apply(mm,1,mean,na.rm=T),3)
    
    ## write out average model to folder 110 ----
    #
    dd_calib <- sprintf("calib_runs_%02d_%03d/modelrun_%04d",k,i,110)
    
    if (!dir.exists(dd_calib)) {
      dir.create(dd_calib)
    } 
    if (!dir.exists(sprintf("%s/best/",dd_calib))) {
      dir.create(sprintf("%s/best/",dd_calib))
    }
    if (!dir.exists(sprintf("%s/best/output/",dd_calib))) {
      dir.create(sprintf("%s/best/output/",dd_calib))
    }
    
    cc <- read.csv(sprintf("calib_runs_%02d_%03d/modelrun_0001/best/output/Hydrographs.csv",k,i))
    cc[,5] <- avgmodel
    write.csv(cc, sprintf("%s/best/output/Hydrographs.csv",dd_calib),
              quote=F, row.names = F)
    
    ## calculate metrics ----
    #
    number_models <- 110
    
    fnse <- function(sim,obs) {
      if (length(sim) ==0 ) { return(NA) }
      return( 1 - sum((sim-obs)^2)/sum((obs-mean(obs))^2) )
    }
    
    frmse <- function(sim,obs) {
      if (length(sim) ==0 ) { return(NA) }
      return(sqrt(sum( (sim-obs)^2 / length(sim)  )))
    }
    
    tbl <- as.data.frame(matrix(NA,nrow=number_models,ncol=4))
    colnames(tbl) <- c("calibNSE","validNSE","calibRMSE","validRMSE")
    
    for (j in 1:number_models) {
      dd_calib <- sprintf("calib_runs_%02d_%03d/modelrun_%04d/best",k,i,j)
      
      if (file.exists(sprintf("%s/output/Hydrographs.csv",dd_calib))) {
        tt <- read.csv(sprintf("%s/output/Hydrographs.csv",dd_calib),
                       header=T)
        
        tt$ddate <- as.Date(tt$date)
        tt_calib <- tt[ which(tt$ddate >= as.Date("1972-01-01") & tt$ddate <= as.Date("1983-12-31")), ]
        tt_valid <- tt[ which(tt$ddate >= as.Date("1984-01-01") & tt$ddate <= as.Date("1989-12-31")), ]
        
        tbl[j,1] <- fnse(sim=tt_calib[,5], obs=tt_calib[,6])
        tbl[j,2] <- fnse(sim=tt_valid[,5], obs=tt_valid[,6])
        tbl[j,3] <- fnse(sim=tt_calib[,5], obs=tt_calib[,6])
        tbl[j,4] <- fnse(sim=tt_valid[,5], obs=tt_valid[,6])
        
      } else {
        print(sprintf("file %s does not exist", sprintf("%s/output/Hydrographs.csv",dd_calib)))
      }
    }
    
    write.csv(tbl,
              sprintf("../results/results_metrics_10k_calibration_%02d_%03d_20210324.csv",k,i),
              quote=F, row.names = T)
  
  }
}

