*******************************************
* 2.BP_Construction_KLoSA.do			  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 05/02/2024			  *
*******************************************

set more off, perm
clear all
set maxvar 30000

*********************
///  IMPORT FILE  ///
*********************
// SET DIRECTORY	
cd ""	

// IMPORT DATA
use Raw_Data.dta

***************************************************
///  BASIC PENSION (BP) TREATMENT CONSTRUCTION  ///
***************************************************
*Note: as written in the paper, 2006-2014 surveys asks BP receipts in the survey years, whereas 2016-2022 surveys ask BP receipts a year before the survey. So use them carefully.


*****************************
// 1. CONTINUOUS TREATMENT //
*****************************
forval i=1/9{
	gen BP_CONTINUOUS_AMOUNT`i' = . if hhid0`i' < .
	gen BP_SPOUSE`i' = 0 if hhid0`i'< . 
	}
replace BP_CONTINUOUS_AMOUNT3 = w02G112 if hhid03 < . // amount in 2008  
replace BP_CONTINUOUS_AMOUNT4 = w03G112 if hhid04 < . // amount in 2010 	
replace BP_CONTINUOUS_AMOUNT5 = w04G112 if hhid05 < . // amount in 2012 
replace BP_CONTINUOUS_AMOUNT6 = w05G112 if hhid06 < . // amount in 2014 
replace BP_CONTINUOUS_AMOUNT7 = w06G112 if hhid07 < . // amount in 2015	
replace BP_CONTINUOUS_AMOUNT8 = w07G112 if hhid08 < . // amount in 2017		
replace BP_CONTINUOUS_AMOUNT9 = w08G112 if hhid09 < . // amount in 2019	

replace BP_SPOUSE3 = 1 if w02G113 == 5 & BP_CONTINUOUS_AMOUNT3 > 0 & BP_CONTINUOUS_AMOUNT3 < . & hhid03 < . // whether couple in 2008  
replace BP_SPOUSE4 = 1 if w03G113 == 5 & BP_CONTINUOUS_AMOUNT4 > 0 & BP_CONTINUOUS_AMOUNT4 < . & hhid04 < . // whether couple in 2010  
replace BP_SPOUSE5 = 1 if w04G113 == 5 & BP_CONTINUOUS_AMOUNT5 > 0 & BP_CONTINUOUS_AMOUNT5 < . & hhid05 < . // whether couple in 2012    
replace BP_SPOUSE6 = 1 if w05G113 == 5 & BP_CONTINUOUS_AMOUNT6 > 0 & BP_CONTINUOUS_AMOUNT6 < . & hhid06 < . // whether couple in 2014  
replace BP_SPOUSE7 = 1 if w06G113 == 5 & BP_CONTINUOUS_AMOUNT7 > 0 & BP_CONTINUOUS_AMOUNT7 < . & hhid07 < . // whether couple in 2016  
replace BP_SPOUSE8 = 1 if w07G113 == 5 & BP_CONTINUOUS_AMOUNT8 > 0 & BP_CONTINUOUS_AMOUNT8 < . & hhid08 < . // whether couple in 2018  
replace BP_SPOUSE9 = 1 if w08G113 == 5 & BP_CONTINUOUS_AMOUNT9 > 0 & BP_CONTINUOUS_AMOUNT9 < . & hhid09 < . // whether couple in 2020  

forval i=3/9{ // to mark who answered they are receiving but not revealed the amount
	replace BP_CONTINUOUS_AMOUNT`i' = -1 if w0`i'G112 == . & w0`i'G111 == 1 & hhid0`i' < . 
} // only wave4 had this

// Less than 1% recipients didn't reveal the amount: imputed the mean value but no effects for later analyses
forval i=1/9{
	egen mean`i' = mean(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' <. & hhid0`i' < .
	replace BP_CONTINUOUS_AMOUNT`i' = mean`i' if BP_CONTINUOUS_AMOUNT`i' < 0 & hhid0`i' < . 
	replace BP_CONTINUOUS_AMOUNT`i' = mean`i' if BP_CONTINUOUS_AMOUNT`i' == . & hhid0`i' < . & w0`i'G111 == 1
	drop mean`i'
	replace BP_CONTINUOUS_AMOUNT`i' = 0 if BP_CONTINUOUS_AMOUNT`i' == . & hhid0`i' < .
	}	
	
forval i=1/9{
	gen BP_CONTINUOUS_EXTEN`i' = 0 if hhid0`i' < . 
	replace BP_CONTINUOUS_EXTEN`i' = 1 if hhid0`i' < . & BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < .
	}

// For intensive margins (continuous), there are gaps between first received and actual receipts as they are not recorded every year. For sensitivity check how much gaps between absorbing status and actual records, use BP_FIRST_ABSORB and BP_CONTINUOUS_EXTEN.		

// FLAGS
forval i=1/9{
	gen household_type`i' = -1 if hhid0`i' < . // -1 for flag
	bysort cid0`i': gen coupleflag`i' = (_N > 1) if hhid0`i' < .
	bysort hhid0`i': gen hhflag`i' = (_N > 1) if hhid0`i' < .
	// whether live with one of any children
	gen lwchildren`i' = 0 if hhid0`i' < .
	// whether live with one of siblings
	gen lwsiblings`i' = 0 if hhid0`i' < . 
	// whether live with elderly parents (respondents')
	gen lwparents`i' = 0 if hhid0`i' < . 
	forval j=1/9{ 
	replace lwchildren`i' = 1 if w0`i'Ba013_0`j'==1 & hhid0`i' < . 
	replace lwsiblings`i' = 1 if w0`i'Bb003_0`j'==1 & hhid0`i' < . 
	replace lwparents`i' = 1 if w0`i'bp1_1==1 & hhid0`i' < . 
	}	
}

