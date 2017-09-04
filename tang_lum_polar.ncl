load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  x = (/ (/0.5, 0.37, 0.4, 0.43, 0.46, 0.50, 0.55, 0.63, 0.73, 0.83, 0.93, 1.03, 1.13, 1.23, 1.33, 1.43, 1.53, 1.63, 1.71, 1.78, 1.85/), (/0.5, 0.52, 0.54, 0.58, 0.70, 0.80, 0.90, 1, 1.10, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.09, 2.17, 2.22/) /)
  x!0 = "Present Day"
  x!1 = "Geoengineered"
  x@units = "microcandelas per meter squared"
  y = (/0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000/) ;-- pressure levels
  y@units = "hPa"
  
  ;-- Prepare plot
  wks = gsn_open_wks("png", "tang_lum_polar")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Sky Brightness as a Function of Polar Angle"
  res@tiXAxisString = "Zenith-viewing Luminance [mcd m~S~-2~N~]"
  res@tiYAxisString = "Pressure [mb]"
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 1000 ;-- y axis minimum value
  res@trYMaxF = 0 ;-- y axis maximum value
  res@trXMinF = 0 ;-- x axis minimum value
  res@trXMaxF = 2.8 ;-- x axis maximum value
  
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"green", "blue"/)

  ;-- Make the plot
  plot = gsn_csm_xy(wks, x, y, res) ;-- draw a pressure/height plot

  ;-- Create a legend
  textres = True
  textres@lgLabels = (/"Present Day", "Geoengineered"/)
  textres@lgLabelFontHeights = (/0.014, 0.014/)

  ;-- Lines on Legend
  lineres = True
  lineres@lgLineColors = (/"green", "blue"/)
  lineres@lgLineThicknesses = 5
  lineres@LineLengthPercent = 9
  
  ;-- Position the legend
  gres = True
  gres@YPosPercent = 15 ;-- from bottom
  gres@XPosPercent = 50 ;-- from left
  gres@ItemSpacePercent = 10 ;-- space between legend items

  plot = simple_legend(wks, plot, gres, lineres, textres)

  draw(plot)
  frame(wks)

end 


;-- You left off at tweaking the legend to make it look nice (and identical to the one on the seminar)
