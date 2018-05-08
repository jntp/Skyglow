load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"


;** Start by creating a function for adding grid labels to the "map"
function add_mollweide_labels(wks, map, decspc, raspc)
local dec_values, ra_values, ndec, nra, txres, dum_lft, dum_rgt, dum_cen
begin
  mindec = -90
  maxdec = 90
  minra = 0
  maxra = 360

  ;** Pick some "nice" values for the declination labels
  dec_values = ispan(mindec, maxdec, decspc) * 1. ;-- multiply by 1. to create float array
  ra_values = ispan(minra, maxra, raspc) * 1. 
  ndec = dimsizes(dec_values)
  nra = dimsizes(ra_values)

  ;** Set some text resources
  txres = True
  txres@txFontHeightF = 0.01

  ;** Create dummy arrays to hold attached strings
  dum_lft = new(ndec, graphic)
  dum_rgt = new(ndec, graphic)

  ;** Create the labels
  ;* Declination
  dec_lft_label = where(dec_values .gt. 0, "+" + dec_values, dec_values) ;-- add a '+' sign to declinations greater than zero
  dec_lft_label = where(abs(dec_values) .eq. 90, "", dec_lft_label) ;-- no label at -90 or +90 degrees
  dec_rgt_label = "  " + dec_lft_label ;-- add space before the right labels
  dec_lft_label = dec_lft_label + "  " ;-- add space after the left labels

  ;** Loop through dec values and attach labels to left and right edges of plot
  do i=0, ndec - 1
    ;* Left Label
    txres@txJust = "CenterRight"
    dum_lft(i) = gsn_add_text(wks, map, dec_lft_label(i), minra, dec_values(i), txres)

    ;* Right Label
    txres@txJust = "CenterLeft"
    dum_rgt(i) = gsn_add_text(wks, map, dec_rgt_label(i), maxra, dec_values(i), txres)
  end do

  ;* Right Ascension
  ra_cen_label = where(ra_values .eq. 180 .or. ra_values .eq. 360, "", ra_values) ;-- no label at 0 or 360 degrees

  dum_cen = new(nra, graphic)

  ;** Loop through the ra values and attach labels to top and bottom edges of plot
  do i=0, nra - 1
    txres@txJust = "CenterCenter"
    dum_cen(i) = gsn_add_text(wks, map, ra_cen_label(i), ra_values(i), minra, txres)
  end do

  ;** Make sure these IDs "live" outside this function
  map@dumlft = dum_lft
  map@dumrgt = dum_rgt
  map@dumcen = dum_cen

  return(map)
end


;** Begin main code
begin

  ;** Read in netCDF files
  scat = addfile("scat.nc", "r")
  
  ;** Read in data required for plotting
  ra = scat->ra2000 ;-- right ascension
  dec = scat->dec2000 ;-- declination
  mag = scat->mag ;-- stellar magnitude
  typeClass = scat->typeClass ;-- star type (character)
  starDensity_1D = scat->starDensity ;-- star density (in number of stars per steradian)

  ;** Convert right ascension to degrees longitude
  do i = 0, dimsizes(ra) - 1
    ra(i) = ra(i) * 15 ;-- multiply by 360 degrees/24 hours
  end do

  ;** Create starDensity 2D matrix and transpose the starDensity_1D 1D array to the 2D matrix
  starDensity = new((/35,71/), float) ;-- create 35x71 2D matrix
  
  ;* Create dec_lat and ra_lon variables and its attributes first... to later store as part of starDensity
  dec_lat = new(35, float)
  do i = 0, 34
    dec_lat(i) = -85 + i*5 ;-- (/-85, ... , 85/)
  end do
  dec_lat@long_name = "Declination in units latitude"
  dec_lat@units = "degrees_north"

  ra_lon = new(71, float)
  do i = 0, 70
    ra_lon(i) = 0 + i*5 ;-- (/0, ... , 360/)
  end do
  ra_lon@long_name = "Right ascension in units longitude"
  ra_lon@units = "degrees_east"

  ;* Transpose the starDensity_1D array to a 2D matrix
  do i = 0, 34 ;-- loop through each latitude (declination) index
    do j = 0, 70 ;-- loop through each longitude (right ascension) index
      starDensity(i,j) = starDensity_1D(j + 71*i)    
    end do
  end do

  ;* Assign coordinates and attributes
  starDensity!0 = "lat"
  starDensity!1 = "lon"
  starDensity@long_name = "Star Density"
  starDensity@units = "M_v < X.Y sr~S~-1~N~"  
  starDensity&lat = dec_lat
  starDensity&lon = ra_lon

  ;********** YOU LEFT OFF HERE

  printVarSummary(starDensity)

  ;** Prepare plot
  wks = gsn_open_wks("png", "scat_plot_cont")

  res = True
  res@mpProjection = "Mollweide" ;-- equal area projection
  res@mpGridAndLimbOn = True ;-- turn on lat/lon lines
  res@mpPerimOn = False ;-- turn off box around plot
  res@mpGridLatSpacingF = 30
  res@mpGridLonSpacingF = 30
  res@gsnDraw = False ;-- don't draw plot
  res@gsnFrame = False ;-- don't advance frame 
  res@mpGeophysicalLineColor = "white" ;-- make the map invisible

  ;** Set color map of contour plot
  res@cnFillOn = True
  res@cnFillPalette = "MPL_PuBu" ;-- set color map
  res@cnLineLabelsOn = False ;-- turn off contour lines
  res@cnLevelSelectionMode = "ManualLevels" ;-- set color levels manually
  res@cnLevelSpacingF = 5 ;-- set the interval between the contours

  ;** Specify where the plot goes
  res@vpXF = 0.20
  res@vpYF = 0.90
  res@vpWidthF = 0.65
  res@vpHeightF = 0.65

  ;** Title Resources
  res@tiMainString = "Stars in Night Sky: Present Day"
  ; res@tiXAxisString = "Right Ascension [deg]"
  ; res@tiYAxisString = "Declination [deg]"
  res@tiMainFontHeightF = 0.0225
  ; res@tiXAxisFontHeightF = 0.020
  ; res@tiYAxisFontHeightF = 0.020

  ;** Create the scatter plot
  plot = gsn_csm_contour_map(wks, starDensity, res) ;-- middle value must be 2D array

  ;** Attach grid labels to the plot
  map = add_mollweide_labels(wks, plot, 30, 30)
  draw(plot)
 
  frame(wks)
end

;-- How to add grid labels to your plot?!
;-- Refer to Map Tickmarks example 12 (and maybe 10)
;-- You left off at fixing/adjusting the grid labels
