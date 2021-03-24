  
options(stringsAsFactors = F)

all_folders <- unlist(read.table("folder_list.txt"))

for (calib_folder in all_folders) {
  setwd(calib_folder)

  number_models <- 110
  arrayid <- as.numeric(read.csv("array_id.txt", header=F)[1])
  catchid <- as.numeric(read.csv("catch_id.txt", header=F)[1])
  
  # get folder name of parent folder for file naming
  kk <- unlist(strsplit(getwd(), "/"))
  kk <- kk[[length(kk)-1]]
  fldr_name <- paste0(unlist(strsplit(kk,"_"))[-1],collapse="_")
  
  ## get parameters for all 109 model runs
  j <- 109
  ff <- sprintf("calib_runs/best_%i/OstOutput0_%i.txt",109,109)
  pp <- read.table(ff, skip = 15)
  
  mm <- data.frame(matrix(NA,nrow=0,ncol=50))
  colnames(mm) <- pp[,1]
  
  for (j in 1:number_models) {
    ff <- sprintf("calib_runs/best_%i/OstOutput0_%i.txt",j,j)
    
    result = tryCatch({
      pp <- read.table(ff, skip = 15)
      pp1 <- data.frame(t(pp$V3))
      colnames(pp1) <- pp$V1
      
      mm[j, match(pp$V1, colnames(mm))] <- pp1[1,]
    }, error = function(err) {
      # 
      print(paste(sprintf("MY_ERROR in folder %s for model  %i:  ",calib_folder,j),err))
    }, finally = {
      # 
    })

  }
  
  if (!(dir.exists("../parameters/"))) {
    dir.create("../parameters/")
  }
  
  write.csv(mm,
            sprintf("../parameters/params_results_%s_calibration_%02d_%03d_20210324.csv",
                    fldr_name,
                    catchid,arrayid),
            quote=F, row.names = T)
  
  setwd("..")
}
