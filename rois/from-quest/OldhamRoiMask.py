import nibabel as nib
import numpy as np
from nilearn import image, masking
from nilearn.input_data import NiftiMasker, NiftiLabelsMasker, NiftiSpheresMasker
import os.path
import glob
from nilearn import datasets, plotting
from nilearn.masking import _unmask_3d
from nilearn.maskers import nifti_spheres_masker
from nilearn import image
import numpy as np
import nibabel as nib
from statistics import mean







# # Load the MRI image
# mri_image = nib.load(subject)
# mri_data = mri_image.get_fdata()

# #print(img.shape)
# sub_mean = image.mean_img(subject).get_fdata()
# #print(sub_mean.shape)

# Load MNI brain mask from template flow 
# TODO change to other MNI if that's better
# TODO masks are here /projects/b1108/templateflow on quest
brain_mask = nib.load("/Users/ninakougan/Documents/templateflow/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-01_desc-brain_mask.nii.gz")



'''
Note that you have to do each ROI seperately and then merge 
them at the end using image.mathimg. 
'''
roi_right = [(22, -2, -14)] #define right for amygdala reward outcome
roi_left = [(-18, 0, -16)] #define left for amygdala reward outcome

#first ROI
_, R = nifti_spheres_masker._apply_mask_and_get_affinity(
    seeds=roi_right, #define seeds for amygdala reward outcome
    niimg=None,
    radius=8,  #set radius in MM
    allow_overlap=True, 
    mask_img=brain_mask) #pass in MNI mask

right_mask = _unmask_3d(
    X=R.toarray().flatten(), 
    mask=brain_mask.get_fdata().astype(bool))

right_mask = nib.Nifti1Image(right_mask, brain_mask.affine)
#nib.save(right_mask, "Amygdala_right_8mmsphere_Oldham.nii.gz") #TODO uncomment if you want to save right side

#second ROI
_, L = nifti_spheres_masker._apply_mask_and_get_affinity(
    seeds=roi_left, #define seeds for amygdala reward outcome
    niimg=None,
    radius=8,  #set radius in MM
    allow_overlap=True, 
    mask_img=brain_mask) #pass in MNI mask


left_mask = _unmask_3d(
    X=L.toarray().flatten(), 
    mask=brain_mask.get_fdata().astype(bool))

left_mask = nib.Nifti1Image(left_mask, brain_mask.affine)
#nib.save(left_mask, "Amygdala_left_8mmsphere_Oldham.nii.gz") #TODO uncomment if you want to save right side

#combine ROIs into one img
combined = image.math_img('img1 + img2', img1=right_mask, img2=left_mask)

#Save to whereever you are running the script from
nib.save(combined, "Amygdala_8mmsphere_Oldham.nii.gz")




