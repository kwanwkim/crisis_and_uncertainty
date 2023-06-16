*Project: Crisis and Uncertainty: Did the Great Recession Reduce the Diversity of Faculty?
*Supplementary analyses

*Author: Kwan Woo Kim (kwanwookim@g.harvard.edu)
*Created: 4/4/2020
*Updated: 5/10/2021
*Additional annotations: 6/15/2023

/*This .do file produces the following tables and figures
*A. Table S6, Figure S2 - Year spline by control & Carnegie 
*B. Table S7. Alternative recession period 1 (2007-2009)
*C. Table S8. Alternative recession period 1 (2007-2013)
*D. Table S9. two post-recession periods
*E. Table S10. log proportion
*F. Table S11, Figure S3. Poisson (count) models
*/

clear
global datadir "/Users/kwan/Documents/Google Drive/Projects/Universities/Team folders/Universities Project/Recession and Diversity/Post acceptance/Replication_Github/Data/"
global outputdir "/Users/kwan/Documents/Google Drive/Projects/Universities/Team folders/Universities Project/Recession and Diversity/Post acceptance/Replication_Github/Tables and figures"

cd "${outputdir}"
use "${datadir}/Crisis_and_uncertainty.dta"


*Spline by control & carnegie
gen cc = 1 if carngr == 1 & control == 0
replace cc = 2 if carngr == 1 & control == 1
replace cc = 3 if inlist(carngr,2, 3) & control == 0
replace cc = 4 if inlist(carngr,2, 3) & control == 1
replace cc = 5 if carngr == 4 & control == 0
replace cc = 6 if carngr == 4 & control == 1
la def cc 1 "R1-public" 2 "R1-private" 3 "R2/MA-Public"  4 "R2/MA-Private" 5 "BA-Public" 6 "BA-Private"
la val cc cc


*A. Table S6, Figure S2 - Year spline by control & Carnegie 
**1. Estimate the models
foreach g in mw mb mh ma fw fb fh fa {
	if  "`g'" == "fw" { 
				local ytitle = "White Women"
		}
		if  "`g'" == "fb" { 
				local ytitle = "Black Women"
		}
		if  "`g'" == "fh" { 
				local ytitle = "Hispanic Women"
		}
		if  "`g'" == "fa" { 
				local ytitle = "Asian-American Women"
		}
		if  "`g'" == "fm" { 
				local ytitle = "Women of Color"
		}
		if  "`g'" == "mw" { 
				local ytitle = "White Men"
		}
		if  "`g'" == "mb" { 
				local ytitle = "Black Men"
		}
		if  "`g'" == "mh" { 
				local ytitle = "Hispanic Men"
		}
		if  "`g'" == "ma" { 
				local ytitle = "Asian-American Men"
		}
		if  "`g'" == "mm" { 
				local ytitle = "Men of Color"
		}
	reghdfe ln`g'ont c.(year_pre year_in year_post) i.cc#c.(year_pre year_in year_post) revenue1 lnttont lntfaculty2, absorb(nid, savefe) cluster(nid)
	if "`g'"== "mw" {
		outreg2 using TableS6, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") replace
	}
	else {
		outreg2 using TableS6, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'")
	}
	estimate store `g'ont_cc
}

**2. Estimate the marginal coefficients
cap frame drop lincom_cc
frame create lincom_cc str20 (group) type str20 (period) coefficient lb ub
foreach g in mw mb mh ma fw fb fh fa {
	if  "`g'" == "fw" { 
			local ytitle = "White Women"
	}
	if  "`g'" == "fb" { 
			local ytitle = "Black Women"
	}
	if  "`g'" == "fh" { 
			local ytitle = "Hispanic Women"
	}
	if  "`g'" == "fa" { 
			local ytitle = "Asian-American Women"
	}
	if  "`g'" == "mw" { 
			local ytitle = "White Men"
	}
	if  "`g'" == "mb" { 
			local ytitle = "Black Men"
	}
	if  "`g'" == "mh" { 
			local ytitle = "Hispanic Men"
	}
	if  "`g'" == "ma" { 
			local ytitle = "Asian-American Men"
	}
	est restore `g'ont_cc
	foreach var in year_pre year_in year_post {
		lincom `var'
		frame post lincom_cc ("`ytitle'") (1) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 2.cc#`var' + `var'
		frame post lincom_cc ("`ytitle'") (2) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 3.cc#`var' + `var'
		frame post lincom_cc ("`ytitle'") (3) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 4.cc#`var' + `var'
		frame post lincom_cc ("`ytitle'") (4) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 5.cc#`var' + `var'
		frame post lincom_cc ("`ytitle'") (5) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 6.cc#`var' + `var'
		frame post lincom_cc ("`ytitle'") (6) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
	}
}

**3.Export the lincom table
frame change lincom_cc
export excel using "lincom.xlsx", sheet("TableS6") firstrow(variables) 
frame change crisis
*See "Figures 4 and 6.rscript" for the codes for plotting.


