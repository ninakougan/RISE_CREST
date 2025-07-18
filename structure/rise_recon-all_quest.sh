#! /bin/bash

#SBATCH -A p31589
#SBATCH -p short
#SBATCH -t 4:00:00
#SBATCH -N 1
#SBATCH --job-name="fs reconall"
#SBATCH --mail-user=ninakougan@northwestern.edu
#SBATCH --mail-type=ALL

module load freesurfer/7.3.2
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1

recon-all -s sub-50133 -i /projects/b1108/projects/b1108/studies/rise/data/raw/neuroimaging/bids/sub-50133/ses-1/anat/sub-50133_ses-1_run-1_T1w.nii.gz -all


