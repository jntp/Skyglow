load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF files
  scat = addfile("scat.nc", "r")
  
  ;** Read in data requried for plotting
  ra = scat->ra2000 ;-- right ascension
  dec = scat->dec2000 ;-- declination
  mag = scat->mag ;-- stellar magnitude
  typeClass = scat->typeClass ;-- star type (character)

  ;** Create custom colormap to color in markers
  colors = (/"dodgerblue3", "dodgerblue", "navajowhite", "khaki1", "darkgoldenrod1", "darkorange", "firebrick1", "black"/)

  ;** Prepare plot
  wks = gsn_open_wks("png", "scat_plot")
  ; gsn_define_colormap(wks, colors)

  res = True
  res@gsnDraw = False ;-- don't draw plot
  res@gsnFrame = False ;-- don't advance frame
  res@pmTickMarkDisplayMode = "Always" ;-- turn on fancy tickmarks

  ;** Specify where the plot goes
  res@vpXF = 0.20
  res@vpYF = 0.90
  res@vpWidthF = 0.65
  res@vpHeightF = 0.65

  res@trXMinF = 0 ;-- right ascension
  res@trXMaxF = 24
  res@trYMinF = -90 ;-- declination
  res@trYMaxF = 90

  ;** Marker Resources
  res@xyMarkLineMode = "Markers"
  res@xyMarkerSizeF = 0.008 ;-- will revise later (to account for varying sizes of different magnitudes)
  res@xyMarkerThicknessF = 3
  res@xyMonoMarkerColor = False
  res@xyMarkerColors = colors(:)
  res@xyMarkers = (/9,7,6,5,4,3,2,15/)

  ;** Put Tickmark resources options here (if needed)

  ;** Title Resources
  res@tiMainString = "Stars in Night Sky: Present Day"
  res@tiXAxisString = "Right Ascension [hr]"
  res@tiYAxisString = "Declination [deg]"
  res@tiMainFontHeightF = 0.0225
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020

  ;** Create the scatter plot
  plot = gsn_csm_xy(wks, ra, dec, res)
  draw(plot)

  ;** Draw the labels (bottom legend)
  labels  = (/  "O",  "B",  "A",  "F",  "G",  "K",  "M",  "+"/)
  markers = (/    9,    7,    6,    5,    4,    3,    2,   15/)
  xpos    = (/ 0.10, 0.21, 0.32, 0.43, 0.54, 0.65, 0.76, 0.87/)  ;-- you will probably have to change this later
  xpos2   = (/ 0.13, 0.24, 0.35, 0.46, 0.57, 0.68, 0.79, 0.90/)

  mkres = True ;-- marker resources
  txres = True ;-- text resources
  txres@txFontHeightF = 0.018
  txres@txJust = "CenterLeft"

  do i = 0, 7 ;-- assign attributes for each marker label
    mkres@gsMarkerThicknessF = 4
    mkres@gsMarkerSizeF = 0.025
    mkres@gsMarkerIndex = markers(i)
    mkres@gsMarkerColor = colors(i)

    gsn_polymarker_ndc(wks, xpos(i), 0.07, mkres) ;-- Add markers to legend 
    gsn_text_ndc(wks, labels(i), xpos2(i), 0.07, txres) ;-- Add text (that specify the markers) to legend
  end do

  frame(wks)
end


;-- You left off at figuring out how to control marker sizes based on magnitude
;-- Refer to scatter plot example 7
;-- Look into gsn_polymarker
