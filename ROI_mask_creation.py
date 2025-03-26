import nibabel as nib
import numpy as np
from nilearn.masking import _unmask_3d
from nilearn.maskers import nifti_spheres_masker

# Load MNI brain mask from template flow
brain_mask = nib.load("/Users/ninakougan/Documents/templateflow/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-01_desc-brain_mask.nii.gz")

# Define ROI sets
roi_sets = {
    "single": [(20, 0, -14)],  # Single ROI example
    "multiple": [
        (-2, 42, -6),
        (2, 44, -10),
        (-6, 52, -14)
    ]
}

# Choose the ROI set to use
use_multiple_rois = True  # Set to False for a single ROI
roi_coords = roi_sets["multiple"] if use_multiple_rois else roi_sets["single"]

# Function to create sphere masks
def create_sphere_mask(roi_coords, brain_mask):
    mask_shape = brain_mask.shape
    combined_mask_data = np.zeros(mask_shape, dtype=bool)  # Initialize empty mask

    for coord in roi_coords:
        _, mask_affinity = nifti_spheres_masker._apply_mask_and_get_affinity(
            seeds=[coord],  # Pass coordinates as a list
            niimg=None,
            radius=8,  # Sphere size in mm
            allow_overlap=True,
            mask_img=brain_mask
        )
        single_sphere = _unmask_3d(mask_affinity.toarray().flatten(), brain_mask.get_fdata().astype(bool))
        
        # Ensure single_sphere is boolean before applying OR operation
        single_sphere = single_sphere.astype(bool)
        
        combined_mask_data |= single_sphere  # Combine masks using logical OR

    return combined_mask_data

# Create mask
combined_mask = nib.Nifti1Image(create_sphere_mask(roi_coords, brain_mask).astype(np.uint8), brain_mask.affine)

# Save the combined mask
nib.save(combined_mask, "Oldham_OFC_8mmsphere_Out.nii.gz")
