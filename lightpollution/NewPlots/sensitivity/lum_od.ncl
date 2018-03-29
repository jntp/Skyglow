load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

;** Make scatter plot
;** Every oda, odb, odc file will have one point

begin

  ;** Make/declare variables here?
  str_names = (/"0.00", "0.01", "0.02", "0.03", "0.04", "0.05", "0.06", "0.07", "0.08", "0.09", "0.10", "0.11", "0.12", "0.13", "0.14", "0.15",
                "0.16", "0.17", "0.18", "0.19", "0.20", "0.21", "0.21", "0.22", "0.23", "0.24", "0.25", "0.26", "0.27", "0.28", "0.29", "0.30"/)

  do i=0,30
    ;** Read in netCDF files
    input_str_oda = "skg_swn_urb_oda_" + str_names(i)
    input_str_odb = "skg_swn_urb_odb_" + str_names(i)
    input_str_odc = "skg_swn_urb_odc_" + str_names(i)

    file_oda = addfile(input_str_oda, "r") 
    file_odb = addfile(input_str_odb, "r") 
    file_odc = addfile(input_str_odc, "r") 

    ;** Read in data required for calculation
    ;* Compute odxc (odxc_obs_aer + odxc_obs_bga), which will represent the x-axis
    odxc_aer_oda = file_oda->odxc_obs_aer
    odxc_aer_odb = file_odb->odxc_obs_aer
    odxc_aer_odc = file_odc->odxc_obs_aer

    odxc_bga_oda = file_oda->odxc_obs_bga

  levp = oda->levp(:) ;-- pressure coordinates (y axis)

  x_dim = dimsizes(levp) ;-- get dimensions for a multidimensional array containing control and experiment values 

  ;** Hard-code data
  oda = (/5, 5, 5/)
  odb = (/5, 5, 5/)
  odc = (/5, 5, 5/)

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = (/oda_ndr, odb_ndr, odc_ndr/) 
  x@long_name = "Broadband azimuthally averaged luminance towards nadir"
  x!0 = "conditions"
  x!1 = "luminance"

  ;** Convert units for better readability
  x = x * 1000 ;-- convert to millicandelas per meter squared
  x@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal" 

  ;** Prepare plot
  wks = gsn_open_wks("png", "skg_lmn_znt_ov.png")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Urban Night Sky Brightness (Optical Depth: +0.05)"
  res@tiXAxisString = "Zenith-viewing Luminance [mcd m~S~-2~N~]"
  res@tiYAxisString = "Pressure [mb]"
  res@tiMainFontHeightF = 0.025
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 0 ;-- y axis minimum value
  res@trYMaxF = 1000 ;-- y axis maximum value

  ;-- NOTE... FOR URBAN AREAS, CHOOSE BETWEEN 0 and 2.8
  ;-- FOR REMOTE, CHOOSE BETWEEN 0.164 and 0.174
  res@trXMinF = 0 ;-- x axis minimum value
  res@trXMaxF = 2.8 ;-- x axis maximum value
  
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"blue", "green", "black"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Create a legend
  res@pmLegendDisplayMode = "Always" ;-- turn on legend
  res@pmLegendSide = "Top" ;-- position of legend (what side)

  ;-- NOTE... FOR URBAN AREAS, CHOOSE 0.73 for ParallelPos and -0.38 for OrthogonalPos
  ;-- FOR REMOTE, CHOOSE 0.24 for ParallelPos and -0.34 for OrthogonalPos
  res@pmLegendParallelPosF = 0.73 ;-- move units right
  res@pmLegendOrthogonalPosF = -0.38 ;-- move units down

  res@lgPerimOn = False ;-- turn off legend perimeter
  res@pmLegendWidthF = 0.11
  res@pmLegendHeightF = 0.14
  res@lgLabelFontHeightF = 0.020
  res@xyExplicitLegendLabels = (/"  oda", "  odb", "  odc" /)
  res@lgItemOrder = (/2, 1, 0/) ;-- reorder items on legend

  ;** Make the plot
  plot = gsn_csm_xy(wks, x, levp, res) ;-- draw a pressure/height plot  

  draw(plot)
  frame(wks)

end

;-- You left off on the do loop. Reading in data (odxc) for calculations
