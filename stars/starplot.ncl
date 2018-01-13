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
  test = typeClass

  ;** Create custom colormap to color in markers
  colors = (/"dodgerblue3", "dodgerblue", "navajowhite", "khaki1", "darkgoldenrod1", "darkorange", "firebrick1", "black"/)

  ;** Prepare plot
  wks = gsn_open_wks("png", "scat_plot")
  ; gsn_define_colormap(wks, colors) ;-- for some reason this turns the whole thing blue (FIX THIS PLEASE)

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
  res@xyMarkerColors = "white" ;-- purposely make markers invisible (for right now)

  ;** Put Tickmark resources options here (if needed)

  ;** Title Resources
  res@tiMainString = "Stars in Night Sky: Present Day"
  res@tiXAxisString = "Right Ascension [hr]"
  res@tiYAxisString = "Declination [deg]"
  res@tiMainFontHeightF = 0.0225
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020

  ;** Create the scatter plot
  plot = gsn_csm_xy(wks, ra(0:4), dec(0:4), res)
  draw(plot)

  starMag = (/-2, -1, 0, 1, 2, 3, 4, 5, 6/)
  markerSizes = (/3, 2, 1, 0.008, 0.007, 0.006, 0.005, 0.004/)
  labels  = (/"O", "B", "A", "F", "G", "K", "M", "+"/)

  newMarkers = True
  newMarkers@gsMarkerThicknessF = 3

  begin
    do i = 0, 2 ;-- loop through starMag array
      base = ind(mag .ge. starMag(i) .and. mag .lt. starMag(i+1)) ;-- find indices of given stellar magnitude threshold
      firstIndex = base(0)
      last = dimsizes(base) - 1 ;-- get last value of base array
      lastIndex = base(last)

      newMarkers@gsMarkerSizeF = markerSizes(i) 

      ;** For class "O"
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "O") ;-- find the indices of a spectral class "O"
      if (.not. ismissing(matches(0))) then ;-- check for no matches at all
        newMarkers@gsMarkerColor = colors(0)
        newMarkers@gsMarkerIndex = 9 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) ;-- draws new markers of spectral class "O"
        delete(raMatching) ;-- delete to avoid dimensionality errors
        delete(decMatching)
      end if
      delete(matches)

      ;** For class "B"
      print(typeClass(firstIndex:lastIndex))
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "B")
      print(matches)
      if (.not. ismissing(matches(0))) then
        print("RUNNING")
        newMarkers@gsMarkerColor = colors(1)
        newMarkers@gsMarkerIndex = 7 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers)
        delete(raMatching)
        delete(decMatching)
      end if     
      delete(matches)

      ;** For class "A"
      ; print(test(firstIndex:lastIndex))
      ; substr = "A"
      ; matches = str_index_of_substr(test(firstIndex:lastIndex), substr, 0)
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "A")
      ; print(matches)
      if (.not. ismissing(matches(0))) then
        newMarkers@gsMarkerColor = colors(2)
        newMarkers@gsMarkerIndex = 6 ;-- marker type
        raMatching = ra(matches(:))
        decMatching = dec(matches(:))
        gsn_polymarker(wks, plot, raMatching, decMatching, newMarkers) 
        delete(raMatching)
        delete(decMatching)       
      end if
      delete(matches)

      ;** For class "F"
      ; print(typeClass(firstIndex:lastIndex))
      matches = ind(typeClass(firstIndex:lastIndex) .eq. "F")
      ; print(matches)
      if (.not. ismissing(matches(0))) then
        print("RUNNING HERE")
        newMarkers@gsMarkerColor = colors(3)
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
        newMarkers@gsMarkerColor = colors(4)
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
        newMarkers@gsMarkerColor = colors(5)
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
        newMarkers@gsMarkerColor = colors(6)
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
        newMarkers@gsMarkerColor = colors(7)
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


;-- Refer to scatter plot example 7
;-- Look into gsn_polymarker
;-- Why are all markers the same size? Fix problem with marker sizes....
