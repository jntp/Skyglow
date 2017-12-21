load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  ctl = addfile("skg_swn_urb_ngl_ctl.nc", "r") ;-- from control file (present day)
  xpt = addfile("skg_swn_urb_ngl_xpt.nc", "r") ;-- from experiment file (geoengineered)
  cln = addfile("skg_swn_urb_cln_ctl.nc", "r") ;-- form clean file

  ;** Read in data required for calculation
  ctl_ndr = ctl->lmn_bb_aa_ndr(31:) ;-- broadband azimuthally averaged luminance toward nadir (x axis)
  xpt_ndr = xpt->lmn_bb_aa_ndr(31:)
  cln_ndr = cln->lmn_bb-aa_ndr(31:)

  levp = ctl->levp ;-- pressure coordinates (y axis)

  x_dim = dimsizes(levp) ;-- get dimensions for a multidimensional array containing control and experiment values 

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = (/ctl_ndr, xpt_ndr, cln_ndr/) 
  x@long_name = "Broadband azimuthally averaged luminance towards nadir"
  x!0 = "conditions"
  x!1 = "luminance"

  ;** Convert units for better readability
  x = x * 1000 ;-- convert to millicandelas per meter squared
  x@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal" 

  ;** Prepare plot
  wks = gsn_open_wks("png", "lum_nadir_16")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Urban Night Sky Brightness"
  res@tiXAxisString = "Zenith-viewing Luminance [mcd m~S~-2~N~]"
  res@tiYAxisString = "Pressure [mb]"
  res@tiMainFontHeightF = 0.025
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 0 ;-- y axis minimum value
  res@trYMaxF = 1000 ;-- y axis maximum value
  res@trXMinF = 0 ;-- x axis minimum value
  res@trXMaxF = 2.8 ;-- x axis maximum value
  
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"green", "blue", "black"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Create a legend
  res@pmLegendDisplayMode = "Always" ;-- turn on legend
  res@pmLegendSide = "Top" ;-- position of legend (what side)

  res@pmLegendParallelPosF = 0.73 ;-- move units right
  res@pmLegendOrthogonalPosF = -0.38 ;-- move units down

  res@lgPerimOn = False ;-- turn off legend perimeter
  res@pmLegendWidthF = 0.11
  res@pmLegendHeightF = 0.14
  res@lgLabelFontHeightF = 0.020
  res@xyExplicitLegendLabels = (/"  Present Day", "  Geoengineered", "  Clean Sky" /)
  res@lgItemOrder = (/1, 2, 0/) ;-- reorder items on legend

  ;** Make the plot
  plot = gsn_csm_xy(wks, x, levp, res) ;-- draw a pressure/height plot  

  draw(plot)
  frame(wks)

end

;-- You left off at adjusting the legend
