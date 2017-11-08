# Purpose: Script to generate plots of artificial sky brightness
# Used in pst_skg_agu_201612.pdf
# Dependencies: swnb2, NCL
# NCL script: ~/sw/anl/swnb_vz.ncl

# Format:
# All        : skg 
# CLM  output: skg_clm_[prf]
# NCL  output: fgr_skg_[dns]_[prf]_[var]
# SWNB output: skg_swn_[dns]_[prf]_
# where
# dns = population density = [urb,rmt,...] = [urban, remote, ...]
# prf = aerosol profile = [cln,ant,ntr,prd,sai] = [clean, anthro, natural, present-day, prd+stratospheric sulfate] = [no aerosol, Anthro, Natural, MERRA PD, ]
# var = variable name = [ilm,lmn] = [illuminance,luminance]

printf "Urban population density...\n"
swnb2 --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.7e-09 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_ctl.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_urb_ctl.nc
swnb2 --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.7e-09 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_xpt.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_urb_xpt.nc
cd ~/sw/anl;ncl 'ctl_nm="skg_swn_urb_ctl"' 'xpt_nm="skg_swn_urb_xpt"' 'ttl_sng="Urban Night Sky Brightness"' 'fl_out_nm="$DATA/ps/fgr_skg_urb_lmn"' 'dvc="png"' swnb_vz.ncl
cd ~/sw/anl;ncl 'fld_nm="ilm_dwn"' 'ctl_nm="skg_swn_urb_ctl"' 'xpt_nm="skg_swn_urb_xpt"' 'ttl_sng="Urban Night Sky Illuminance"' 'fl_out_nm="$DATA/ps/fgr_skg_urb_ilm"' 'dvc="png"' swnb_vz.ncl
# ncks -C -H -d bnd,0.5e-6 -v odxc_obs_aer,odxc_obs_bga,odxc_spc_aer,odxc_spc_bga ${DATA}/skg/skg_swn_urb_xpt.nc

printf "Clean urban...\n"
swnb2 -A -B --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.7e-09 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_ctl.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_urb_cln_ctl.nc
swnb2 -A    --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.7e-09 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_xpt.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_urb_cln_xpt.nc
cd ~/sw/anl;ncl 'ctl_nm="skg_swn_urb_cln_ctl"' 'xpt_nm="skg_swn_urb_cln_xpt"' 'ttl_sng="Clean Urban Night Sky Brightness"' 'fl_out_nm="$DATA/ps/fgr_skg_urb_cln"' 'dvc="png"' swnb_vz.ncl
cd ~/sw/anl;ncl 'fld_nm="ilm_dwn"' 'ctl_nm="skg_swn_urb_cln_ctl"' 'xpt_nm="skg_swn_urb_cln_xpt"' 'ttl_sng="Clean Urban Night Sky Illuminance"' 'fl_out_nm="$DATA/ps/fgr_skg_urb_cln_ilm"' 'dvc="png"' swnb_vz.ncl
# ncks -C -H -d bnd,0.5e-6 -v odxc_obs_aer,odxc_obs_bga,odxc_spc_aer,odxc_spc_bga ${DATA}/skg/skg_swn_urb_cln_xpt.nc

printf "Clean remote...\n"
swnb2 -A -B --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.65e-12 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_ctl.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_rmt_cln_ctl.nc
swnb2 -A    --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.65e-12 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_xpt.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_rmt_cln_xpt.nc
cd ~/sw/anl;ncl 'ctl_nm="skg_swn_rmt_cln_ctl"' 'xpt_nm="skg_swn_rmt_cln_xpt"' 'ttl_sng="Clean Remote Night Sky Brightness"' 'fl_out_nm="$DATA/ps/fgr_skg_rmt_cln"' 'dvc="png"' swnb_vz.ncl
cd ~/sw/anl;ncl 'fld_nm="ilm_dwn"' 'ctl_nm="skg_swn_rmt_cln_ctl"' 'xpt_nm="skg_swn_rmt_cln_xpt"' 'ttl_sng="Clean Remote Night Sky Illuminance"' 'fl_out_nm="$DATA/ps/fgr_skg_rmt_cln_ilm"' 'dvc="png"' swnb_vz.ncl
# ncks -C -H -d bnd,0.5e-6 -v odxc_obs_aer,odxc_obs_bga,odxc_spc_aer,odxc_spc_bga ${DATA}/skg/skg_swn_rmt_cln_xpt.nc

printf "Remote population density...\n"
swnb2 --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.65e-12 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_ctl.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_ctl_rmt.nc
swnb2 --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.65e-12 --slr_cst=0.0 -p ${DATA}/skg/skg_clm_xpt.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_xpt_rmt.nc
cd ~/sw/anl;ncl 'ctl_nm="skg_swn_ctl_rmt"' 'xpt_nm="skg_swn_xpt_rmt"' 'ttl_sng="Remote Night Sky Brightness"' 'fl_out_nm="$DATA/ps/fgr_skg_rmt"' 'dvc="png"' swnb_vz.ncl
cd ~/sw/anl;ncl 'fld_nm="ilm_dwn"' 'ctl_nm="skg_swn_ctl_rmt"' 'xpt_nm="skg_swn_xpt_rmt"' 'ttl_sng="Remote Night Sky Illuminance"' 'fl_out_nm="$DATA/ps/fgr_skg_ilm_rmt"' 'dvc="png"' swnb_vz.ncl
# ncks -C -H -d bnd,0.5e-6 -v odxc_obs_aer,odxc_obs_bga,odxc_spc_aer,odxc_spc_bga ${DATA}/skg/skg_swn_xpt_rmt.nc

printf "Starlight...\n"
swnb2 -p ${DATA}/skg/skg_clm_ctl.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_str_ctl.nc
swnb2 -p ${DATA}/skg/skg_clm_xpt.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_str_xpt.nc
cd ~/sw/anl;ncl 'fld_nm="flx_frc_dwn_dff"' 'ctl_nm="skg_swn_str_ctl"' 'xpt_nm="skg_swn_str_xpt"' 'ttl_sng="Diffuse Starlight Fraction"' 'fl_out_nm="$DATA/ps/fgr_skg_str"' 'dvc="png"' swnb_vz.ncl
# ncks -C -H -v flx_bb_dwn_dff,flx_bb_dwn_drc,flx_frc_dwn_dff ${DATA}/skg/skg_swn_str_xpt.nc

printf "Angular distribution...\n"
swnb2 --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.7e-09 --slr_cst=0.0 -s 16 -u 16 -p ${DATA}/skg/skg_clm_ctl.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_urb_ngl_ctl.nc
swnb2 --lmn_TOA=174 --sfc_tpt=3000 --sfc_msv=1.7e-09 --slr_cst=0.0 -s 16 -u 16 -p ${DATA}/skg/skg_clm_xpt.nc -m 0.0 -r 0.2 -z 1.0 -d ${DATA}/skg/skg_swn_urb_ngl_xpt.nc
cd ~/sw/anl;ncl 'fld_nm="lmn_bb_aa_sfc"' 'ctl_nm="skg_swn_urb_ngl_ctl"' 'xpt_nm="skg_swn_urb_ngl_xpt"' 'ttl_sng="Angular Distribution of Brightness"' 'fl_out_nm="$DATA/ps/fgr_skg_urb_lmn_ngl"' 'dvc="png"' swnb_vz.ncl
# ncks -C -H -v lmn_bb_aa_sfc ${DATA}/skg/skg_swn_urb_ngl_ctl.nc

