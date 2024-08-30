#!/bin/bash

#SBATCH -A p31589
#SBATCH -p short
#SBATCH -t 00:20:00
#SBATCH --mem=30G

matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('/home/nck1870/repos')); single_sub_smooth(50280, 1,2,0); quit"

