*******************************************
* 6.Summary_Statistics_KLoSA.do			  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 05/17/2024			  *
*******************************************

cap log close
clear all
set more off, perm
set matsize 5000
set maxvar 30000

*********************
///  IMPORT FILE  ///
*********************
// SET DIRECTORY
* Set directory to the location of the replication data folder
cd "\\DESKTOP-OK2B73D\Users\Yongjoon\Desktop\Research\1. Unconditional cash transfers and family transfers in Korea\Data"	

* IMPORT DATA
use ANALYSIS.dta, clear
 

* CUSTOMIZING COLORS & SCHEME
*ssc install palettes, replace
*ssc install colrspace, replace
*net install cleanplots, from("https://tdmize.github.io/data/cleanplots")


* Making table is skipped here 
*======================================================*
* Descriptive statistics
*======================================================
// Table 1 
bys household: su age i.edu hhincome netassets i.urban emp livchildren livgrandchild ADL IADL livchildren livgrandchild subjecthealth  subjectbequestGIVE subjectFUTURE subjectbequestSECURITY subjectCHILDCLOSE if household < . 

// Appendix: First child's characteristics 
bys household: su child1_age child1_gender i.child1_edu child1_emp child1_cores  child1_ownhome child1_marital child1_livchildren i.child1_proximity i.child1_meeting i.child1_contact if household < . & child1_proximity >=0

// Figure 1: BP Amount  
gen time = year 
replace time = 2006 if year == 2
replace time = 2008 if year == 3
replace time = 2010 if year == 4
replace time = 2012 if year == 5
replace time = 2014 if year == 6
replace time = 2016 if year == 7
replace time = 2018 if year == 8
replace time = 2020 if year == 9
replace time = . if year == 1

gen BP_USD = BP_CONTINUOUS_AMOUNT*10000/1350
   
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph BP_USD time if BP_USD > 0 & BP_USD, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2006(2)2022, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
 
// Figure 2: Transfers   
// FROM
gen time1 = year 
replace time1 = 2005 if year == 1
replace time1 = 2007 if year == 2
replace time1 = 2009 if year == 3
replace time1 = 2011 if year == 4
replace time1 = 2013 if year == 5
replace time1 = 2015 if year == 6
replace time1 = 2017 if year == 7
replace time1 = 2019 if year == 8
replace time1 = 2021 if year == 9


set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph FROMCHILD_INTEN_SUM time1 if FROMCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
 
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph FROMCHILD_NON_INTEN_SUM time1 if FROMCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
  
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph FROMCHILD_NON_INTEN_IRREGULAR time1 if FROMCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
  
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph FROMCHILD_NON_INTEN_REGULAR time1 if FROMCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore

set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph FROMCHILD_CO_INTEN_SUM time1 if FROMCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore

// TO
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph TOCHILD_INTEN_SUM time1 if TOCHILD_INTEN_SUM > 0 & household<., by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
 
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph TOCHILD_NON_INTEN_SUM time1 if TOCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
  
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph TOCHILD_NON_INTEN_IRREGULAR time1 if TOCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore
  
set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph TOCHILD_NON_INTEN_REGULAR time1 if TOCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore

set scheme s2mono 
colorpalette Set1, select(1/3 5) nograph
preserve
lgraph TOCHILD_CO_INTEN_SUM time1 if TOCHILD_INTEN_SUM > 0, by(household) loptions(1 mcolor(black%80) lcolor(black%80);2 mcolor(midblue%70) lcolor(midblue%70);3 mcolor(red%70) lcolor(red%70) ;4 mcolor(midgreen%70) lcolor(midgreen%70))  separate(0.00) scale(0.9) legend(ring(0) position(10) size(*1.0) style(3) symxsize(1) symysize(1) rows(4) cols(1) bmargin(0)) xlabel(2005(2)2021, angle(0)) ytitle("USD") xtitle("") xline(2014, lcolor(black%40) lpattern(dash)) xline(2018, lcolor(black%40) lpattern(dash)) xline(2020, lcolor(black%40) lpattern(dash)) 
restore

// APPENDIX TABLE 1: First Child's characteristics
bys household: su age i.edu hhincome netassets i.urban emp livchildren livgrandchild ADL IADL livchildren livgrandchild subjecthealth  subjectbequestGIVE subjectFUTURE subjectbequestSECURITY subjectCHILDCLOSE if household < . 

 