*B. Table S7. Alternative recession period 1 (2007-2009)
capture drop year_pre year_in year_post*
mkspline year_pre 2007 year_in 2009 year_post =year
la var year_pre "Year pre-recession (1999-2007)"
la var year_in "Year count during recession (2007-2013)"
la var year_post "Year count after recession (2013-2015)"
foreach c in ont {
	foreach g in mw mb mh ma fw fb fh fa {
		if  "`g'" == "fw" { 
				local ytitle = "White Women"
		}
		if  "`g'" == "fb" { 
				local ytitle = "Black Women"
		}
		if  "`g'" == "fh" { 
				local ytitle = "Hispanic Women"
		}
		if  "`g'" == "fa" { 
				local ytitle = "Asian-American Women"
		}
		if  "`g'" == "fm" { 
				local ytitle = "Women of Color"
		}
		if  "`g'" == "mw" { 
				local ytitle = "White Men"
		}
		if  "`g'" == "mb" { 
				local ytitle = "Black Men"
		}
		if  "`g'" == "mh" { 
				local ytitle = "Hispanic Men"
		}
		if  "`g'" == "ma" { 
				local ytitle = "Asian-American Men"
		}
		if  "`g'" == "mm" { 
				local ytitle = "Men of Color"
		}
		qui: reghdfe ln`g'`c' year_pre year_in year_post revenue1 lnttont lntfaculty2 if ttont>0, absorb(nid) cluster(nid)
		estimate store `g'`c'
		if "`g'"== "mw" {
		outreg2 using TableS7, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2') replace
		}
		else {
		outreg2 using TableS7, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2')
		}
	}
}

*C. Table S8. Alternative recession period 1 (2007-2013)
capture drop year_pre year_in year_post*
mkspline year_pre 2007 year_in 2013 year_post =year
la var year_pre "Year pre-recession (1999-2007)"
la var year_in "Year count during recession (2007-2013)"
la var year_post "Year count after recession (2013-2015)"

foreach c in ont {
	foreach g in mw mb mh ma fw fb fh fa {
		if  "`g'" == "fw" { 
				local ytitle = "White Women"
		}
		if  "`g'" == "fb" { 
				local ytitle = "Black Women"
		}
		if  "`g'" == "fh" { 
				local ytitle = "Hispanic Women"
		}
		if  "`g'" == "fa" { 
				local ytitle = "Asian-American Women"
		}
		if  "`g'" == "fm" { 
				local ytitle = "Women of Color"
		}
		if  "`g'" == "mw" { 
				local ytitle = "White Men"
		}
		if  "`g'" == "mb" { 
				local ytitle = "Black Men"
		}
		if  "`g'" == "mh" { 
				local ytitle = "Hispanic Men"
		}
		if  "`g'" == "ma" { 
				local ytitle = "Asian-American Men"
		}
		if  "`g'" == "mm" { 
				local ytitle = "Men of Color"
		}
		qui: reghdfe ln`g'`c' year_pre year_in year_post revenue1 lnttont lntfaculty2 if ttont>0, absorb(nid) cluster(nid)
		estimate store `g'`c'
		if "`g'"== "mw" {
		outreg2 using TableS8, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2') replace
		}
		else {
		outreg2 using TableS8, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2')
		}
	}
}

*D. Table S9. two post-recession periods
capture drop year_pre year_in year_post*
mkspline year_pre 2007 year_in 2011 year_post1 2013 year_post2 =year
la var year_pre "Year pre-recession (1999-2007)"
la var year_in "Year count during recession (2007-2011)"
la var year_post1 "Year count between 2011-2013"
la var year_post2 "Year count between 2013-2015"

foreach c in ont {
	foreach g in mw mb mh ma fw fb fh fa {
		if  "`g'" == "fw" { 
				local ytitle = "White Women"
		}
		if  "`g'" == "fb" { 
				local ytitle = "Black Women"
		}
		if  "`g'" == "fh" { 
				local ytitle = "Hispanic Women"
		}
		if  "`g'" == "fa" { 
				local ytitle = "Asian-American Women"
		}
		if  "`g'" == "fm" { 
				local ytitle = "Women of Color"
		}
		if  "`g'" == "mw" { 
				local ytitle = "White Men"
		}
		if  "`g'" == "mb" { 
				local ytitle = "Black Men"
		}
		if  "`g'" == "mh" { 
				local ytitle = "Hispanic Men"
		}
		if  "`g'" == "ma" { 
				local ytitle = "Asian-American Men"
		}
		if  "`g'" == "mm" { 
				local ytitle = "Men of Color"
		}
		qui: reghdfe ln`g'`c' year_pre year_in year_post1 year_post2 revenue1 lnttont lntfaculty2 if ttont>0, absorb(nid) cluster(nid)
		estimate store `g'`c'
		if "`g'"== "mw" {
		outreg2 using TableS9, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2') replace
		}
		else {
		outreg2 using TableS9, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2')
		}
	}
}

