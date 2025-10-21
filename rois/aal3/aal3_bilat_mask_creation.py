import nibabel as nib
import numpy as np

atlas = nib.load('/Users/ninakougan/Documents/GitHub/RISE_CREST/rois/aal3/AAL3v1.nii')
data = atlas.get_fdata()

# Example IDs for left/right amygdala (replace with actual IDs)
roi_ids = [159, 160]
mask = np.isin(data, roi_ids)

mask_img = nib.Nifti1Image(mask.astype(np.uint8), atlas.affine)
nib.save(mask_img, 'VTA_bilateral.nii.gz')