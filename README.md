[![license](https://img.shields.io/badge/license-GPL3-lightgrey.svg)](https://choosealicense.com/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4635309.svg)](https://doi.org/10.5281/zenodo.4635309)

# Simultaneous calibration of hydrologic model structure and parameters using a blended model
*by Robert Chlumsky, Juliane Mai, James R Craig, and Bryan A Tolson (University of Waterloo, Canada)*

## Abstract
The advent of hydrological modelling frameworks that support multiple model structures using the same software enables both model structure and model parameters to be calibrated and assessed. To date, the identification of optimal model structure has typically been performed manually. Here, a  continuous (rather than discrete) treatment of model structure is used, which enables simultaneous automatic calibration of model structure and parameters using a conventional real-valued decision variable optimization algorithm (the Dynamically Dimensioned Search algorithm, DDS). The method, referred to herein as Blended Model Structure Calibration (BMSC), relies upon the calculation of each hydrologic flux  (e.g., for infiltration) as a weighted average of fluxes generated from multiple process algorithm options. This method is applied to 12 lumped MOPEX catchment models and compared to the calibration of 108 fixed model structures, representing all possible permutations of fixed model structures with the given process options in this study. The BMSC method consistently identified near-optimal model structure (as evaluated using average model rank performance) at significantly lower computational cost than calibrating the collective of fixed structure models. The BMSC method also provides a useful tool in identifying dominant processes and model structures in catchments.

They key points from this study are:

1. Model structure and parameters may be calibrated simultaneously using the Blended Model Structure Calibration (BMSC) method
2. The BMSC method consistently identified near-optimal model structures at significantly lower computational cost than fixed structures
3. This method may also be useful in identifying dominant processes and model structures in catchments

## Examples
We provide the setup files required to run the experiment (see [here](https://github.com/rchlumsk/BMSC/tree/main/setup_with_results)).

## Results
The experimental results are provided with respect to model performance metrics and parameter values. These are found in the [setup_with_results](https://github.com/rchlumsk/BMSC/tree/main/setup_with_results) folder.

## Creating Plots
This GitHub contains all scripts and data to reproduce the plots in the paper and Supplementary Material. Please see the main plotting script [processing_and_figures.Rmd](https://github.com/rchlumsk/BMSC/blob/main/processing_and_figures.Rmd) and follow the chunks in the file. The produced figures are also available in the [figures](https://github.com/rchlumsk/BMSC/tree/main/figures) folder. All the data used to produce those figures can be found in the results folders (see above). 

## Citation

### Journal Publication
Chlumsky, R., Mai, J., Craig, J. R., and Tolson, B. A. (submitted paper).<br>
Simultaneous calibration of hydrologic model structure and parameters using a blended model. <br>

### Code Publication
Chlumsky, R., Mai, J., Craig, J. R., and Tolson, B. A. (2021).<br>
Simultaneous calibration of hydrologic model structure and parameters using a blended model. <br>
*Zenodo*<br>
https://doi.org/10.5281/zenodo.4635309
