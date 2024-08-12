*******************************************
* 1.Data_Construction_KLoSA.do			  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 04/27/2024			  *
*******************************************

clear all
clear matrix
clear mata
set more off

***********************
///  SET DIRECTORY  ///
***********************
// SET DIRECTORY TO THE FOLDER STORING THE REPLICATAION DATA	
cd "\\DESKTOP-OK2B73D\Users\Yongjoon\Desktop\Research\1. Unconditional cash transfers and family transfers in Korea\Data"	
	
***********************
///  FRAME SETTING  ///
***********************
// FRAME FOR DATA CONSTRUCTION
// Use structured datasets str01 (Wave 1: 2006)-str09 (wave 9: 2022)
frames reset
frame rename default k1 							//KLoSA wave 1
use "str01.dta", clear

frame create k2										//KLoSA wave 2
frame change k2
use "str02.dta", clear

frame create k3										//KLoSA wave 3
frame change k3
use "str03.dta", clear

frame create k4										//KLoSA wave 4
frame change k4
use "str04.dta", clear

frame create k5										//KLoSA wave 5
frame change k5 
use "str05.dta", clear

frame create k6										//KLoSA wave 6
frame change k6
use "str06.dta", clear

frame create k7										//KLoSA wave 7
frame change k7
use "str07.dta", clear

frame create k8										//KLoSA wave 8
frame change k8
use "str08.dta", clear

frame create k9										//KLoSA wave 9
frame change k9
use "str09.dta", clear

frame change k1 									//Default 

****************************
///  MATCHING VARIABLES  ///
****************************
// Matching variables across waves
// Necessary commands for each wave to match variables across waves 

frame k1{
rename hhid hhid01		// matching names for later surveys
rename CID06 cid01		// matching names for later surveys
rename w01Adl w01adl	// capital letter typo from KLoSA
rename w01ba028_0* w01Ba028_0*w5 
rename w01ba044_0* w01Ba046_0*w5
gen mark1 = 5   		// to mark newly added samples in 2014
gen w01basic_start = .  // BP date for identification
gen w01G110 = .  		// G* variables exist from wave 2 
gen w01G111 = . 		// G* variables exist from wave 2 
gen w01G112 = .  		// G* variables exist from wave 2 
gen w01G113 = .  		// G* variables exist from wave 2 
gen w01G114 = .			// G* variables exist from wave 2 
gen w01oldnew = .		// mark for newly added sample in 2014 
gen w01Cadd_01 = .		// dementia variable exists from wave 7
forval i=1/9{
gen w01Ba053_0`i' = .     // transfers with coresident child
gen w01Ba054_0`i' = .  
gen w01Ba060_0`i' = . 
gen w01Ba061_0`i' = . 
save k1, replace
}
}

frame k2{
rename hhid hhid02
rename CID08 cid02
rename w02ba028_0* w02Ba028_0*w5
rename w02ba044_0* w02Ba046_0*w5 
gen w02basic_start = .
gen w02oldnew = .
gen w02Cadd_01 = .
save k2, replace
}

frame k3{
rename hhid hhid03
rename CID10 cid03
rename w03ba028_0* w03Ba028_0*w5 
rename w03ba044_0* w03Ba046_0*w5
gen w03basic_start = .  
gen w03oldnew = .
gen w03Cadd_01 = .
save k3, replace
}

frame k4{
rename hhid hhid04
rename CID12 cid04
rename w04ba028_0* w04Ba028_0*w5 
rename w04ba044_0* w04Ba046_0*w5
gen w04basic_start = . 
gen w04oldnew = .
gen w04Cadd_01 = .
save k4, replace
}

frame k5{
rename hhid hhid05
rename CID14 cid05
rename w05E120 w05basic_start   
forval i=1/9{ // matching variable names with other waves
	rename w05Ba021_0`i'w5 w05Ba021m01_0`i' 
	rename w05Ba029_0`i'w5 w05Ba021m02_0`i' 
	rename w05Ba036_0`i'w5 w05Ba021m03_0`i' 
	rename w05Ba039_0`i'w5 w05Ba037m01_0`i' 
	rename w05Ba047_0`i'w5 w05Ba037m02_0`i' 
	rename w05Ba054_0`i'w5 w05Ba037m03_0`i' 
	} 
gen w05Ba021m01_10 = .  
gen w05Ba029m01_10 = .  
gen w05Ba036m01_10 = .  
gen w05Ba039m01_10 = .
gen w05Ba047m01_10 = .
gen w05Ba054m01_10 = .
gen w05Cadd_01 = .
save k5, replace
}

