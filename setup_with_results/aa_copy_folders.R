
### set array number ----
# note that this needs to be consistent with that in the sub_array_run.sh file
number_arrays <- 20 # number of replicates per mopex set
mopex_set <- seq(1,12) # mopex catchments to create folders for
# number_arrays <- 2
# mopex_set <- c(10)

# number_actual_array
number_arrays*length(mopex_set)

### copy out folders ----
for (j in mopex_set) {
  for (i in 1:number_arrays) {
    # system(sprintf("cp -rp _calibration_00_000 calibration_%02d_%03d",j,i))
    # system(sprintf('echo "%i," > calibration_%02d_%03d/array_id.txt',i,j,i ))
    # system(sprintf('echo "%i," > calibration_%02d_%03d/catch_id.txt',j,j,i ))
    # system(sprintf("cp run_mode.txt calibration_%02d_%03d/.",j,i))
    
    system(sprintf("cp -rp _calibration_00_000/aa_overall_run_master.sh calibration_%02d_%03d/aa_overall_run_master.sh",j,i))
    system(sprintf("cp -rp _calibration_00_000/aa_write_input_files_02.R calibration_%02d_%03d/aa_write_input_files_02.R",j,i))
  }
}

### write in folder list text file ----
 fw <- file("folder_list.txt","w+")
 for (j in mopex_set) {
   for (i in 1:number_arrays) {
     writeLines(sprintf("calibration_%02d_%03d",j,i),fw)
   }
 }
 close(fw)

