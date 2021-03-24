
## Script used to read in previous model results, and process the WMA model
## Done after the aa_postprocess_models.R script
## file/folder names may need to be adjusted based on the file names in scripts

options(stringsAsFactors = F)

fnse <- function(sim,obs) {
  if (length(sim) ==0 ) { return(NA) }
  return( 1 - sum((sim-obs)^2)/sum((obs-mean(obs))^2) )
}

frmse <- function(sim,obs) {
  if (length(sim) ==0 ) { return(NA) }
  return(sqrt(sum( (sim-obs)^2 / length(sim)  )))
}


for (i in 1:20) { # arrayid
  for (k in 1:12){ # catchid
    
    setwd(sprintf("calibration_%02d_%03d",k,i))
    
    arrayid <- i
    catchid <- k
    
    print("Step 2")
    
    ## read in the relevant calibration NSE scores of each fixed model
    
    nse_scores <- read.csv(sprintf("../results/results_metrics_10k_calibration_%02d_%03d_20210324.csv",
                                   k,i))[1:108,]
    
    ## calculate weights
    
    nse_scores$modNSE <- nse_scores$calibNSE-0.5
    nse_scores$modNSE[nse_scores$modNSE < 0] <- 0
    nse_scores$ww <- nse_scores$modNSE/sum(nse_scores$modNSE)
    
    print("Step 3")
    
    ## calculate average model 112 ----
    #
    mm <- data.frame(matrix(NA,nrow=7305,ncol=108))
    
    for (j in 1:108) {
      # print(j) 
      dd_calib <- sprintf("calib_runs/best_%i",j)
      
      if (file.exists(sprintf("%s/Hydrographs.csv",dd_calib))) {
        tt <- read.csv(sprintf("%s/Hydrographs.csv",dd_calib),
                       header=T)
        mm[,j] <- tt[,5]
        
      } else {
        print(sprintf("file %s does not exist", sprintf("%s/output/Hydrographs.csv",dd_calib)))
      }
    }
    
    print("Step 4")
    
    # avgmodel_old <- round(apply(mm,1,mean,na.rm=T),3)
    avgmodel <- round(apply(mm,1,weighted.mean,w=nse_scores$ww,na.rm=T),3)
    
    
    ## write out average model to folder 112 ----
    #
    dd_calib <- sprintf("calib_runs/best_%i",112)
    
    if (!dir.exists(dd_calib)) {
      dir.create(dd_calib)
    }

    # read in first Hydrograph to get template
    cc <- read.csv("calib_runs/best_1/Hydrographs.csv")
    cc[,5] <- avgmodel
    write.csv(cc, sprintf("%s/Hydrographs.csv",dd_calib),
              quote=F, row.names = F)
    
    ## calculate metrics ----
    #
    number_models <- 112
    
    tbl <- as.data.frame(matrix(NA,nrow=number_models,ncol=4))
    colnames(tbl) <- c("calibNSE","validNSE","calibRMSE","validRMSE")
    
    for (j in 1:number_models) {
      dd_calib <- sprintf("calib_runs/best_%i",j)
      
      if (file.exists(sprintf("%s/Hydrographs.csv",dd_calib))) {
        tt <- read.csv(sprintf("%s/Hydrographs.csv",dd_calib),
                       header=T)
        
        tt$ddate <- as.Date(tt$date)
        tt_calib <- tt[ which(tt$ddate >= as.Date("1972-01-01") & tt$ddate <= as.Date("1983-12-31")), ]
        tt_valid <- tt[ which(tt$ddate >= as.Date("1984-01-01") & tt$ddate <= as.Date("1989-12-31")), ]
        
        tbl[j,1] <- fnse(sim=tt_calib[,5], obs=tt_calib[,6])
        tbl[j,2] <- fnse(sim=tt_valid[,5], obs=tt_valid[,6])
        tbl[j,3] <- frmse(sim=tt_calib[,5], obs=tt_calib[,6])
        tbl[j,4] <- frmse(sim=tt_valid[,5], obs=tt_valid[,6])
        
      } else {
        write.table(sprintf("file %s does not exist", sprintf("%s/Hydrographs.csv",dd_calib)),
                    file="run_logfile.txt",
                    append=TRUE,quote=F,
                    col.names=F, row.names=F)
      }
    }
    
    # if (!(dir.exists("../results_20210317/"))) {
    #   dir.create("../results_20210317/")
    # }
    
    write.csv(tbl,
              sprintf("../results/results_metrics_10k_calibration_%02d_%03d_20210324.csv",
                      catchid,arrayid),
              quote=F, row.names = T)
    
    
    setwd("..")
  }
}
