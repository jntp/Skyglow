load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF files (two for calculating difference) 
  diff = addfile("skg_swn_urb_xptmcln.nc", "r") ;-- difference file
  cont = addfile("skg_swn_urb_cln.nc", "r") ;-- used to address "zero" issues in difference file and for calculating the percentage

  ;** Read in data required for calculation 
  diff_lmn = diff->lmn_bb_aa ;-- broadband azimuthally averaged luminance
  cont_lmn = cont->lmn_bb_aa
  levp = diff->levp ;-- pressure coordinates
  plr_dgr = cont->plr_dgr ;-- polar angle in degrees

  ;** Divide difference data by control data and multiply by 100 to obtain percentage 
  percentage = (diff_lmn/cont_lmn) * 100 

  ;** Convert units for better readability
  levp = levp / 100 ;-- convert to hectopascals
  levp@units = "hectopascal"

  ;** Swap values on plr_dgr to plot angles in the viewer's perspective instead of the light's
  plr_dgr = plr_dgr(::-1)

  ;-- Read the colormap in an array and set new colormap
  cmap = read_colormap_file("BlueRed")
  newColors = cmap(118:, :) ;-- pick only part of the colormap

  ;** Prepare plot
  wks = gsn_open_wks("png", "skg_lmn_urb_xptmcln_pz")  

  res = True
  res@gsnMaximize = True ;-- maximize plot
  res@sfXArray = plr_dgr ;-- show the x axis in degrees rather than radians
  res@sfYArray = levp ;-- use levp for y axis
  res@tiMainString = "Urban Brightness: Difference (Geoengineered - Clean Sky)"
  res@tiXAxisString = "Zenith Viewing Angle [deg]"
  res@tiYAxisString = "Pressure [mb]"
  res@gsnLeftString = "Change in Luminance"
  res@gsnRightString = "%"
  res@tiMainFontHeightF = 0.0225
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@trXMaxF = 90 ;-- truncate plot at 90 degrees
  res@trYReverse = True ;-- reverse Y-axis
  res@gsnYAxisIrregular2Linear = True ;-- make y-axis "regular"
  res@lbOrientation = "Vertical" ;-- make the label bar vertical

  ;** Add some colors and turn into fill contour plot
  res@cnFillOn = True ; turn on contour fill
  res@cnLineLabelsOn = True ;-- turn on contour line labels
  res@cnLineLabelInterval = 1 ;-- increase line labels
  res@cnFillPalette = newColors ;-- set color map
  res@cnLinesOn = True ;-- keep contour lines 
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnLevels = (/0, 10, 20, 30, 40, 50, 75, 100, 250, 500, 750, 1000/)
  

  ;** Make the plot
  plot = gsn_csm_contour(wks, percentage, res) ;-- draw a contour plot 

end

;-- Try to figure out how to put labels toward the bottom of the plot
