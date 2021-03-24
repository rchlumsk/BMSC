#!/bin/bash

set -e

echo "saving input files for the best solution found ..."

if [ ! -e best ] ; then
    mkdir best
fi

cp model/modelname.rvi  best/modelname.rvi
cp model/modelname.rvh  best/modelname.rvh
cp model/modelname.rvt  best/modelname.rvt
cp model/modelname.rvc  best/modelname.rvc
cp model/modelname.rvp  best/modelname.rvp
cp model/output/Diagnostics.csv best/Diagnostics.csv 
cp model/output/Hydrographs.csv best/Hydrographs.csv

exit 0

