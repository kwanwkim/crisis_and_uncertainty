*Project: Crisis and Uncertainty: Did the Great Recession Reduce the Diversity of Faculty?

*Author: Kwan Woo Kim (kwanwookim@g.harvard.edu)
*Created: 4/4/2020
*Updated: 5/10/2021
*Additional annotations: 6/15/2023

/*This .do file achieves the following tasks.
1. Produces the following descriptive plots
Figures 1, 3, 5
*/

cap frame create descriptives, change
frame change descriptives
clear

global datadir "/Users/kwan/Documents/Google Drive/Projects/Universities/Team folders/Universities Project/Recession and Diversity/Post acceptance/Replication_Github/Data/"
global outputdir "/Users/kwan/Documents/Google Drive/Projects/Universities/Team folders/Universities Project/Recession and Diversity/Post acceptance/Replication_Github/Tables and figures"


use "${datadir}/Crisis_and_uncertainty_descriptives.dta",clear
cd "${outputdir}"
*Tag one observation per each combination of year, Carnegie group, and institutional control
capture egen tag = tag(year carngr control)

set scheme s2manual

*Figure 1, Total new tenure-track hires by institutional control
**Whole sample
capture drop mlabvpos
egen mlabvpos = mlabvpos(totalttont year) if tag == 1, matrix(1 12 12 12 11 \\ 1 12 12 12 11\\ 1 12 12 12 11 \\ 5 6 6 6 7 \\ 5 6 6 6 7)

graph twoway (connected totalttont year if tag == 1, lcolor("248 193 23") lwidth(medthick) sort mlabel(totalttont) mlabposition(12) mlabgap(small) mlabcolor("248 193 23") mlabsize(small) msymbol(i) mlabformat(%9.0fc)) (connected totalttont_ctrl year if tag == 1 & control == 1, lcolor("41 47 116") msymbol(i) mlabformat(%9.0fc) lwidth(medthick) sort mlabel(totalttont_ctrl) mlabposition(12) mlabgap(small) mlabcolor("41 47 116") mlabsize(small)) (connected totalttont_ctrl year if tag == 1 & control == 2, lcolor(red) msymbol(i) mlabformat(%9.0fc) lwidth(medthick) sort mlabel(totalttont_ctrl) mlabposition(6) mlabgap(small) mlabcolor(red) mlabsize(small)), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(0)) ytitle("Tenure-track hires") xtitle("Academic year") legend(order(1 "All" 2 "Public" 3 "Private") rows(1) pos(6)) ylabel(0(4000)16000,labsize(small)) ymtick(0(1000)16000) yline(13677.4, lpattern("dash") lwidth("medium") lcolor("248 193 23")) yline(8683.8, lpattern("dash") lwidth("medium") lcolor("41 47 116")) yline(4993.6, lpattern("dash") lwidth("medium") lcolor("red"))
graph save Figure1.gph,replace
graph export Figure1.eps, logo(off) cmyk(off) replace
*graph export Figure1_cmyk.eps, logo(off) cmyk(on) replace
*Figure 2, Total new tenure-track hires by Carnegie (R1/R2+MA/BA)
**Whole sample
graph twoway (connected totalttont_carn year if tag == 1 & carngr == 1, lcolor("41 47 116") msymbol(i) mlabformat(%9.0fc) lwidth(medthick) sort mlabel(totalttont_carn) mlabposition(12) mlabgap(*1.8) mlabcolor("41 47 116") mlabsize(small)) (connected totalttont_carn year if tag == 1 & carngr == 2, lcolor(red) msymbol(i) mlabformat(%9.0fc) lwidth(medthick) sort mlabel(totalttont_carn) mlabposition(12) mlabgap(small) mlabcolor(red) mlabsize(small)) (connected totalttont_carn year if tag == 1 & carngr == 3, lcolor("248 193 23") msymbol(i) mlabformat(%9.0fc) lwidth(medthick) sort mlabel(totalttont_carn) mlabposition(12) mlabgap(small) mlabcolor("248 193 23") mlabsize(small)), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(0)) ytitle("Tenure-track hires") xtitle("Academic year") legend(order(1 "R1" 2 "R2/MA" 3 "BA") row(1)) ylabel(0(2000)8000,labsize(small) nogrid) yline(5069.8, lpattern("dash") lwidth("vthin") lcolor("41 47 116")) yline(6695, lpattern("dash") lwidth("vthin") lcolor("red")) yline(1912.6, lpattern("dash") lwidth("vthin") lcolor("248 193 23"))
graph save Figure2.gph,replace
graph export Figure2.eps, logo(off) cmyk(off) replace
graph export Figure2_cmyk.eps, logo(off) cmyk(on) replace