*E. Table S10. log proportion
capture drop year_pre year_in year_post*
mkspline year_pre 2007 year_in 2011 year_post =year
la var year_pre "Year pre-recession (1999-2007)"
la var year_in "Year count during recession (2007-2011)"
la var year_post "Year count after recession (2011-2015)"

foreach g in mw mb mh ma fw fb fh fa {
	if  "`g'" == "fw" { 
			local ytitle = "White Women"
	}
	if  "`g'" == "fb" { 
			local ytitle = "Black Women"
	}
	if  "`g'" == "fh" { 
			local ytitle = "Hispanic Women"
	}
	if  "`g'" == "fa" { 
			local ytitle = "Asian-American Women"
	}
	if  "`g'" == "fm" { 
			local ytitle = "Women of Color"
	}
	if  "`g'" == "mw" { 
			local ytitle = "White Men"
	}
	if  "`g'" == "mb" { 
			local ytitle = "Black Men"
	}
	if  "`g'" == "mh" { 
			local ytitle = "Hispanic Men"
	}
	if  "`g'" == "ma" { 
			local ytitle = "Asian-American Men"
	}
	if  "`g'" == "mm" { 
			local ytitle = "Men of Color"
	}
	qui: reghdfe lnpr`g'ont year_pre year_in year_post revenue1 lnttont lntfaculty2 if ttont>0, absorb(nid) cluster(nid)
	estimate store lnpr`g'
	if "`g'"== "mw" {
	outreg2 using TableS10, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2') replace
	}
	else {
	outreg2 using TableS10, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2')
	}
}

*F. Table S11, Figure S3. Poisson (count) models
*1. Estimate the models
foreach g in mw mb mh ma fw fb fh fa {
	if  "`g'" == "fw" { 
			local ytitle = "White Women"
	}
	if  "`g'" == "fb" { 
			local ytitle = "Black Women"
	}
	if  "`g'" == "fh" { 
			local ytitle = "Hispanic Women"
	}
	if  "`g'" == "fa" { 
			local ytitle = "Asian-American Women"
	}
	if  "`g'" == "fm" { 
			local ytitle = "Women of Color"
	}
	if  "`g'" == "mw" { 
			local ytitle = "White Men"
	}
	if  "`g'" == "mb" { 
			local ytitle = "Black Men"
	}
	if  "`g'" == "mh" { 
			local ytitle = "Hispanic Men"
	}
	if  "`g'" == "ma" { 
			local ytitle = "Asian-American Men"
	}
	if  "`g'" == "mm" { 
			local ytitle = "Men of Color"
	}
	qui: ppmlhdfe `g'ont year_pre year_in year_post revenue1 lntfaculty2 if ttont>0, absorb(nid) vce(cluster nid) exposure(ttont)
	estimate store ppml`g'
	if "`g'"== "mw" {
	outreg2 using TableS11, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(Institutions, e(N_clust), Pseudo R-Squared, e(r2_p)) replace
	}
	else {
	outreg2 using TableS11, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(Institutions, e(N_clust), Pseudo R-Squared, e(r2_p))
	}
}

la var year_pre "Pre" 
la var year_in "Crisis"
la var year_post "Post"

**2. Estimate marginal number of hires from each group with individual y axis ranges
ppmlhdfe fbont year_pre year_in year_post revenue1 lntfaculty2  lnfboddsten lnfboddsont  if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("Black Women") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("")saving(fbnumber, replace) ylabel(0(0.2)1) xlabel(,angle(20))

ppmlhdfe fhont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont  if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("Hispanic Women") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(fhnumber, replace) ylabel(0(0.1)0.6) xlabel(,angle(20))

ppmlhdfe faont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont   if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("Asian Women") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(fanumber, replace) ylabel(0(0.3)1.2) xlabel(,angle(20))

ppmlhdfe mbont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont  if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("Black Men") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(mbnumber, replace) ylabel(0(0.2)1) xlabel(,angle(20))

ppmlhdfe mhont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont   if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("Hispanic Men") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(mhnumber, replace) ylabel(0(0.1)0.6) xlabel(,angle(20))

ppmlhdfe maont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont  if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("Asian Men") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(manumber, replace) ylabel(0(0.3)1.5) xlabel(,angle(20))

ppmlhdfe mwont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont   if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("White Men") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(mwnumber, replace) ylabel(0(2)10) xlabel(,angle(20))

ppmlhdfe fwont year_pre year_in year_post revenue1 lntfaculty2  lnfhoddsten lnfhoddsont   if ttont>0, exposure(ttont) absorb(nid) d
margins, over(year) asobserved exp(exp(predict(xb)+_ppmlhdfe_d))
marginsplot, noci title("White Women") ciopts(fcolor(%10) lcolor(%0)) ytitle("") xtitle("") saving(fwnumber, replace) ylabel(0(2)8) xlabel(,angle(20))

graph combine mwnumber.gph mbnumber.gph mhnumber.gph manumber.gph fwnumber.gph fbnumber.gph fhnumber.gph fanumber.gph, rows(2) iscale(0.7) xsize(5.5) saving(FigureS3.gph, replace) 
graph export FigureS3.png, replace

