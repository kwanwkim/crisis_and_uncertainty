*Project: Crisis and Uncertainty: Did the Great Recession Reduce the Diversity of Faculty?

*Author: Kwan Woo Kim (kwanwookim@g.harvard.edu)
*Created: 4/4/2020
*Updated: 5/10/2021
*Additional annotations: 6/15/2023

/*This .do file achieves the following tasks.
1. Clean the faculty hire data from the Fall Staff Survey of IPEDS.
2. Merge with data on institutional characteristics, finances, and stduent/faculty demographics (these datasets have already been cleaned)
3. Run the main and supplementary analyses
4. Export the regression estimates into excel spreadsheets
5. Calculate and plot marginal effects
*/

*Create data frame
cap frame create crisis, change
frame change crisis
clear

*Set directory
global datadir "{Your_directory}/Replication_Github/Data/"
global outputdir "{Your_directory}/Replication_Github/Tables and figures"

use "${datadir}/Crisis_and_uncertainty.dta", clear

xtset nid year, yearly

//Analysis + Plotting 
*3. Run the main and supplementary analyses
*4. Export the regression estimates into excel spreadsheets
*5. Calculate and plot marginal effects

cap mkdir "${outputdir}"
cd "${outputdir}"

*DV:Log odds
*Table S3, Figure S1 - Non-interacted
*Average predicted odds
set scheme s2manual
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
		outreg2 using TableS3, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2') replace
		}
		else {
		outreg2 using TableS3, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") addstat(`r2')
		}
	}
}

coefplot mwont, bylabel("White men") ||mbont, bylabel("Black men") || mhont, bylabel("Hispanic men") || maont, bylabel("Asian-American" "men")||fwont, bylabel("White Women") ||fbont, bylabel("Black Women") || fhont, bylabel("Hispanic Women") || faont, bylabel("Asian-American" "Women")||, drop(_cons lnttont revenue1 lntfaculty2 *odds*) yline(0, lpattern(dash) lwidth(thin) lcolor(cranberry)) vertical ytitle("Annual change in group share (odds)")  byopts(compact cols(4)) ylabel(-0.05 (0.025) 0.05) saving(FigureS1.gph, replace) transform(*=exp(@)-1)
graph export FigureS1.png, replace

* Table S4, Figure 4 - year spline by control 
**1. run regression models, store the results
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
	reghdfe ln`g'ont c.(year_pre year_in year_post) 1.control#c.(year_pre year_in year_post) revenue1 lnttont lntfaculty2, absorb(nid, savefe) cluster(nid)
	if "`g'"== "mw" {
		outreg2 using TableS4, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") replace
	}
	else {
		outreg2 using TableS4, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'")
	}
	estimate store `g'ont_ctrl
}

**2. run lincom, store the marginal coefficients and confidence intervals in dataframe "lincom"
capture frame drop lincom
frame create lincom str20 (group) type str20 (period) coefficient lb ub
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
	est restore `g'ont_ctrl
	foreach var in year_pre year_in year_post {
		lincom `var'
		frame post lincom ("`ytitle'") (1) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 1.control#`var' + `var'
		frame post lincom ("`ytitle'") (2) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
	}
}

*Export the lincom table
frame change lincom
export excel using "lincom.xlsx", sheet("TableS4") firstrow(variables) replace
frame change crisis
*See "filename.r" for the codes for plotting.

**3. Test statistical significance of the differences between pre-crisis and crisis estimates
capture frame drop diff1
frame create diff1 str20 (group) str20 (type) coefficient lb ub pvalue
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
			local ytitle = "White men"
	}
	if  "`g'" == "mb" { 
			local ytitle = "Black men"
	}
	if  "`g'" == "mh" { 
			local ytitle = "Hispanic men"
	}
	if  "`g'" == "ma" { 
			local ytitle = "Asian-American Men"
	}
	est restore `g'ont_ctrl
	lincom year_in-year_pre
	frame post diff1 ("`ytitle'") ("Public") (`r(estimate)') (`r(lb)') (`r(ub)') (`r(p)')
	lincom (year_in+1.control#year_in)-(year_pre+ 1.control#year_pre)
	frame post diff1 ("`ytitle'") ("Private") (`r(estimate)') (`r(lb)') (`r(ub)') (`r(p)')
}
*Export the difference table
frame change diff1
export excel using "diff.xlsx", sheet("TableS4") firstrow(variables) replace
frame change crisis
*See "filename.r" for the codes for plotting.

*Table S5, Figure 6 - Year spline by Carnegie
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
	reghdfe ln`g'ont c.(year_pre year_in year_post) i.carngr2#c.(year_pre year_in year_post) revenue1 lnttont lntfaculty2, absorb(nid, savefe) cluster(nid)
	if "`g'"== "mw" {
		outreg2 using TableS5, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'") replace
	}
	else {
		outreg2 using TableS5, excel dec(3) label alpha (0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +) ctitle("`ytitle'")
	}
	estimate store `g'ont_carn
}

**2. run lincom, store the marginal coefs
capture frame drop lincom2
frame create lincom2 str20 (group) type str20 (period) coefficient lb ub
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
	est restore `g'ont_carn
	foreach var in year_pre year_in year_post {
		lincom `var'
		frame post lincom2 ("`ytitle'") (1) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 2.carngr#`var' + `var'
		frame post lincom2 ("`ytitle'") (2) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
		lincom 3.carngr#`var' + `var'
		frame post lincom2 ("`ytitle'") (3) ("`var'") (`r(estimate)') (`r(lb)') (`r(ub)')
	}
}

*Export the lincom table
frame change lincom2
export excel using "lincom.xlsx", sheet("TableS5") firstrow(variables) 
frame change crisis
*See "filename.r" for the codes for plotting.


**3. Using lincom, estimate the difference between the pre-crisis and crisis period
capture frame drop diff2
frame create diff2 str20 (group) str20 (type) coefficient lb ub pvalue
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
	est restore `g'ont_carn
	lincom year_in-year_pre
	frame post diff2 ("`ytitle'") ("R1") (`r(estimate)') (`r(lb)') (`r(ub)') (`r(p)')
	lincom (year_in+2.carngr2#year_in)-(year_pre+ 2.carngr2#year_pre)
	frame post diff2 ("`ytitle'") ("R2/MA") (`r(estimate)') (`r(lb)') (`r(ub)') (`r(p)')
	lincom (year_in+3.carngr2#year_in)-(year_pre+ 3.carngr2#year_pre)
	frame post diff2 ("`ytitle'") ("BA") (`r(estimate)') (`r(lb)') (`r(ub)') (`r(p)')
}
*Export the difference table
frame change diff2
export excel using "diff.xlsx", sheet("TableS5") firstrow(variables) 
frame change crisis
*See "filename.r" for the codes for plotting.
