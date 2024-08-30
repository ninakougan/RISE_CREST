#!/bin/bash

#SBATCH -A p31589
#SBATCH -p short
#SBATCH -t 00:20:00
#SBATCH --mem=20G

matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('/home/nck1870/repos')); run_sub_firstlevel_outcome(50280); quit"

