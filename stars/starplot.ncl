load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF files
  scat = addfile("scat.nc")
  
  ;** Read in data requried for plotting
  ra = scat->ra2000 ;-- right ascension
  dec = scat->dec2000 ;-- declination
  mag = scat->mag ;-- stellar magnitude
  typeClass = scat->typeClass ;-- star type (character)

  ;** Create custom colormap to color in markers
  colors = (/"dodgerblue3", "dodgerblue", "navajowhite", "khaki1", "darkgoldenrod1", "darkorange", "firebrick1", "black"/)

  ;** Prepare plot
  wks = gsn_open_wks("png", "scat_plot")
  gsn_define_colormap(wks, colors)

  res = True
  res@gsnDraw = False ;-- don't draw plot
  res@gsnFrame = False ;-- don't advance frame
  res@mpGridAndLimbOn = True ;-- turn on grid lines
  res@pmTickMarkDisplayMode = "Always" ;-- turn on fancy tickmarks

  ;** Specify where the plot goes
  res@vpXF = 0.2
  res@vpYF = 0.85
  res@vpWidthF = 0.5
  res@vpHeightF = 0.5

  res@trXMinF = 0 ;-- right ascension
  res@trXMaxF = 24
  res@trYMinF = -90 ;-- declination
  res@trYMaxF = 90

  ;** Marker Resources
  res@xyMarkLineMode = "Markers"
  res@xyMarkerThicknessF = 3
  res@xyMonoMarkerColor = False
  res@xyMarkerColors = colors(:)
  res@xyMarkers = (/9,7,6,5,4,3,2,15/)
  ;-- don't forget to address different marker sizes

  res@tiMainString = "Star Catalog"
  res@tiXAxisString = "Right Ascension [hr]
  res@tiYAxisString = "Declination [deg]"

end


;-- You left off at figuring out how to control marker sizes based on magnitude
;-- Refer to scatter plot example 7
