load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  cond = addfile("skg_swn_rmt_ngl_xpt.nc", "r") ;-- cond for "conditions"

  ;** Read in data required for calculation
  cond_lmn = cond->lmn_bb_aa ;-- broadband azimuthally averaged luminance
  levp = cond->levp ;-- pressure coordinates

  ;** Convert units for better readability
  cond_lmn = cond_lmn * 1000 ;-- convert to millicandelas per meter squared
  cond_lmn@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hectopascals
  levp@units = "hectopascal"

  ;-- Make new color palette based off of MPL_summer, specifically for remote conditions
  cmap = read_colormap_file("MPL_summer")
  remoteScheme = cmap(0:12:1, :) ;-- take only some of the values from MPL_summer

  ;** Prepare plot
  wks = gsn_open_wks("png", "lum_polar_rmt_xpt_16")  

  res = True
  res@gsnMaximize = True ;-- maximize plot
  res@sfYArray = levp ;-- use levp for y axis
  res@tiMainString = "Remote Night Sky Brightness - Geoengineered"
  res@tiXAxisString = "Polar Angle [rad]"
  res@tiYAxisString = "Pressure [mb]"
  res@gsnLeftString = "Luminance"
  res@gsnRightString = "mcd m~S~-2~N~"
  res@tiMainFontHeightF = 0.0225
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@trYReverse = True ;-- reverse Y-axis
  res@gsnYAxisIrregular2Linear = True ;-- make y-axis "regular"
  res@lbOrientation = "Vertical" ;-- make the label bar vertical

  ;** Add some colors and turn into fill contour plot
  res@cnFillOn = True ; Turn on contour fill
  res@cnFillPalette = remoteScheme ;-- set color map
  res@cnLinesOn = True ;-- keep contour lines
  res@cnLevelSelectionMode = "ExplicitLevels" ;-- set color levels manually
  res@cnLevels = (/0.05, 0.1, 0.15, 0.2/)

  ;** Make the plot
  plot = gsn_csm_contour(wks, cond_lmn, res) ;-- draw a contour plot

  ;** Retrieve contour levels (to adjust label bar)
  getvalues plot@contour
    "cnLevels" : levels
  end getvalues

  ;-- Adjust label bar and plot again
  res@lbLabelStrings = sprintf("%3.2f", levels) ;-- format the label
  plot = gsn_csm_contour(wks, cond_lmn, res) ;-- plot again with reformatted label 

end

