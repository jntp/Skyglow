load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"


;** Start by creating a function for adding grid labels to the "map"
function add_mollweide_labels(wks, map, decspc, raspc)
local dec_values, ra_values, ndec, nra, txres, dum_lft, dum_rgt, dum_bot
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
  dec_rgt_label = "  " + dec_rgt_label ;-- add space before the right labels
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
  ra_bot_label = ra_values
  ra_bot_label = where(ra_values .eq. 0 .or. ra_values .eq. 360, "", ra_bot_label) ;-- no label at 0 or 360 degrees

  dum_top = new(nra, graphic)
  dum_bot = new(nra, graphic)

  ;** Loop through the ra values and attach labels to top and bottom edges of plot
  do i=0, nra - 1
    ;* Top Label
    txres@txJust = "BottomCenter"
    dum_top(i) = gsn_add_text(wks, map, ra_bot_label(i), ra_values(i), minra, txres)
  
    ;* Bottom Label
    txres@txJust = "TopCenter"
    dum_bot(i) = gsn_add_text(wks, map, ra_bot_label(i), ra_values(i), minra, txres)
  end do

  ;** Make sure these IDs "live" outside this function
  map@dumlft = dum_lft
  map@dumrgt = dum_rgt
  map@dumtop = dum_top
  map@topbot = dum_bot

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
  wks = gsn_open_wks("png", "scat_plot_proj")

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

  ;** Specify where the plot goes
  res@vpXF = 0.20
  res@vpYF = 0.90
  res@vpWidthF = 0.65
  res@vpHeightF = 0.65

  ;** Title Resources
  res@tiMainString = "Stars in Night Sky: Present Day"
  res@tiXAxisString = "Right Ascension [deg]"
  res@tiYAxisString = "Declination [deg]"
  res@tiMainFontHeightF = 0.0225
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020

  ;** Create the scatter plot
  plot = gsn_csm_contour_map(wks, starDensity, res) ;-- middle value must be 2D array
  draw(plot)

  starMag = (/-2, -1, 0, 1, 2, 3, 4, 5, 6/)
  markerSizes = (/0.040, 0.035, 0.030, 0.025, 0.020, 0.015, 0.010, 0.005/)
  labels  = (/"O", "B", "A", "F", "G", "K", "M", "+"/)

  newMarkers = True
  newMarkers@gsMarkerThicknessF = 3
  newMarkers@gsMarkerColor = "firebrick2"

  begin
    do i = 0, 7 ;-- loop through starMag array
      base = ind(mag .ge. starMag(i) .and. mag .lt. starMag(i+1)) ;-- find indices of given stellar magnitude threshold
      firstIndex = base(0)
      last = dimsizes(base) - 1 ;-- get last value of base array
      lastIndex = base(last)

      newMarkers@gsMarkerSizeF = markerSizes(i) 

      ;** For class "O"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "O") ;-- find the indices of a spectral class "O"
      if (.not. ismissing(matches(0))) then ;-- check for no matches at all 
        newMarkers@gsMarkerIndex = 9 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) ;-- draws new markers of spectral class "O"
        delete(raMatching) ;-- delete to avoid dimensionality errors
        delete(decMatching)
      end if
      delete(matches)

      ;** For class "B"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "B")
      if (.not. ismissing(matches(0))) then 
        newMarkers@gsMarkerIndex = 7 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers)
        delete(raMatching)
        delete(decMatching)
      end if     
      delete(matches)

      ;** For class "A"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "A")
      if (.not. ismissing(matches(0))) then 
        newMarkers@gsMarkerIndex = 6 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)       
      end if
      delete(matches)

      ;** For class "F"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "F")
      if (.not. ismissing(matches(0))) then 
        newMarkers@gsMarkerIndex = 5 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)     
      end if
      delete(matches)

      ;** For class "G"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "G")
      if (.not. ismissing(matches(0))) then 
        newMarkers@gsMarkerIndex = 4 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)     
      end if
      delete(matches)
     
      ;** For class "K"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "K")
      if (.not. ismissing(matches(0))) then
        newMarkers@gsMarkerIndex = 3 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)     
      end if
      delete(matches)

      ;** For class "M"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "M")
      if (.not. ismissing(matches(0))) then 
        newMarkers@gsMarkerIndex = 2 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)     
      end if
      delete(matches)

      ;** For class "+"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "+")
      if (.not. ismissing(matches(0))) then 
        newMarkers@gsMarkerIndex = 15 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)
      end if
      delete(matches)

      delete(base) ;-- delete array to avoid dimensionality errors on next iteration
    end do
  end

  ;** Draw the labels (bottom legend) 
  markers = (/    9,    7,    6,    5,    4,    3,    2,   15/)
  xpos    = (/ 0.10, 0.21, 0.32, 0.43, 0.54, 0.65, 0.76, 0.87/)  ;-- you will probably have to change this later
  xpos2   = (/ 0.13, 0.24, 0.35, 0.46, 0.57, 0.68, 0.79, 0.90/)

  mkres = True ;-- marker resources
  txres = True ;-- text resources
  txres@txFontHeightF = 0.018
  txres@txJust = "CenterLeft"

  gsn_text_ndc(wks, "Spectral Class:", 0.09, 0.10, txres) ;-- add a headline that says "Spectral Class:"

  do i = 0, 7 ;-- assign attributes for each marker label
    mkres@gsMarkerThicknessF = 4

    mkres@gsMarkerSizeF = 0.025
    mkres@gsMarkerColor = "firebrick2"
    mkres@gsMarkerIndex = markers(i) 

    gsn_polymarker_ndc(wks, xpos(i), 0.06, mkres) ;-- Add markers to legend 
    gsn_text_ndc(wks, labels(i), xpos2(i), 0.06, txres) ;-- Add text (that specify the markers) to legend
  end do
 
  ;** Attach grid labels to the plot
  map = add_mollweide_labels(wks, plot, 30, 30)

  frame(wks)
end

;-- How to add grid labels to your plot?!
;-- Refer to Map Tickmarks example 12 (and maybe 10)
;-- You left off at testing and debugging the script
