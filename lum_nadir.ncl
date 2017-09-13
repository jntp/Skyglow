load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  ctl = addfile("skg_swnb_ctl.nc", "r") ;-- from control file (present day)
  xpt = addfile("skg_swnb_xpt.nc", "r") ;-- from experiment file (geoengineered)

  ;** Read in data required for calculation
  ctl_ndr = ctl->lmn_bb_aa_ndr ;-- broadband azimuthally averaged luminance toward nadir (x axis)
  xpt_ndr = xpt->lmn_bb_aa_ndr 
  levp = ctl->levp ;-- pressure coordinates (y axis)

  x_dim = dimsizes(levp) ;-- get dimensions for a multidimensional array containing control and experiment values
 

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = (/ctl_ndr, xpt_ndr/) 
  x@long_name = "Broadband azimuthally averaged luminance towards nadir"
  x!0 = "conditions"
  x!1 = "luminance"

  ;** Convert units for better readability
  x = x * 1000 ;-- convert to millicandelas per meter squared
  x@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal"
  
  ;** Prepare plot
  wks = gsn_open_wks("png", "lum_nadir")

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
  res@xyLineColors = (/"green", "blue"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Make the plot
  plot = gsn_csm_xy(wks, x, levp, res) ;-- draw a pressure/height plot 

  ;** Create a legend
  textres = True 
  textres@lgLabels = (/"Present Day", "Geoengineered"/) 
  textres@lgLabelFontHeights = (/0.020, 0.020/)

  ;** Lines on Legend
  lineres = True
  lineres@lgLineColors = (/"green", "blue"/)
  lineres@lgLineThicknesses = 5
  lineres@LineLengthPercent = 9
  
  ;** Position the legend
  gres = True
  gres@YPosPercent = 20 ;-- from top
  gres@XPosPercent = 50 ;-- from left
  gres@ItemSpacePercent = 10 ;-- space between legend items

  plot = simple_legend(wks, plot, gres, lineres, textres)

  draw(plot)
  frame(wks)

end

;-- You left off at figuring how to "strip" off the blue line... and switching the "present day" and "geoengineered" on legend