// BP AT THE HOUSEHOLD LEVEL
forval i=1/9{
bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop BPsum`i'	
}

// BP SCALE: DIVIDE BY 10,000KRW + YEARLY AMOUNT
forval i=1/9{
	replace BP_CONTINUOUS_AMOUNT`i' = 12*(BP_CONTINUOUS_AMOUNT`i'/10000) if BP_CONTINUOUS_AMOUNT`i'>0 & BP_CONTINUOUS_AMOUNT`i' < . & hhid0`i'<.
}

*************************
// 2. BINARY TREATMENT //
*************************
// For absorbing state of the first treated 

// Record for transfer is n-1 year e.g. 2008 wave contains transfers information for Jan-Dec 2007 
forval i = 1/9{
	gen BP_FIRST`i' = 0 if hhid0`i' < .
}

// 2006 & 2008 surveys: 2005 & 2007 transfers 
* BP == 0: pre-trend 
replace BP_FIRST1 = 0 if hhid01 < .
replace BP_FIRST2 = 0 if hhid02 < .

// 2010 survey: 2009 Jan-Dec transfers 
* BP == 1: 2008 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{
replace BP_FIRST3 = 1 if hhid03 < . & w0`i'basic_start >= 200800 & w0`i'basic_start <= 200812
}

replace BP_FIRST3 = 1 if hhid03 < . & BP_CONTINUOUS_EXTEN3 == 1 // Actual receipt in 2008

// 2012 survey: 2011 Jan-Dec transfers 
* BP == 1: 2009-2010 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{
replace BP_FIRST4 = 1 if hhid04 < . & w0`i'basic_start >= 200900 & w0`i'basic_start <= 201012 & BP_FIRST3 == 0
}

replace BP_FIRST4 = 1 if  hhid04 < . & BP_CONTINUOUS_EXTEN4 == 1 & BP_FIRST3 == 0 // Actual receipt in 2010

// 2014 survey: 2013 Jan-Dec transfers 
* BP == 1: 2011-2012 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{
replace BP_FIRST5 = 1 if hhid05 < . & w0`i'basic_start >= 201100 & w0`i'basic_start <= 201212 & BP_FIRST3 == 0 & BP_FIRST4 == 0
}

replace BP_FIRST5 = 1 if  hhid05 < . & BP_CONTINUOUS_EXTEN5 == 1 & BP_FIRST3 == 0 & BP_FIRST4 == 0 // Actual receipt in 2012

// 2016 survey: 2015 Jan-Dec transfers 
* BP == 1: 2013-2014 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{
replace BP_FIRST6 = 1 if hhid06 < . & w0`i'basic_start >= 201300 & w0`i'basic_start <= 201412 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0
}

replace BP_FIRST6 = 1 if  hhid06 < . & BP_CONTINUOUS_EXTEN6 == 1 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 // Actual receipt in 2014

// 2018 survey: 2017 Jan-Dec transfers 
* BP == 1: 2015-2016 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{
replace BP_FIRST7 = 1 if hhid07 < . & w0`i'basic_start >= 201500 & w0`i'basic_start <= 201612 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 & BP_FIRST6 == 0
}

replace BP_FIRST7 = 1 if hhid07 < . & BP_CONTINUOUS_EXTEN7 == 1 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 & BP_FIRST5 == 0 // Actual receipt in 2015 (from wave 6, the actual receipt is the year before the survey)


// 2020 survey: 2019 Jan-Dec transfers 
* BP == 1: 2017-2018 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{
replace BP_FIRST8 = 1 if hhid08 < . & w0`i'basic_start >= 201700 & w0`i'basic_start <= 201812 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 & BP_FIRST6 == 0 & BP_FIRST7 == 0
}

// Actual receipt in 2017
replace BP_FIRST8 = 1 if hhid08 < . & BP_CONTINUOUS_EXTEN8 == 1 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 & BP_FIRST6 == 0 & BP_FIRST7 == 0

// 2022 survey: 2021 Jan-Dec transfers 
* BP == 1: 2019-2020 Jan-Dec 
// First date started to receive BP 
forval i=9(-1)5{ // For the last data treatment, I included 2021 Jan as transfers are yearly amount and inclusion has minimal effects 
replace BP_FIRST9 = 1 if hhid09 < . & w0`i'basic_start >= 201900 & w0`i'basic_start <= 202012 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 & BP_FIRST6 == 0 & BP_FIRST7 == 0 & BP_FIRST8 == 0
}

// Actual receipt in 2019
replace BP_FIRST9 = 1 if hhid09 < . & BP_CONTINUOUS_EXTEN9 == 1 & BP_FIRST3 == 0 & BP_FIRST4 == 0 & BP_FIRST5 == 0 & BP_FIRST6 == 0 & BP_FIRST7 == 0 & BP_FIRST8 == 0

// Last year control group 
gen last = 0 
replace last = 1 if hhid09 < . & w09basic_start >= 202100 & w09basic_start <= 202112 
replace last = 1 if hhid09 < . & w09G111 == 1 

*************************************
// 3. BINARY TREATMENT (ABSORBING) //
*************************************
forval i=1/9{
	gen BP_FIRST_ABSORB`i' = BP_FIRST`i' if hhid0`i' < .
}

forval i=3/8{
	local j = `i' + 1
replace BP_FIRST_ABSORB`j' = 1 if BP_FIRST_ABSORB`i' == 1 & hhid0`j' < . 
}

// Check (active if you want to check)
*order BP_FIRST_ABSORB1-BP_FIRST_ABSORB9, after(pid)
*edit

	
***************
// SAVE DATA //
***************
save Sample, replace 