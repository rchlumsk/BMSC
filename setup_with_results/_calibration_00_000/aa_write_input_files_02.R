
### Program to write new ostIn file for i/108 model runs
## called within each new model structure update, i.e. 109 times within each array

# note that only base R is used here to avoid additional library installations on server

### Input Parameters ----

# change this in ../run_mode.txt
run_mode <- as.numeric(read.table("run_mode.txt"))
maxiterscheme <- c("Test","Test","N50",10000)[run_mode]

## write input program setup ----

## Local functions    
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
# substrLeft <- function(x, n){
#   substr(x, 1,n)
# }

# parameters tied to each process
options_paras_raven <- list(
  list(c(1,29),c(2,29),c(3,29)),                          # parameters of infiltration , 31, 32, XX                options     
  list(c(4,29),c(5,6,29),c(5,6,7,29)),                    # parameters of quickflow      33, 34, xx                options
  list(c(8,29),c(8,9,10,29)),                             # parameters of evaporation    35, xx                options
  list(c(11),c(11,12)),                                   # parameters of baseflow,      36, xx                     options
  list(c(13,14,15,16,17,18),c(NA),c(18,19)),              # parameters of snow balance,  37, 38, xx                 options     # HMETS, SIMPLE_MELT, HBV 
  list(c(20,21)),                                         # parameters for convolution c(surf. runoff)  option
  list(c(22,23)),                                         # parameters for convolution c(delay. runoff) option
  list(c(24,25,26,27)),                                   # parameters for potential melt              option
  list(c(28,29,30)),                                      # parameters for percolation                 option
  list(c(31,32)),                                         # parameters for rainsnow partitioning
  list(c(33,34))                                       # parameters for rain/snow correction
)

options_strucparams <- list(
  c(36,37,NA),
  c(38,39,NA),
  c(40,NA),
  c(41,NA),
  c(42,43,NA)
)

## read in master list and iter 
# get model structure setup for run[iter]
iter <- as.numeric(read.csv("iter.txt", header=F)[1])
arrayid <- as.numeric(read.csv("array_id.txt", header=F)[1])
catchid <- as.numeric(read.csv("catch_id.txt", header=F)[1])
master_list <- read.csv("master_modelstructure_param_list.csv")

if (iter <= 108) {
  
  master_run <- master_list[iter,]
  
  ## build required parameters list ----
  
  required_params <- NA
  for (i in 1:5) {
    if (length(options_paras_raven[[i]][[as.numeric(master_run[i]) ]])>0) {
      required_params <- c(required_params, options_paras_raven[[i]][[as.numeric(master_run[i]) ]])
    }
  }
  for (i in 6:11) {
    required_params <- c(required_params, options_paras_raven[[i]][[1]])
  }
  required_params <- unique(required_params)
  required_params <- required_params[!is.na(required_params)]
  required_params <- sort(required_params)
  
  ## build set for structural parameters ----
  required_strucs <- NA
  for (i in 1:5) {
    # if (length(options_strucparams[[i]][[as.numeric(master_run[i]) ]])>0) {
    required_strucs <- c(required_strucs, options_strucparams[[i]][[as.numeric(master_run[i]) ]])
    # }
  }
  required_strucs <- unique(required_strucs)
  required_strucs <- required_strucs[!is.na(required_strucs)]
  required_strucs <- sort(required_strucs)
  
  nonrequired_strucs <- seq(36,43)
  if (length(required_strucs) > 0 ) {
    nonrequired_strucs <- nonrequired_strucs[-which(nonrequired_strucs %in% required_strucs)]
  }
  
} else if (iter>=109) {
  required_params <- seq(1,43)
}

### write ostIn.txt file ----

# write ostIn from base with required parameters

# base file
ffbase <- "ostIn_base.txt"
basefile <- readLines(ffbase)

# initialize writing new file
ffwrite <- "ostIn.txt"
fw <- file(ffwrite,"w+")

## maxiterations
if (maxiterscheme == "Test") { 
  basefile <- gsub(x=basefile, pattern="MaxIterations 1", 
                   replacement="MaxIterations 2")
} else if (maxiterscheme == "N50") { 
  basefile <- gsub(x=basefile, pattern="MaxIterations 1", 
                   replacement=sprintf("MaxIterations %i", length(required_params)*50))
} else {
  basefile <- gsub(x=basefile, pattern="MaxIterations 1", 
                   replacement=sprintf("MaxIterations %i", as.numeric(maxiterscheme)))
}