frame k6{
rename hhid hhid06
rename CID16 cid06
rename w06E120 w06basic_start  
rename w06Ba021_09 w06Ba021_09w5
forval i=1/9{
	rename w06Ba021_0`i'w5 w06Ba021m01_0`i' 
	rename w06Ba029_0`i'w5 w06Ba021m02_0`i' 
	rename w06Ba036_0`i'w5 w06Ba021m03_0`i' 
	rename w06Ba039_0`i'w5 w06Ba037m01_0`i' 
	rename w06Ba047_0`i'w5 w06Ba037m02_0`i' 
	rename w06Ba054_0`i'w5 w06Ba037m03_0`i' 
	} 
gen w06Ba021m01_10 = . 
gen w06Ba029m01_10 = .  
gen w06Ba036m01_10 = .  
gen w06Ba039m01_10 = . 
gen w06Ba047m01_10 = .  
gen w06Ba054m01_10 = .
gen w06Cadd_01 = .
gen w06_fam2 = . // KLoSA missed fam2 for wave6 
save k6, replace
}

frame k7{
rename hhid hhid07
rename CID18 cid07
rename w07Ba021_09 w07Ba021_09w5
	forval i=1/9{
	rename w07Ba021_0`i'w5 w07Ba021m01_0`i' 
	rename w07Ba029_0`i'w5 w07Ba021m02_0`i' 
	rename w07Ba036_0`i'w5 w07Ba021m03_0`i' 
	rename w07Ba039_0`i'w5 w07Ba037m01_0`i' 
	rename w07Ba047_0`i'w5 w07Ba037m02_0`i' 
	rename w07Ba054_0`i'w5 w07Ba037m03_0`i' 
	} 
gen w07Ba021m01_10 = .
gen w07Ba029m01_10 = .  
gen w07Ba036m01_10 = .  
gen w07Ba039m01_10 = . 
gen w07Ba047m01_10 = .  
gen w07Ba054m01_10 = .  
save k7, replace
}

frame k8{
rename hhid hhid08
rename CID20 cid08
rename w08Ba021_09 w08Ba021_09w5
	forval i=1/9{
	rename w08Ba021_0`i'w5 w08Ba021m01_0`i' 
	rename w08Ba029_0`i'w5 w08Ba021m02_0`i' 
	rename w08Ba036_0`i'w5 w08Ba021m03_0`i' 
	rename w08Ba039_0`i'w5 w08Ba037m01_0`i' 
	rename w08Ba047_0`i'w5 w08Ba037m02_0`i' 
	rename w08Ba054_0`i'w5 w08Ba037m03_0`i' 
	} 
gen w08Ba021m01_10 = . 
gen w08Ba029m01_10 = .  
gen w08Ba036m01_10 = .  
gen w08Ba039m01_10 = . 
gen w08Ba047m01_10 = .  
gen w08Ba054m01_10 = .  
save k8, replace
}

frame k9{
rename hhid hhid09
rename CID22 cid09
rename w09Ba021_04 w09Ba021_04w5
rename w09Ba021_09 w09Ba021_09w5
rename w09Ba036_01w6 w09Ba036_01w5
	forval i=1/9{
	rename w09Ba021_0`i'w5 w09Ba021m01_0`i' 
	rename w09Ba029_0`i'w5 w09Ba021m02_0`i' 
	rename w09Ba036_0`i'w5 w09Ba021m03_0`i' 
	rename w09Ba039_0`i'w5 w09Ba037m01_0`i' 
	rename w09Ba047_0`i'w5 w09Ba037m02_0`i' 
	rename w09Ba054_0`i'w5 w09Ba037m03_0`i' 
} 
gen w09Ba021m01_10 = . 
gen w09Ba029m01_10 = .  
gen w09Ba036m01_10 = .   
gen w09Ba039m01_10 = . 
gen w09Ba047m01_10 = .  
gen w09Ba054m01_10 = .   
save k9, replace
}

frame change k1

