load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF files (two for calculating difference) 
  cond = addfile("skg_swnb_dff.nc", "r") ;-- cond for "conditions"
  temp = addfile("skg_swnb_ctl.nc", "r") ;-- for retrieving old data (addresses problems in "difference" files)

  ;** Read in data required for calculation
  cond_lmn = cond->lmn_bb_aa ;-- broadband azimuthally averaged luminance
  levp = cond->levp ;-- pressure coordinates
  plr_dgr = temp->plr_dgr ;-- polar angle in degrees

  ;** Convert units for better readability
  cond_lmn = cond_lmn * 1000 ;-- convert to millicandelas per meter squared
  cond_lmn@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hectopascals
  levp@units = "hectopascal"

  ;-- Swap values on plr_dgr to plot angles in the viewer's perspective instead of the light's
  plr_dgr = plr_dgr(::-1) 

  ;** Prepare plot
  wks = gsn_open_wks("png", "lum_polar_dff")  

  res = True
  res@gsnMaximize = True ;-- maximize plot
  res@sfXArray = plr_dgr ;-- show the x axis in degrees rather than radians
  res@sfYArray = levp ;-- use levp for y axis
  res@tiMainString = "Urban Night Sky Brightness - Difference"
  res@tiXAxisString = "Viewing Angle [deg]"
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
  res@cnFillPalette = "BlueRed" ;-- set color map
  res@cnLinesOn = True ;-- keep contour lines

  ;** Make the plot
  plot = gsn_csm_contour(wks, cond_lmn, res) ;-- draw a contour plot

  ;** Retrieve contour levels (to adjust label bar)
  getvalues plot@contour
    "cnLevels" : levels
  end getvalues

  ;-- Adjust label bar and plot again
  res@lbLabelStrings = sprintf("%3.1f", levels) ;-- format the label
  plot = gsn_csm_contour(wks, cond_lmn, res) ;-- plot again with reformatted label 

end