## iter specific adjustments
if (iter <= 108) {
  ## parameters commenting out
  for (i in 1:length(basefile)) {
    
    temp <- unlist(strsplit(basefile[i], split=c("\\s+"," ","\t")))
    if (length(which(temp == "")) >=1) {
      temp <- temp[-(which(temp == ""))]
    }
    
    if (is.na(temp[1])) {
      writeLines(basefile[i], fw)
    } else if (length(grep(pattern = "par_",temp[1])) == 1) {
      
      if (as.numeric(substrRight(temp[1],2)) %in% required_params) {
        writeLines(basefile[i], fw)
      } else {
        
        writeLines(sprintf(" # %s",basefile[i]), fw)
      }
      
    } else {
      # basic line, write
      writeLines(basefile[i], fw)
    }
  }
  
} else {
  
  if (iter == 110) {
    # special case for recalibrating blended from HMETS best run
    
    # set to use initial parameter values
    basefile <- gsub(x=basefile, pattern="UseRandomParamValues", 
                     replacement="# UseRandomParamValues")
    basefile <- gsub(x=basefile, pattern="# UseInitialParamValues", 
                     replacement="UseInitialParamValues")
    
    # substitute initial structural weights
    basefile <- gsub(x=basefile, pattern="par_x36	 	  0.5556   0.0       1.0", 
                     replacement="par_x36	 	  1.0   0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x37	 	  0.5      0.0       1.0", 
                     replacement="par_x37	 	  0.0      0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x38	 	  0.5556   0.0       1.0", 
                     replacement="par_x38	 	  1.0   0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x39	 	  0.5      0.0       1.0", 
                     replacement="par_x39	 	  0.0      0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x40	 	  0.5      0.0       1.0", 
                     replacement="par_x40	 	  1.0      0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x41	 	  0.5      0.0       1.0", 
                     replacement="par_x41	 	  1.0      0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x42	 	  0.5556   0.0       1.0", 
                     replacement="par_x42	 	  1.0   0.0       1.0")
    
    basefile <- gsub(x=basefile, pattern="par_x43	 	  0.5      0.0       1.0", 
                     replacement="par_x43	 	  0.0      0.0       1.0")
    
    # read parameters from best HMETS run
    ff <- sprintf("calib_runs/best_%i/OstOutput0_%i.txt",1,1)
    pp <- read.table(ff, skip = 15)
    
    for (i in 1:length(basefile)) {
      
      temp <- unlist(strsplit(basefile[i], split=c("\\s+"," ","\t")))
      if (length(which(temp == "")) >=1) {
        temp <- temp[-(which(temp == ""))]
      }
      
      # update HMETS parameters in the basefile with optimized values
      if ((temp[1] %in% pp$V1) & (length(grep(pattern = "par_x",temp[1])) == 1)) {
        temp[2] <- pp$V3[pp$V1 == temp[1]]
        basefile[i] <- paste(temp,sep=" ", collapse = "  ")
      } 
    }
  }
  
  ## template files uncommenting
  for (i in 1:length(basefile)) {
    
    temp <- unlist(strsplit(basefile[i], split=c("\\s+"," ","\t")))
    if (length(which(temp == "")) >=1) {
      temp <- temp[-(which(temp == ""))]
    }
    
    if (is.na(temp[1])) {
      writeLines(basefile[i], fw)
    } else if (temp[1] == "#modelname.rvi.tpl") { 
      # uncomment the rvi.tpl line
      
      writeLines("modelname.rvi.tpl	./model/modelname.rvi",fw)
      
    } else {
      # basic line, write
      writeLines(basefile[i], fw)
    }
  }
}
close(fw) # close writing


### Write rvi file ----

# only need to write rvi file if not using rvi.tpl, which is done with blended model
if (iter <= 108) {
  ffbase <- "modelname.rvi.tpl"
  basefile <- readLines(ffbase)
  
  # initialize writing new file
  ffwrite <- "model/modelname.rvi"
  fw <- file(ffwrite,"w+")
  
  # replace values in rvi.template to rvi
  if (length(required_strucs) > 0) {
    for (i in 1:length(required_strucs)) {
      basefile <- gsub(x=basefile, pattern=sprintf("par_x%i", required_strucs[i]), replacement="1.00")
    }
  }

  if (length(nonrequired_strucs) > 0) {
    for (i in 1:length(nonrequired_strucs)) {
      basefile <- gsub(x=basefile, pattern=sprintf("par_x%i", nonrequired_strucs[i]), replacement="0.00")
    }
  }
  
  # write basefile to file
  writeLines(basefile,fw)
  close(fw)
}


### finished message ----

print("Rscript aa_write_input_files_02.R run")

