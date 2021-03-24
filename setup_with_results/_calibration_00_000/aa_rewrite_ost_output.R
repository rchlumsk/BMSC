
## read in OstOutput0.txt and process the file to write 
## calibration runs and final parameter set to file

iter <- as.numeric(read.csv("iter.txt", header=F)[1])

ffbase <- "OstOutput0.txt"
basefile <- readLines(ffbase)
setup_start <- which(basefile == "Ostrich Setup")
setup_stop <- grep(pattern="Penalty Method              :", basefile)+1
param_start <- which(basefile == "Optimal Parameter Set")
param_stop <- which(basefile == "Summary of Constraints")-1

# write new file
ffwrite <- sprintf("calib_runs/best_%i/OstOutput0_%i.txt",iter,iter)
fw <- file(ffwrite,"w+")
writeLines(basefile[setup_start:setup_stop], fw)
writeLines(basefile[param_start:param_stop], fw)
close(fw)
