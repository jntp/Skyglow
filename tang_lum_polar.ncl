load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  dataFile = addfile("skg_swnb_ctl.nc", "r")

  ;** Read in data required for calculation
  lmn_bb_aa = dataFile->lmn_bb_aa ;-- broadband azimuthally averaged luminance toward zenith
  levp = dataFile->levp ;-- pressure coordinates (y axis)

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = lmn_bb_aa(plr|0:2, levp|:) ;-- now 2 x 93 instead of 93 x 4 (only plotting two lines instead of four)

  ;** Convert units for better readability
  x = x * 1000 ;-- convert to millicandelas per meter squared
  x@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal"
  
  ;** Prepare plot
  wks = gsn_open_wks("png", "tang_lum_polar")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Sky Brightness as a Function of Polar Angle"
  res@tiXAxisString = "Zenith-viewing Luminance [mcd m~S~-2~N~]"
  res@tiYAxisString = "Pressure [mb]"
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 0 ;-- y axis minimum value
  res@trYMaxF = 1000 ;-- y axis maximum value
  res@trXMinF = 0 ;-- x axis minimum value
  res@trXMaxF = 5 ;-- x axis maximum value
  
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"green", "blue"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Make the plot
  plot = gsn_csm_xy(wks, x, levp, res) ;-- draw a pressure/height plot 

  ;** Create a legend
  textres = True 
  textres@lgLabels = (/"~F33~p~F~ radians", "2"+"~F33~p"+"/3~F~ radians"/) ;-- Prints "Pi radians" and "(2*pi)/3 radians"
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

