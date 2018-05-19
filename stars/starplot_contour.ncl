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
  starDensity@long_name = "Star Density [# (M~B~v~N~ < 6.0) sr~S~-1~N~]"
  starDensity@units = "N = 5104"
  starDensity&lat = dec_lat
  starDensity&lon = ra_lon

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


;** Make new netcdf file

begin

  ;** Declare file names
  diri = "./"
  outfile = "scat2D.ncl"

  ;** Make sure outfile does not exist
  if (isfilepresent(outfile)) then
    system("rm -rf " + outfile) ;-- delete file if exists
  end if

  ;** Get the dimensions and dimension sizes of the variables to be written out
  nra_star = dimsizes(ra)
  ndec_star = dimsizes(dec)
  nmag = dimsizes(mag)
  ntypeClass = dimsizes(typeClass)
  ndec_lat = dimsizes(dec_lat)
  nra_lon = dimsizes(ra_lon)
  nstarDensity = dimsizes(starDensity)

  ;** Create new netCDF file
  fout = addfile(outfile, "c")

  ;** Begin Output File Settings
  setfileoption(fout, "DefineMode", True) ;-- explicitly declare file

  ;** Create Global Attributes of the File
  fAtt = True ;-- assign file attributes
  fAtt@title = "SAO Star Catalog"
  fAtt@source_file = scat
  fAtt@Conventions = "None"
  fAtt@creation_date = systemfunc ("date")
  fileattdef( fout, fAtt) ;-- copy file attributes

  ;** Predefine the coordinate variables and their dimensionality
  

end 

;-- Refer to applications/method_2.shtml (attainable by googling "ncl writing to existing netcdf file")
;-- See ncl guide as well
;-- You left off creating the new netcdf file
