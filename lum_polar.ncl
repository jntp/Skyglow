load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  cond = addfile("skg_swnb_dff.nc", "r") ;-- cond for "conditions"

  ;** Read in data required for calculation
  cond_lmn = cond->lmn_bb_aa ;-- broadband azimuthally averaged luminance
  levp = cond->levp ;-- pressure coordinates

  ;** Convert units for better readability
  cond_lmn = cond_lmn * 1000 ;-- convert to millicandelas per meter squared
  cond_lmn@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hectopascals
  levp@units = "hectopascal"

  ;** Prepare plot
  wks = gsn_open_wks("png", "lum_polar_dff")  

  res = True
  res@gsnMaximize = True ;-- maximize plot
  res@sfYArray = levp ;-- use levp for y axis
  res@tiMainString = "Urban Night Sky Brightness - Difference"
  res@tiXAxisString = "Polar Angle [rad]"
  res@tiYAxisString = "Pressure [mb]"
  res@gsnLeftString = "Luminance"
  res@gsnRightString = "mcd m~S~-2~N~"
  res@tiMainFontHeightF = 0.0225
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@trYReverse = True ;-- reverse Y-axis
 
  ;** Add some colors
  res@cnMonoLineColor = False ;-- don't draw lines in only one color
  res@cnLineColors = span_color_rgba("NCV_jet", 30) ;-- NCV_jet has 256 colors; span it to get 30 colors
  res@cnLineThicknessF = 3.0 ;-- make lines slightly thicker

  ;** Make the plot
  plot = gsn_csm_contour(wks, cond_lmn, res) ;-- draw a contour plot

end
