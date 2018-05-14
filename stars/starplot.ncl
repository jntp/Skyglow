load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"


;** Start by creating a function for adding grid labels to the "map"
function add_mollweide_labels(wks, map, decspc, raspc)
local ra_values, nra, txres, dum_cen
begin
  minra = 0
  maxra = 360

  ;** Pick some "nice" values for the declination labels
  ra_values = ispan(minra, maxra, raspc) * 1. 
  nra = dimsizes(ra_values)

  ;** Set some text resources
  txres = True
  txres@txFontHeightF = 0.01

  ;* Right Ascension
  ;** Create the labels
  ra_cen_label = where(ra_values .eq. 180 .or. ra_values .eq. 360, "", ra_values + "~S~o~N") ;-- no label at 0 or 360 degrees

  ;** Create dummy arrays to hold attached strings
  dum_cen = new(nra, graphic)

  ;** Loop through the ra values and attach labels to top and bottom edges of plot
  do i=0, nra - 1
    txres@txJust = "CenterCenter"
    dum_cen(i) = gsn_add_text(wks, map, ra_cen_label(i), ra_values(i), minra, txres)
  end do

  ;** Make sure these IDs "live" outside this function
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
  starDensity@long_name = "Star Density [# (M_v < 6.0) sr~S~-1~N~]"
  starDensity@units = "N = 5104"  
  starDensity&lat = dec_lat
  starDensity&lon = ra_lon

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

  starMag = (/-2, -1, 0, 1, 2, 3, 4, 5, 6/)
  markerSizes = (/0.020, 0.0175, 0.015, 0.0125, 0.010, 0.0075, 0.005, 0.0025/)
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 9
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 7
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 6
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 5
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 4
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 3
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 2
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
        newMarkers@gsMarkerIndex = 3 ;-- marker type 15
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
  ; txres@txFontHeightF = 0.018
  ; txres@txJust = "CenterLeft"

  ; gsn_text_ndc(wks, "Spectral Class:", 0.09, 0.10, txres) ;-- add a headline that says "Spectral Class:"

  do i = 0, 7 ;-- assign attributes for each marker label
    mkres@gsMarkerThicknessF = 4

    mkres@gsMarkerSizeF = 0.025
    mkres@gsMarkerColor = "firebrick2"
    mkres@gsMarkerIndex = markers(i) 

    ; gsn_polymarker_ndc(wks, xpos(i), 0.06, mkres) ;-- Add markers to legend 
    ; gsn_text_ndc(wks, labels(i), xpos2(i), 0.06, txres) ;-- Add text (that specify the markers) to legend
  end do
 
  frame(wks)
end

;-- How to add grid labels to your plot?!
;-- Refer to Map Tickmarks example 12 (and maybe 10)
;-- You left off at testing and debugging the script