*Figure 3, New tenure-track hires by control and demographic group
capture drop *_yhat
*Tabulate predicted total new hires by group
foreach g in fw fb fh fa mw mb mh ma {
	reg total`g'ont_ctrl year if year < 2009 & control == 1
	predict `g'1, xb
	reg total`g'ont_ctrl year if year < 2009 & control == 2
	predict `g'2, xb
}
version 16: table year if inlist(year, 2007, 2009), c(mean fw1 mean fb1 mean fh1 mean fa1)
version 16: table year if inlist(year, 2007, 2009), c(mean mw1 mean mb1 mean mh1 mean ma1)

version 16: table year if inlist(year, 2007, 2009), c(mean fw2 mean fb2 mean fh2 mean fa2)
version 16: table year if inlist(year, 2007, 2009), c(mean mw2 mean mb2 mean mh2 mean ma2)


capture drop *_yhat
foreach g in fw fb fh fa mw mb mh ma {
	foreach s in ont {
		reg total`g'ont_ctrl year if year < 2009 & control == 1
		predict `g'ont_c1_yhat, xb 
		reg total`g'ont_ctrl year if year < 2009 & control == 2
		predict `g'ont_c2_yhat, xb 
		format *ont_c1_yhat *ont_c2_yhat %9.0fc
			
		if  "`g'" == "fw" { 
			local ytitle = "White women"
			graph twoway (connected total`g'`s'_ctrl year if tag == 1 & control == 1, msymbol(i) lcolor(blue) lwidth(medium) sort mlabel(total`g'`s'_ctrl) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_ctrl year if tag == 1 & control == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid)  sort mlabel(total`g'`s'_ctrl) mlabposition(6) mlabcolor(red) mlabsize(vsmall)) (connected `g'ont_c1_yhat year if tag == 1 & year >= 2007 & control == 1, lcolor(blue) lpattern(dash) msymbol(i) sort) (connected `g'ont_c2_yhat year if tag == 1 & year >= 2007 & control == 2, lcolor(red) lpattern(dash) msymbol(i) sort)    , xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_ctrl.gph, replace) ylabel(0(1000)3000,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "Public" 2 "Private") size(small))
		}
		else if "`g'" == "mw" {
			local ytitle = "White men"
			graph twoway (connected total`g'`s'_ctrl year if tag == 1 & control == 1, msymbol(i) lcolor(blue) lwidth(medium) sort mlabel(total`g'`s'_ctrl) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_ctrl year if tag == 1 & control == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid)  sort mlabel(total`g'`s'_ctrl) mlabposition(6) mlabcolor(red) mlabsize(vsmall)) (connected `g'ont_c1_yhat year if tag == 1 & year >= 2007 & control == 1, lcolor(blue) lpattern(dash) msymbol(i) sort) (connected `g'ont_c2_yhat year if tag == 1 & year >= 2007 & control == 2, lcolor(red) lpattern(dash) msymbol(i) sort)    , xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_ctrl.gph, replace) ylabel(0(1000)4000,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "Public" 2 "Private") size(small))
		}
		else if "`g'" == "fa" | "`g'" == "ma" {
			if  "`g'" == "fa" { 
				local ytitle = "Asian-American women"
			}
			if  "`g'" == "ma" { 
				local ytitle = "Asian-American men"
			}
		graph twoway (connected total`g'`s'_ctrl year if tag == 1 & control == 1, msymbol(i) lcolor(blue) lwidth(medium) sort mlabel(total`g'`s'_ctrl) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_ctrl year if tag == 1 & control == 2, msymbol(i) lcolor(red) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_ctrl) mlabposition(6) mlabcolor(red) mlabsize(vsmall))(connected `g'ont_c1_yhat year if tag == 1 & year >= 2007 & control == 1, lcolor(blue) lpattern(dash) msymbol(i) sort) (connected `g'ont_c2_yhat year if tag == 1 & year >= 2007 & control == 2, lcolor(red) lpattern(dash) msymbol(i) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_ctrl.gph, replace) ylabel(0(200)600,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "Public" 2 "Private") size(small))
		}
		else if  "`g'" == "fb" { 
			local ytitle = "Black women"
			graph twoway (connected total`g'`s'_ctrl year if tag == 1 & control == 1, msymbol(i) lcolor(blue) lwidth(medium) sort mlabel(total`g'`s'_ctrl) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_ctrl year if tag == 1 & control == 2, msymbol(i) lcolor(red) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_ctrl) mlabposition(6) mlabcolor(red) mlabsize(vsmall)) (connected `g'ont_c1_yhat year if tag == 1 & year >= 2007 & control == 1, lcolor(blue) lpattern(dash) msymbol(i) sort) (connected `g'ont_c2_yhat year if tag == 1 & year >= 2007 & control == 2, lcolor(red) lpattern(dash) msymbol(i) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_ctrl.gph, replace) ylabel(0(100)400,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(off)
			}
		else if  "`g'" == "mb" { 
			local ytitle = "Black men"		
			graph twoway (connected total`g'`s'_ctrl year if tag == 1 & control == 1, msymbol(i) lcolor(blue) lwidth(medium) sort mlabel(total`g'`s'_ctrl) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_ctrl year if tag == 1 & control == 2, msymbol(i) lcolor(red) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_ctrl) mlabposition(6) mlabcolor(red) mlabsize(vsmall)) (connected `g'ont_c1_yhat year if tag == 1 & year >= 2007 & control == 1, lcolor(blue) lpattern(dash) msymbol(i) sort) (connected `g'ont_c2_yhat year if tag == 1 & year >= 2007 & control == 2, lcolor(red) lpattern(dash) msymbol(i) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_ctrl.gph, replace) ylabel(0(100)300,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(off)
		}
		else if "`g'" == "fh" | "`g'" == "mh" {
		if  "`g'" == "fh" { 
			local ytitle = "Hispanic women"
		}
		if  "`g'" == "mh" { 
				local ytitle = "Hispanic men"
		}		
		graph twoway (connected total`g'`s'_ctrl year if tag == 1 & control == 1, msymbol(i) lcolor(blue) lwidth(medium) sort mlabel(total`g'`s'_ctrl) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_ctrl year if tag == 1 & control == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid) sort mlabel(total`g'`s'_ctrl) mlabposition(6) mlabcolor(red) mlabsize(vsmall)) (connected `g'ont_c1_yhat year if tag == 1 & year >= 2007 & control == 1, lcolor(blue) lpattern(dash) msymbol(i) sort) (connected `g'ont_c2_yhat year if tag == 1 & year >= 2007 & control == 2, lcolor(red) lpattern(dash) msymbol(i) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_ctrl.gph, replace) ylabel(0(50)200,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(off)
		}
	}
}

grc1leg "totalmwont_ctrl.gph" "totalfwont_ctrl.gph" "totalmbont_ctrl.gph" "totalfbont_ctrl.gph" "totalmhont_ctrl.gph" "totalfhont_ctrl.gph" "totalmaont_ctrl.gph" "totalfaont_ctrl.gph", l1("Tenure-track hires", size(small)) b1("Academic year", size(small)) legendfrom("totalfwont_ctrl.gph") ring(6) rows(4) imargin(tiny) iscale(0.6)
graph display Graph, ysize(12) xsize(8)
graph save Figure3_alt.gph,replace
graph export Figure3_alt.eps, logo(off) cmyk(on) replace

*Figure 5, New tenure-track hires by Carnegie and demographic group
capture drop *_yhat
foreach g in fw fb fh fa mw mb mh ma {
	foreach s in ont {
		reg total`g'ont_carn year if year < 2009 & carngr == 1
		predict `g'ont_carn1_yhat, xb 
		reg total`g'ont_carn year if year < 2009 & carngr == 2
		predict `g'ont_carn2_yhat, xb 
		reg total`g'ont_carn year if year < 2009 & carngr == 3
		predict `g'ont_carn4_yhat, xb 
		format *ont_carn*_yhat %9.0f
		if  "`g'" == "fw" { 
			local ytitle = "White women"
			graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium) lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(red) mlabsize(vsmall))   (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange)lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall)) (connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(6) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) , xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(700)2800,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "R1" 2 "R2/MA" 3 "BA") size(small) rows(1))
		}
		else if "`g'" == "mw" {
			local ytitle = "White men"
			graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(red) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange)lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall))	(connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(700)2800,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "R1" 2 "R2/MA" 3 "BA") size(small))
		}
		else if "`g'" == "fa" {
			local ytitle = "Asian-American women"
			graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(red) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange) lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall))	(connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange%70) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(100)500,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "R1" 2 "R2/MA" 3 "BA") size(small))
		}
		else if "`g'" == "ma" {
			local ytitle = "Asian-American men"
			graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(red) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange) lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall))	(connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(100)500,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(order(1 "R1" 2 "R2/MA" 3 "BA") size(small))
		}
	
		else if  "`g'" == "fb" { 
			local ytitle = "Black women"
			graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium) lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(red) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange) lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall))	(connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort)	(connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(50)300,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(off)

		}
		else if  "`g'" == "mb" { 
			local ytitle = "Black men"
			graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium) lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium) lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(red) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange) lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall))	(connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort)	(connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(50)250,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(off)
		}		
		else if "`g'" == "fh" | "`g'" == "mh" {
		if  "`g'" == "fh" { 
			local ytitle = "Hispanic women"
		}
		if  "`g'" == "mh" { 
				local ytitle = "Hispanic men"
		}		
		graph twoway (connected total`g'`s'_carn year if tag == 1 & carngr == 1, msymbol(i) lcolor(blue) lwidth(medium)lpattern(solid)  sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(blue) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 2, msymbol(i) lcolor(red) lwidth(medium)lpattern(solid) sort mlabel(total`g'`s'_carn) mlabposition(12) mlabcolor(red) mlabsize(vsmall)) (connected total`g'`s'_carn year if tag == 1 & carngr == 3, msymbol(i) lcolor(orange) lpattern(solid) lwidth(medium) sort mlabel(total`g'`s'_carn) mlabposition(6) mlabcolor(orange) mlabsize(vsmall))	(connected `g'ont_carn1_yhat year if tag == 1 & year >= 2007 & carngr == 1, lcolor(blue) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn2_yhat year if tag == 1 & year >= 2007 & carngr == 2, lcolor(red) lpattern(dash) msymbol(i)  mlabposition(12) mlabsize(vsmall) sort) (connected `g'ont_carn4_yhat year if tag == 1 & year >= 2007 & carngr == 3, lcolor(orange) lpattern(dash) msymbol(i) mlabposition(12) mlabsize(vsmall) sort), xline(2009, lpattern("dash") lwidth("vthin")) xlabel(1999(2)2015, labs(small) angle(20)) saving(total`g'`s'_carn.gph, replace) ylabel(0(50)150,labsize(small)) title(`ytitle', size(small)) ytitle("") xtitle("") legend(off)
		}
	}
}

grc1leg "totalmwont_carn.gph" "totalfwont_carn.gph" "totalmbont_carn.gph" "totalfbont_carn.gph" "totalmhont_carn.gph" "totalfhont_carn.gph" "totalmaont_carn.gph" "totalfaont_carn.gph", l1("New tenure-track hires", size(small)) b1("Academic year", size(small)) legendfrom("totalfwont_carn.gph") ring(3) rows(4) iscale(0.6) imargin(tiny)
graph display Graph, ysize(12) xsize(8)

graph save Figure5_alt.gph, replace
graph export Figure5.eps, logo(off) cmyk(on) replace
