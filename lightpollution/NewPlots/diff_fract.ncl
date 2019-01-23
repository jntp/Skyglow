load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  ctl = addfile("skg_swn_str_ctl.nc", "r") ;-- from control file (present day)
  xpt = addfile("skg_swn_str_xpt.nc", "r") ;-- from experiment file (geoengineered)
  cln = addfile("skg_swn_str_cln.nc", "r") ;-- form clean file

  ;** Read in data required for calculation
  ctl_dff = ctl->flx_frc_dwn_dff(31:) ;-- broadband azimuthally averaged luminance toward nadir (x axis)
  xpt_dff = xpt->flx_frc_dwn_dff(31:)
  cln_dff = cln->flx_frc_dwn_dff(31:)

  levp = ctl->levp(31:) ;-- pressure coordinates (y axis)

  x_dim = dimsizes(levp) ;-- get dimensions for a multidimensional array containing control and experiment values 

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = (/ctl_dff, xpt_dff, cln_dff/) 
  x@long_name = "Diffuse fraction of downwelling broadband flux"
  x!0 = "conditions"
  x!1 = "diffuse fraction"

  ;** Convert units for better readability
  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal" 

  ;** Prepare plot
  wks = gsn_open_wks("png", "skg_swnb_str")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Diffuse Starlight Fraction"
  res@tiXAxisString = "Diffuse Fraction of Downwelling Irradiance"
  res@tiYAxisString = "Pressure [mb]"
  res@tiMainFontHeightF = 0.025
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 0 ;-- y axis minimum value
  res@trYMaxF = 1000 ;-- y axis maximum value

  ;** Choose min and max value of x axis
  ; res@trXMinF = 0.9 ;-- x axis minimum value
  ; res@trXMaxF = 1.1 ;-- x axis maximum value
  
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"black", "green", "blue"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Create a legend
  res@pmLegendDisplayMode = "Always" ;-- turn on legend
  res@pmLegendSide = "Top" ;-- position of legend (what side)

  ;** Set position of legend
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
