load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"


begin

  ;** Make/declare variables here?
  str_names = (/"0.00", "0.01", "0.02", "0.03", "0.04", "0.05", "0.06", "0.07", "0.08", "0.09", "0.10", "0.11", "0.12", "0.13", "0.14", "0.15", "0.16", "0.17", "0.18", "0.19", "0.20", "0.21", "0.21", "0.22", "0.23", "0.24", "0.25", "0.26", "0.27", "0.28", "0.29", "0.30"/)
  oda = new(32, float)
  odb = new(32, float)
  odc = new(32, float)
  
  lmn_oda = new(32, float)
  lmn_odb = new(32, float)
  lmn_odc = new(32, float)

  ;** Add data to oda, odb, and odc arrays
  do i=0,31
    ;** Read in netCDF files
    input_str_oda = "skg_swn_urb_oda_" + str_names(i) + ".nc"
    input_str_odb = "skg_swn_urb_odb_" + str_names(i) + ".nc"
    input_str_odc = "skg_swn_urb_odc_" + str_names(i) + ".nc"

    file_oda = addfile(input_str_oda, "r") 
    file_odb = addfile(input_str_odb, "r") 
    file_odc = addfile(input_str_odc, "r") 

    ;** Read in data required for calculation
    ;* Compute odxc (odxc_obs_aer + odxc_obs_bga), which will represent the x-axis
    odxc_aer_oda = file_oda->odxc_obs_aer
    odxc_aer_odb = file_odb->odxc_obs_aer
    odxc_aer_odc = file_odc->odxc_obs_aer

    odxc_bga_oda = file_oda->odxc_obs_bga
    odxc_bga_odb = file_odb->odxc_obs_bga
    odxc_bga_odc = file_odc->odxc_obs_bga

    odxc_oda = odxc_aer_oda + odxc_bga_oda
    odxc_odb = odxc_aer_odb + odxc_bga_odb
    odxc_odc = odxc_aer_odc + odxc_bga_odc

    ;* Get lmn_bb_aa_ndr_sfc, which will represent the y-axis
    lmn_data_oda = file_oda->lmn_bb_aa_ndr_sfc
    lmn_data_odb = file_odb->lmn_bb_aa_ndr_sfc
    lmn_data_odc = file_odc->lmn_bb_aa_ndr_sfc

    ;** Hard-code data into arrays
    oda(i) = odxc_oda
    odb(i) = odxc_odb
    odc(i) = odxc_odc

    lmn_oda(i) = lmn_data_oda
    lmn_odb(i) = lmn_data_odb
    lmn_odc(i) = lmn_data_odc
  end do

  ;** Create x and y and name attributes
  x = (/oda, odb, odc/) 
  x@long_name = "Total column aerosol extinction optical depth"
  x@units = "fraction"

  y = (/lmn_oda, lmn_odb, lmn_odc/)

  ;** Convert units for better readability
  y = y * 1000 ;-- convert to millicandelas per meter squared
  y@units = "millicandela meter-2"

  ;** Prepare plot
  wks = gsn_open_wks("png", "skg_lmn_znt_ov")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Urban Brightness Sensitivity Tests"
  res@tiXAxisString = "Aerosol Extinction Optical Depth [fraction]" 
  res@tiYAxisString = "Zenith-viewing Luminance [mcd m~S~-2~N~]"
  res@tiMainFontHeightF = 0.025
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@xyLineThicknessF = 5
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"blue", "green", "black"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Create a legend
  res@pmLegendDisplayMode = "Always" ;-- turn on legend
  res@pmLegendSide = "Top" ;-- position of legend (what side)

  res@pmLegendParallelPosF = 0.81 ;-- move units right
  res@pmLegendOrthogonalPosF = -0.95 ;-- move units down

  res@lgPerimOn = False ;-- turn off legend perimeter
  res@pmLegendWidthF = 0.11
  res@pmLegendHeightF = 0.14
  res@lgLabelFontHeightF = 0.020
  res@xyExplicitLegendLabels = (/"  oda", "  odb", "  odc" /)
  res@lgItemOrder = (/2, 1, 0/) ;-- reorder items on legend

  ;** Make the plot
  plot = gsn_csm_xy(wks, x, y, res) ;-- draw a pressure/height plot  

  draw(plot)
  frame(wks)

end
