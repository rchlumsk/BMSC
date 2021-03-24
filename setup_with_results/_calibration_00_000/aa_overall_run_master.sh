#!/bin/bash

set -ex
# set option to stop on error, not continue
# x for debugging, writes out each line (more terminal output)

# echo "pwd is $(pwd)"

current_wd=$(pwd)

Rscript ../aa_write_input_files_01.R

# unlink dangling symbolic links
if [ -e Ostrich.exe ] ; then
    rm Ostrich.exe
fi
if [ -e model/Raven.exe ] ; then
    rm model/Raven.exe
fi

# switch to tmpdir
if [ ! -d $1 ] ; then
	mkdir $1
fi
cd $1
tmpdir="./raven_run_$2_$3"

# remove previous raven_run folders
if [ -d "raven_run" ] ; then 
	for f in ./raven_run*; do
		# echo $f
		rm -r $f
		break
	done
fi

# make tmpdir if not exists
if [ ! -d $tmpdir ] ; then
    mkdir $tmpdir
fi
cd $tmpdir

# copy everything to tmpdir
cp -rp $current_wd/* .

# copy executables over
rm ./exes/*
cp $current_wd/../../exes/Raven_rev254.exe ./model/Raven.exe
cp $current_wd/../../exes/Ostrich.exe ./Ostrich.exe

# make calib_runs folder
if [ ! -d calib_runs ] ; then
    mkdir calib_runs
fi

# change model runs as needed here
# {1..3} used for debugging
# {1..109} used for a full model run of all structures
for i in 110
do
	# echo "This is run $i"
	echo "$i," > iter.txt

    ## writes out the specific model structure w.r.t. iter
	Rscript aa_write_input_files_02.R
	./Ostrich.exe
    
    ## post-process
    if [ -d calib_runs/best_$i ] ; then
        rm -r calib_runs/best_$i
    fi
    mv best calib_runs/best_$i
    # tail -n -80 OstOutput0.txt > OstOutput0_$i.txt    
    Rscript aa_rewrite_ost_output.R
done

# cleanup
# rm -r ./model/output/
# rm ./model/modelname*

# zip all files we want
# likely just calib_runs
tar -czvf calib_runs_$2_$3.tar.gz calib_runs/

# copy zip back to other folder
cp -rp calib_runs_$2_$3.tar.gz $current_wd/. 

# cleanup
cd ..
rm -r $tmpdir
cd $current_wd

# unzip calib runs in og directory
# if [ -d calib_runs ] ; then
#     rm -r calib_runs
# fi
tar -xzvf calib_runs_$2_$3.tar.gz

# postprocessing and running results
## save for once all runs done, then scrape all 240 folders
# Rscript aa_postrunmodels_mopex.R
