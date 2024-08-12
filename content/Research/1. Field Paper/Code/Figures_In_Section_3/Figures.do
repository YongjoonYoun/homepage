*******************************************
* Figures in Section 3.do	    		  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 12/01/2023			  *
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
cd "C:\Users\Yongjoon\Desktop\Research\1. Unconditional cash transfers and family transfers in Korea\Code\Figures_In_Section_3"	
 
// FIGURE 1: TOTAL FERTILITY RATES
clear all 
use fertility

// SETTING
gen USA = value if location=="USA"
gen KOR = value if location=="KOR"
gen JPN = value if location=="JPN"
gen GBR = value if location=="GBR"
gen OAVG = value if location=="OAVG"
gen EU = value if location=="EU"

set scheme s1color
colorpalette Set1, select(1/3 5) nograph
twoway line KOR JPN USA GBR OAVG EU time, xlabel(,labsize(medium))ylabel(,labsize(medium))  xtitle("Year", size(4)) ytitle("Total Fertility Rate", size(4)) legend( label(1 "South Korea") label(2 "Japan") label(3 "The U.S") label(4 "The U.K") label(5 "OECD Average") label(6 "EU Average")  pos(2) ring(0) col(2) size(*1) style(2) symxsize(3) symysize(3) rows(6) bmargin(10) ) lcolor(red%60 orange%40 midgreen%40 blue%30 cranberry%30 magenta%40 eltgreen%40) lwidth(0.5)  
 

*FIGURE 2: OLD-AGE DEPENDENCY RATIO
clear all 
use Old_Age_dependency

gen Canada = value if location=="CAN"
gen Japan = value if location=="JPN"
gen Korea = value if location=="KOR"
gen United_Kingdom = value if location=="GBR"
gen United_States = value if location=="USA"
gen China = value if location=="CHN"
gen OECD_Average = value if location=="OAVG"
gen Europe_Average = value if location=="EU28"

set scheme s1color
colorpalette Set1, select(1/3 5) nograph
graph twoway (line Korea time, lwidth(1) lcolor(red%60)) (line Canada time, lwidth(0.5) lcolor(orange%40)) (line Japan time, lwidth(0.5) lcolor(midblue%30))  (line United_Kingdom time, lwidth(0.5) lcolor(midgreen%40)) (line United_States time, lwidth(0.5) lcolor(cranberry%30)) (line China time, lwidth(0.5) lcolor(eltgreen%40)) (line OECD_Average time, lwidth(0.5) lcolor(magenta%40)) (line Europe_Average time, lwidth(0.5) lcolor(cyan%40)), legend(label (1 "South Korea") label (4 "United Kingdom") label (5 "United States") label (7 "OECD Average") label (8 "Europe Average") order(1 6 3 2 4 5 7 8) pos(2) ring(0) col(1) size(*1.1) style(2) symxsize(3) symysize(3) rows(8) bmargin(10)) xlabel(1950(25)2075, angle(45)) xline(1950) xline(2075) xtitle("")  

// FIGURE 3: OLD-AGE POVERTY
clear all
use poverty

gen Canada = value if location=="CAN"
gen Japan = value if location=="JPN"
gen Korea = value if location=="KOR"
gen United_Kingdom = value if location=="GBR"
gen United_States = value if location=="USA"
gen Germany = value if location=="DEU"
gen Sweden = value if location=="SWE"
gen Norway = value if location=="NOR"

graph bar Norway Germany Sweden Canada United_Kingdom Japan  United_States Korea,  bargap(100) blabel(total, format(%9.2f)) legend(label (1 "Norway") label (2 "Germany") label (3 "Sweden") label (4 "Canada") label (5 "United Kingdom") label (6 "Japan") label (7 "United States") label (8 "South Korea") pos(3) col(1) size(*1.2) style(2) symxsize(3) symysize(3) rows(8) bmargin(10)) bar(1, fcolor("`r(p1)'") fintensity(10) color(black)) bar(2, color(black) fcolor("`r(p2)'") fintensity(20)) bar(3, color(black) fcolor("`r(p3'") fintensity(30)) bar(4,color(black)  fcolor("`r(p4)'") fintensity(40)) bar(5,color(black)  fcolor("`r(p5)'") fintensity(50)) bar(6,color(black) fcolor("`r(p6)'") fintensity(60)) bar(7, color(black) fcolor("`r(p7)'") fintensity(70)) bar(8,color(black) fcolor("`r(p8)'") fintensity(90)) 