************************
///  KEEP VARIABLES  ///
************************
// SUBSET TO KEEP NECESSARY VARIABLES
local keep_vars ///
/*BACKGROUND*/ pid hhid* respid cid* w*_fam* w*_fam2 w*hhsize w*oldnew w*type w*panel_n w*A002 w*A002y w*edu w*A020 w*A022 w*A012 w*A028 w*A002_age w*marital w*gender1 w*region1 w*region3 w*year1 w*year2 w*Ba003 w*Bb003_* w*chgender_* ///
/*CHILD + TRANSFERS*/ w*chid_* w*Ba008_* w*Ba009_* w*Ba012_* w*Ba013_* w*Ba015_* w*Ba016_* w*Ba017_* w*Ba018_* w*Ba019_* w*Ba020_* w*Ba021m01_* w*Ba022_* w*Ba021m02_* w*Ba029_* w*Ba021m03_* w*Ba035m01_* w*Ba035m02_* w*Ba035m03_* w*Ba035m04_* w*Ba035m05_* w*Ba037m01_* w*Ba038_* w*Ba037m02_* w*Ba045_* w*Ba037m03_* w*Ba051m01_* w*Ba051m02_* w*Ba051m03_* w*Ba051m04_* w*Ba051m05_* w*Ba068 w*Ba075 w*Ba076 w*Ba_resp w*bp1_1 w*bp1_2 w*bp1 w*Bb131 w*_num1etc w*Bb150 w*_num2etc w*bb_adl1 w*bb_adl_num1 w*bb_adl2 w*bb_adl_num2 w*bb_adl3 w*bb_adl_num3 w*transferfrom w*fromchildren w*fromparent w*fromothers w*transferto w*tochildren w*toparent w*toothers w*Ba028_0*w5 w0*Ba046_0*w5 w*Ba053_0* w*Ba054_0* w*Ba060_0* w*Ba061_0* /// 
/*HEALTH*/ w*C001 w*C152 w*C003 w*adl w*iadl w*Cadd_01 ///
/*ECONOMIC RELATED*/ w*present_ecotype w*present_labor w*E001 w*E003 w*E004 w*E010 w*E012 w*E013 w*E019 w*E020 w*E026 w*E027 w*E033 w*E035 w*E036 w*E037 w*E044 w*E046 w*E047 w*E048 w*E055 w*E057 w*E058 w*E059 w*passets w*pliabilities w*pnetassets w*hhinc w*hhassets w*hhliabilities w*hhnetassets ///
/*EXPECTATION*/ w*G001 w*G002 w*G015 w*G017 w*G026 w*G027 w*G028 w*G029 w*G030 /// 
/*BASIC PENSION (BP)*/ w*G110 w*G111 w*G112 w*G113 w*G114 w*basic_start

di "`keep_vars'"
keep `keep_vars'

// VARIABLES TO KEEP FROM WAVES 2-9
local merge_vars pid respid hhid* cid* w*_fam* w*_fam2 w*hhsize w*type w*oldnew w*Bb003_* w*panel_n w*A002 w*A002y w*edu w*A020 w*A022 w*A012 w*A028 w*A002_age w*marital w*gender1 w*region1 w*region3 w*chgender_* w*Ba003 w*chid_* w*Ba008_* w*Ba009_* w*Ba012_* w*Ba013_* w*Ba015_* w*Ba016_* w*Ba017_* w*Ba018_* w*Ba019_* w*Ba020_* w*Ba021m01_* w*Ba022_* w*Ba021m02_* w*Ba029_* w*Ba021m03_* w*Ba035m01_* w*Ba035m02_* w*Ba035m03_* w*Ba035m04_* w*Ba035m05_* w*Ba037m01_* w*Ba038_* w*Ba037m02_* w*Ba045_* w*Ba037m03_* w*Ba051m01_* w*Ba051m02_* w*Ba051m03_* w*Ba051m04_* w*Ba051m05_* w*Ba068 w*Ba075 w*Ba076 w*Ba_resp w*bp1_1 w*bp1_2 w*bp1 w*Bb131 w*_num1etc w*Bb150 w*_num2etc w*bb_adl1 w*bb_adl_num1 w*bb_adl2 w*bb_adl_num2 w*bb_adl3 w*bb_adl_num3 w*transferfrom w*fromchildren w*fromparent w*fromothers w*transferto w*tochildren w*toparent w*toothers w*Ba028_0*w5 w0*Ba046_0*w5 w*Ba053_0* w*Ba054_0* w*Ba060_0* w*Ba061_0* w*C001 w*C152 w*C003 w*adl w*iadl w*Cadd_01 w*present_ecotype w*present_labor w*E001 w*E003 w*E004 w*E010 w*E012 w*E013 w*E019 w*E020 w*E026 w*E027 w*E033 w*E035 w*E036 w*E037 w*E044 w*E046 w*E047 w*E048 w*E055 w*E057 w*E058 w*E059 w*passets w*pliabilities w*pnetassets w*hhinc w*hhassets w*hhliabilities w*hhnetassets w*G001 w*G002 w*G015 w*G017 w*G026 w*G027 w*G028 w*G029 w*G030 w*G110 w*G111 w*G112 w*G113 w*G114 w*basic_start

frame change k1

**************************
///  MERGE DATA FILES  ///
**************************
// MERGE BASED ON PERSONAL IDENTIFIERS
forval i=2(1)9{
	merge 1:1 pid using k`i', keepusing(`merge_vars')
	rename _merge mark`i'
}

gen mark1 = 3 if hhid01<. // Mark new sample
forval i = 1/9{
gen indicator`i' = 0 if hhid0`i'<. // indicator for living with children
	forval j=1/9{
	replace indicator`i' = 1 if w0`i'Ba013_0`j' == 1 & hhid0`i'<.
}
}

***********************
///  SAVE THE DATA  ///
***********************
save Raw_Data.dta, replace