*******************************************
* 3.Transfer_Construction_KLoSA.do		  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 05/03/2024			  *
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
use Sample.dta

*******************************
///  VARIABLE CONSTRUCTION  ///
*******************************
// FINANCIAL TRANFSERS (DEPENDENT VARIABLES)

**********************************************************************
/// EXTENSIVE MARAGIN FROM ANY CHILD (CORESIDENT + NON-CORESIDENT) ///
**********************************************************************
forval i=1/9{
	gen FROMCHILD_EXTEN_TOTAL`i' = 0 if hhid0`i' < . 
	replace FROMCHILD_EXTEN_TOTAL`i' = 1 if  w0`i'fromchildren < . & w0`i'fromchildren >0 & hhid0`i' < .
	}

********************************************************
/// EXTENSIVE MARGIN FROM ANY CHILD (NON-CORESIDENT) ///
********************************************************
// IRREGULAR 
forval i=1/9{
	gen FROMCHILD_NON_EXTEN_IRREGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_NON_EXTEN_IRREGULAR`i' = 1 if w01Ba021m02_0`j' == 1 &  FROMCHILD_NON_EXTEN_IRREGULAR`i' == 0 & hhid0`i' < . 
}
}
	
// REGULAR 
forval i=1/9{
	gen FROMCHILD_NON_EXTEN_REGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_NON_EXTEN_REGULAR`i' = 1 if w01Ba021m01_0`j' == 1 &  FROMCHILD_NON_EXTEN_IRREGULAR`i' == 0 & hhid0`i' < . 
}
}

// SUM
forval i=1/9{
	gen FROMCHILD_NON_EXTEN_SUM`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_NON_EXTEN_SUM`i' = 1 if (FROMCHILD_NON_EXTEN_REGULAR`i' == 1 | FROMCHILD_NON_EXTEN_IRREGULAR`i' == 1) & hhid0`i' < . 
}
}

// PRODUCTS
forval i=1/9{
	gen FROMCHILD_NON_EXTEN_GOODS`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_NON_EXTEN_GOODS`i' = 1 if w01Ba021m03_0`j' == 1 &  FROMCHILD_NON_EXTEN_GOODS`i' == 0 & hhid0`i' < . 
}
}

***********************************************
/// EXTENSIVE MARAGIN FROM CORESIDENT CHILD ///
***********************************************
// SUM
forval i=1/9{
	gen FROMCHILD_CO_EXTEN_SUM`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_CO_EXTEN_SUM`i' = 1 if w0`i'Ba053_0`j' == 1 & hhid0`i' < . 
}
}
replace FROMCHILD_CO_EXTEN_SUM1 = 1 if indicator1 == 1 & FROMCHILD_EXTEN_TOTAL1 == 1 & hhid01 < . 


*****************************
/// EXTENSIVE MARAGIN SUM ///
*****************************
// SUM
forval i=1/9{
	gen FROMCHILD_EXTEN_SUM`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_EXTEN_SUM`i' = 1 if (FROMCHILD_CO_EXTEN_SUM`i' == 1 | FROMCHILD_NON_EXTEN_SUM`i' == 1) & hhid0`i' < .
}
}


********************************************************************
/// EXTENSIVE MARAGIN TO ANY CHILD (CORESIDENT + NON-CORESIDENT) ///
********************************************************************
forval i=1/9{
	gen TOCHILD_EXTEN_TOTAL`i' = 0 if hhid0`i' < . 
	replace TOCHILD_EXTEN_TOTAL`i' = 1 if  w0`i'tochildren > 0 &  w0`i'tochildren < . & hhid0`i' < .
	}

********************************************************
/// EXTENSIVE MARGIN TO ANY CHILD (NON-CORESIDENT) ///
********************************************************
// IRREGULAR 
forval i=1/9{
	gen TOCHILD_NON_EXTEN_IRREGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_NON_EXTEN_IRREGULAR`i' = 1 if w01Ba037m02_0`j' == 1 &  TOCHILD_NON_EXTEN_IRREGULAR`i' == 0 & hhid0`i' < . 
}
}
	
// REGULAR 
forval i=1/9{
	gen TOCHILD_NON_EXTEN_REGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_NON_EXTEN_REGULAR`i' = 1 if w01Ba037m01_0`j' == 1 &  TOCHILD_NON_EXTEN_IRREGULAR`i' == 0 & hhid0`i' < . 
}
}

// SUM
forval i=1/9{
	gen TOCHILD_NON_EXTEN_SUM`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_NON_EXTEN_SUM`i' = 1 if (TOCHILD_NON_EXTEN_REGULAR`i' == 1 | TOCHILD_NON_EXTEN_IRREGULAR`i' == 1) & hhid0`i' < . 
}
}

// PRODUCTS
forval i=1/9{
	gen TOCHILD_NON_EXTEN_GOODS`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_NON_EXTEN_GOODS`i' = 1 if w01Ba037m03_0`j' == 1 &  TOCHILD_NON_EXTEN_GOODS`i' == 0 & hhid0`i' < . 
}
}


***********************************************
/// EXTENSIVE MARAGIN FROM CORESIDENT CHILD ///
***********************************************
// SUM
forval i=1/9{
	gen TOCHILD_CO_EXTEN_SUM`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_CO_EXTEN_SUM`i' = 1 if w0`i'Ba060_0`j' == 1 & hhid0`i' < . 
}
}
replace TOCHILD_CO_EXTEN_SUM1 = 1 if indicator1 == 1 & TOCHILD_EXTEN_TOTAL1 == 1 & hhid01 < . 

*****************************
/// EXTENSIVE MARAGIN SUM ///
*****************************
// SUM
forval i=1/9{
	gen TOCHILD_EXTEN_SUM`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_EXTEN_SUM`i' = 1 if (TOCHILD_CO_EXTEN_SUM`i' == 1 | TOCHILD_NON_EXTEN_SUM`i' == 1) & hhid0`i' < .
}
}

**********************************************************************
/// INTENSIVE MARGIN FROM ANY CHILD (CORESIDENT + NON-CORESIDENT) ///
**********************************************************************
forval i=1/9{
	gen FROMCHILD_INTEN_TOTAL`i' = 0 if hhid0`i' < . 
	replace FROMCHILD_INTEN_TOTAL`i' = w0`i'fromchildren if hhid0`i' < . & w0`i'fromchildren < . & w0`i'fromchildren > 0
	egen mean`i' = mean(FROMCHILD_INTEN_TOTAL`i') if FROMCHILD_INTEN_TOTAL`i' < . 
	replace FROMCHILD_INTEN_TOTAL`i' = mean`i' if FROMCHILD_INTEN_TOTAL`i' < 0 & hhid0`i' < . 
	drop mean`i'
// A few respondents didn't want to tell the amount though received. Mean imputed for these few responses (less than 0.5% of the sample). 	
}

********************************************************
/// INTENSIVE MARGIN FROM ANY CHILD (NON-CORESIDENT) ///
********************************************************
// IRREGULAR 
forval i=1/9{
	gen FROMCHILD_NON_INTEN_IRREGULAR`i' = 0  if hhid0`i' < .
	
	replace w01Ba029_0`i' = 50 if w01Ba029_0`i'ct == 1 & hhid01 < . & w01Ba029_0`i' < 0
	replace w01Ba029_0`i' = 100 if w01Ba029_0`i'ct == 2 & hhid01 < . & w01Ba029_0`i' < 0
	replace w01Ba029_0`i' = 200 if w01Ba029_0`i'ct == 3 & hhid01 < . & w01Ba029_0`i' < 0

forval k = 1/6{
	replace w02Ba029_0`k' = 50 if w02Ba029_0`k'ct == 1 & hhid02 < . & w02Ba029_0`k' < 0
	replace w02Ba029_0`k' = 100 if w02Ba029_0`k'ct == 2 & hhid02 < . & w02Ba029_0`k' < 0
	replace w02Ba029_0`k' = 200 if w02Ba029_0`k'ct == 3 & hhid02 < . & w02Ba029_0`k' < 0
}
	
	egen wave`i' = rowtotal(w0`i'Ba029_01-w0`i'Ba029_09) if (w0`i'Ba029_01 < . | w0`i'Ba029_02 < . | w0`i'Ba029_03 < . | w0`i'Ba029_04 < . | w0`i'Ba029_05 < . | w0`i'Ba029_06 < . | w0`i'Ba029_07 < . | w0`i'Ba029_08 < . | w0`i'Ba029_09 < .) & (w0`i'Ba029_01 > 0 | w0`i'Ba029_02 > 0 | w0`i'Ba029_03 > 0 | w0`i'Ba029_04 > 0 | w0`i'Ba029_05 > 0 | w0`i'Ba029_06 > 0 | w0`i'Ba029_07 > 0 | w0`i'Ba029_08 > 0 | w0`i'Ba029_09 > 0) & hhid0`i' < .  // sum transfers from 9 children at the household level 
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = wave`i' if wave`i' < . & hhid0`i' < . 
	drop wave`i'
	egen mean`i' = mean(FROMCHILD_NON_INTEN_IRREGULAR`i') if hhid0`i' < . & FROMCHILD_NON_INTEN_IRREGULAR`i' < .
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = mean`i' if FROMCHILD_NON_INTEN_IRREGULAR`i' < 0 & hhid0`i' < . 
	drop mean`i'		
}
	
	
// REGULAR: monthly amount x months actually transferred 
forval i=1/9{
gen FROMCHILD_NON_INTEN_REGULAR`i' = 0  if hhid0`i' < .
	replace w01Ba022_0`i' = 5 if w01Ba022_0`i'ct == 1 & hhid01 < .
	replace w01Ba022_0`i' = 100 if w01Ba022_0`i'ct == 8 & hhid01 < .
	replace w01Ba022_0`i' = 200 if w01Ba022_0`i'ct == 10 & hhid01 < .
	
forval j=1/9{
	egen mean`i'_`j' = mean(w0`i'Ba028_0`j'w5) if w0`i'Ba028_0`j'w5 <.
	replace w0`i'Ba028_0`j'w5 = mean`i'_`j' if w0`i'Ba028_0`j'w5 < 0 & hhid0`i' < . 
	drop mean`i'_`j'
	egen mean`i'_`j' = mean(w0`i'Ba022_0`j') if w0`i'Ba022_0`j'<.
	replace w0`i'Ba022_0`j' = mean`i'_`j' if w0`i'Ba022_0`j' < 0 & hhid0`i' < . 
	drop mean`i'_`j'

gen wave`i'_`j' = 	w0`i'Ba022_0`j'*w0`i'Ba028_0`j'w5 if w0`i'Ba022_0`j' > 0 & w0`i'Ba022_0`j' < . & w0`i'Ba028_0`j'w5 > 0 & w0`i'Ba028_0`j'w5 <. & hhid0`i' < . // Actual month * amount 
}

egen wave`i' = rowtotal(wave`i'_1-wave`i'_9) if (wave`i'_1 < . | wave`i'_2 < . | wave`i'_3 < . | wave`i'_4 < . | wave`i'_5 < . | wave`i'_6 < . | wave`i'_7 < . | wave`i'_8 < . | wave`i'_9 < .) & (wave`i'_1 > 0 | wave`i'_2 > 0 | wave`i'_3 > 0 | wave`i'_4 > 0 | wave`i'_5 > 0 | wave`i'_6 > 0 | wave`i'_7 > 0 | wave`i'_8 > 0 | wave`i'_9 > 0) & hhid0`i' < . // Sum all 9 children's transfers
	replace FROMCHILD_NON_INTEN_REGULAR`i' = wave`i' if hhid0`i' < . & wave`i' < . 
	drop wave`i'
	egen mean`i'= mean(FROMCHILD_NON_INTEN_REGULAR`i') if FROMCHILD_NON_INTEN_REGULAR`i' < .  & hhid0`i' < .
	replace FROMCHILD_NON_INTEN_REGULAR`i' = mean`i' if FROMCHILD_NON_INTEN_REGULAR`i' < 0 & hhid0`i' < . 
	drop mean`i'
	forval j=1/9{
		drop wave`i'_`j'
	}
	}

// SUM = REGULAR + IRREGULAR
forval i=1/9{
egen FROMCHILD_NON_INTEN_SUM`i' = rowtotal(FROMCHILD_NON_INTEN_REGULAR`i'  FROMCHILD_NON_INTEN_IRREGULAR`i') if hhid0`i'<. 
}

*****************************************************
/// INTENSIVE MARAGIN FROM ANY CHILD (CORESIDENT) ///
*****************************************************
forval i=1/9{
	gen FROMCHILD_CO_INTEN_SUM`i' = 0 if hhid0`i' < . 
	egen wave`i' = rowtotal(w0`i'Ba054_01-w0`i'Ba054_09) if (w0`i'Ba054_01 < . | w0`i'Ba054_02 < . | w0`i'Ba054_03 < . | w0`i'Ba054_04 < . | w0`i'Ba054_05 < . | w0`i'Ba054_06 < . | w0`i'Ba054_07 < . | w0`i'Ba054_08 < . | w0`i'Ba054_09 < .) & (w0`i'Ba054_01 > 0 | w0`i'Ba054_02 > 0 | w0`i'Ba054_03 > 0 | w0`i'Ba054_04 > 0 | w0`i'Ba054_05 > 0 | w0`i'Ba054_06 > 0 | w0`i'Ba054_07 > 0 | w0`i'Ba054_08 > 0 | w0`i'Ba054_09 > 0) & hhid0`i' < .  // sum transfers from 9 children at the household level 
	replace FROMCHILD_CO_INTEN_SUM`i' = wave`i' if wave`i' < . & hhid0`i' < . 
	drop wave`i'
	egen mean`i' = mean(FROMCHILD_CO_INTEN_SUM`i') if  FROMCHILD_CO_INTEN_SUM`i' < .  & hhid0`i' < .
	replace FROMCHILD_CO_INTEN_SUM`i' = mean`i' if FROMCHILD_CO_INTEN_SUM`i' < 0 & hhid0`i' < . 
	drop mean`i'
	}

// Wave1 amount for coresident children not given; non-identifiable but wave 2 will be also used as pretrend so no problem.

****************************************
/// INTENSIVE MARAGIN FROM ANY CHILD ///
****************************************
// SUM = CORES + NON-CORES
forval i=1/9{
egen FROMCHILD_INTEN_SUM`i' =  rowtotal(FROMCHILD_NON_INTEN_SUM`i' FROMCHILD_CO_INTEN_SUM`i') if hhid0`i'<.  
}
	
**********************************************************************
/// INTENSIVE MARGIN TO ANY CHILD (CORESIDENT + NON-CORESIDENT) ///
**********************************************************************
forval i=1/9{
	gen TOCHILD_INTEN_TOTAL`i' = 0 if hhid0`i' < . 
	replace TOCHILD_INTEN_TOTAL`i' = w0`i'tochildren if hhid0`i' < . & w0`i'tochildren < . 
	egen mean`i' = mean(TOCHILD_INTEN_TOTAL`i') if TOCHILD_INTEN_TOTAL`i' < .
	replace TOCHILD_INTEN_TOTAL`i' = mean`i' if TOCHILD_INTEN_TOTAL`i' < 0 & hhid0`i' < . 
	drop mean`i'
// a few respondents didn't want to tell the amount though received. Mean imputed for these few responses (less than 0.5% of the sample). 	
}

******************************************************
/// INTENSIVE MARGIN TO ANY CHILD (NON-CORESIDENT) ///
******************************************************
// IRREGULAR 
forval i=1/9{
	gen TOCHILD_NON_INTEN_IRREGULAR`i' = 0  if hhid0`i' < .
	
	replace w01Ba045_0`i' = 50 if w01Ba045_0`i'ct == 1 & hhid01 < . & w01Ba045_0`i' < 0
	replace w01Ba045_0`i' = 100 if w01Ba045_0`i'ct == 2 & hhid01 < . & w01Ba045_0`i' < 0
	replace w01Ba045_0`i' = 200 if w01Ba045_0`i'ct == 3 & hhid01 < . & w01Ba045_0`i' < 0
	
	egen wave`i' = rowtotal(w0`i'Ba045_01-w0`i'Ba045_09) if (w0`i'Ba045_01 < . | w0`i'Ba045_02 < . | w0`i'Ba045_03 < . | w0`i'Ba045_04 < . | w0`i'Ba045_05 < . | w0`i'Ba045_06 < . | w0`i'Ba045_07 < . | w0`i'Ba045_08 < . | w0`i'Ba045_09 < .) & (w0`i'Ba045_01 > 0 | w0`i'Ba045_02 > 0 | w0`i'Ba045_03 > 0 | w0`i'Ba045_04 > 0 | w0`i'Ba045_05 > 0 | w0`i'Ba045_06 > 0 | w0`i'Ba045_07 > 0 | w0`i'Ba045_08 > 0 | w0`i'Ba045_09 > 0) & hhid0`i' < .  // sum transfers from 9 children at the household level 
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = wave`i' if wave`i' < . & hhid0`i' < . 
	drop wave`i'
	egen mean`i' = mean(TOCHILD_NON_INTEN_IRREGULAR`i') if hhid0`i' < . & TOCHILD_NON_INTEN_IRREGULAR`i' < . 
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = mean`i' if TOCHILD_NON_INTEN_IRREGULAR`i' < 0 & hhid0`i' < . 
	drop mean`i'
		}
	
// REGULAR: monthly amount x months actually transferred 
forval i=1/9{
gen TOCHILD_NON_INTEN_REGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	egen mean`i'_`j' = mean(w0`i'Ba046_0`j'w5) if w0`i'Ba046_0`j'w5 < .
	replace w0`i'Ba046_0`j'w5 = mean`i'_`j' if w0`i'Ba046_0`j'w5 < 0 & hhid0`i' < . 
	drop mean`i'_`j'
	egen mean`i'_`j' = mean(w0`i'Ba038_0`j') if w0`i'Ba038_0`j' < .
	replace w0`i'Ba038_0`j' = mean`i'_`j' if w0`i'Ba038_0`j' < 0 & hhid0`i' < . 
	drop mean`i'
	gen wave`i'_`j' = 	w0`i'Ba038_0`j'*w0`i'Ba046_0`j'w5 if w0`i'Ba038_0`j' > 0 & w0`i'Ba038_0`j' < . & w0`i'Ba046_0`j'w5 > 0 & w0`i'Ba046_0`j'w5 <. & hhid0`i' < . // Actual month * amount 
	}
	
	egen wave`i' = rowtotal(wave`i'_1-wave`i'_9) if (wave`i'_1 < . | wave`i'_2 < . | wave`i'_3 < . | wave`i'_4 < . | wave`i'_5 < . | wave`i'_6 < . | wave`i'_7 < . | wave`i'_8 < . | wave`i'_9 < .) & (wave`i'_1 > 0 | wave`i'_2 > 0 | wave`i'_3 > 0 | wave`i'_4 > 0 | wave`i'_5 > 0 | wave`i'_6 > 0 | wave`i'_7 > 0 | wave`i'_8 > 0 | wave`i'_9 > 0) & hhid0`i' < . // Sum all 9 children's transfers
	replace TOCHILD_NON_INTEN_REGULAR`i' = wave`i' if hhid0`i' < . & wave`i' < . 
	drop wave`i'
	egen mean`i'= mean(TOCHILD_NON_INTEN_REGULAR`i') if TOCHILD_NON_INTEN_REGULAR`i' < .  & hhid0`i' < .
	replace TOCHILD_NON_INTEN_REGULAR`i' = mean`i' if TOCHILD_NON_INTEN_REGULAR`i' < 0 & hhid0`i' < . 
	drop mean`i'
	forval j=1/9{
	drop wave`i'_`j'
	}
	}

// SUM = REGULAR + IRREGULAR
forval i=1/9{
egen TOCHILD_NON_INTEN_SUM`i' = rowtotal(TOCHILD_NON_INTEN_REGULAR`i'  TOCHILD_NON_INTEN_IRREGULAR`i') if hhid0`i'<. 
}

***************************************************
/// INTENSIVE MARAGIN TO ANY CHILD (CORESIDENT) ///
***************************************************
forval i=1/9{
	gen TOCHILD_CO_INTEN_SUM`i' = 0 if hhid0`i' < . 
	egen wave`i'= rowtotal(w0`i'Ba061_01-w0`i'Ba061_09) if (w0`i'Ba061_01 < . | w0`i'Ba061_02 < . | w0`i'Ba061_03 < . | w0`i'Ba061_04 < . | w0`i'Ba061_05 < . | w0`i'Ba061_06 < . | w0`i'Ba061_07 < . | w0`i'Ba061_08 < . | w0`i'Ba061_09 < .) & (w0`i'Ba061_01 > 0 | w0`i'Ba061_02 > 0 | w0`i'Ba061_03 > 0 | w0`i'Ba061_04 > 0 | w0`i'Ba061_05 > 0 | w0`i'Ba061_06 > 0 | w0`i'Ba061_07 > 0 | w0`i'Ba061_08 > 0 | w0`i'Ba061_09 > 0) & hhid0`i' < .  // sum transfers from 9 children at the household level 
	replace TOCHILD_CO_INTEN_SUM`i' = wave`i' if wave`i' < . & hhid0`i' < . 
	drop wave`i'
	egen mean`i' = mean(TOCHILD_CO_INTEN_SUM`i') if  TOCHILD_CO_INTEN_SUM`i' < .  & hhid0`i' < .
	replace TOCHILD_CO_INTEN_SUM`i' = mean`i' if TOCHILD_CO_INTEN_SUM`i' < 0 & hhid0`i' < . 
	drop mean`i'	
}

// Wave 1 amount for coresident children not given; non-identifiable 

**************************************
/// INTENSIVE MARAGIN TO ANY CHILD ///
**************************************
// SUM = CORES + NON-CORES
forval i=1/9{
egen TOCHILD_INTEN_SUM`i' =  rowtotal(TOCHILD_NON_INTEN_SUM`i' TOCHILD_CO_INTEN_SUM`i') if hhid0`i'<.  
}

****************************************
/// TRANSFERS AT THE HOUSEHOLD LEVEL ///
****************************************
forval i=1/9{
bysort cid0`i': replace FROMCHILD_INTEN_TOTAL`i' = FROMCHILD_INTEN_TOTAL`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen FROMCHILD_INTEN_TOTALsum`i' = total(FROMCHILD_INTEN_TOTAL`i') if FROMCHILD_INTEN_TOTAL`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_INTEN_TOTAL`i' = FROMCHILD_INTEN_TOTALsum`i' if FROMCHILD_INTEN_TOTALsum`i' < . & FROMCHILD_INTEN_TOTALsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_EXTEN_TOTAL`i' = 1 if FROMCHILD_EXTEN_TOTAL`i' == 0 & FROMCHILD_INTEN_TOTALsum`i' < . & FROMCHILD_INTEN_TOTALsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop FROMCHILD_INTEN_TOTALsum`i'

bysort cid0`i': replace FROMCHILD_NON_INTEN_IRREGULAR`i' = FROMCHILD_NON_INTEN_IRREGULAR`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen FROMCHILD_NON_INTEN_IRREGsum`i' = total(FROMCHILD_NON_INTEN_IRREGULAR`i') if FROMCHILD_NON_INTEN_IRREGULAR`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_NON_INTEN_IRREGULAR`i' = FROMCHILD_NON_INTEN_IRREGsum`i' if FROMCHILD_NON_INTEN_IRREGsum`i' < . & FROMCHILD_NON_INTEN_IRREGsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_NON_EXTEN_IRREGULAR`i' = 1 if FROMCHILD_NON_EXTEN_IRREGULAR`i' == 0 & FROMCHILD_NON_INTEN_IRREGsum`i' < . & FROMCHILD_NON_INTEN_IRREGsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop FROMCHILD_NON_INTEN_IRREGsum`i'

bysort cid0`i': replace FROMCHILD_NON_INTEN_REGULAR`i' = FROMCHILD_NON_INTEN_REGULAR`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen FROMCHILD_NON_INTEN_REGULARsum`i' = total(FROMCHILD_NON_INTEN_REGULAR`i') if FROMCHILD_NON_INTEN_REGULAR`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_NON_INTEN_REGULAR`i' = FROMCHILD_NON_INTEN_REGULARsum`i' if FROMCHILD_NON_INTEN_REGULARsum`i' < . & FROMCHILD_NON_INTEN_REGULARsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_NON_EXTEN_REGULAR`i' = 1 if FROMCHILD_NON_EXTEN_REGULAR`i' == 0 & FROMCHILD_NON_INTEN_REGULARsum`i' < . & FROMCHILD_NON_INTEN_REGULARsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop FROMCHILD_NON_INTEN_REGULARsum`i'

bysort cid0`i': replace FROMCHILD_NON_INTEN_SUM`i' = FROMCHILD_NON_INTEN_SUM`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen FROMCHILD_NON_INTEN_SUMsum`i' = total(FROMCHILD_NON_INTEN_SUM`i') if FROMCHILD_NON_INTEN_SUM`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_NON_INTEN_SUM`i' = FROMCHILD_NON_INTEN_SUMsum`i' if FROMCHILD_NON_INTEN_SUMsum`i' < . & FROMCHILD_NON_INTEN_SUMsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_NON_EXTEN_SUM`i' = 1 if FROMCHILD_NON_EXTEN_SUM`i' == 0 & FROMCHILD_NON_INTEN_SUMsum`i' < . & FROMCHILD_NON_INTEN_SUMsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop FROMCHILD_NON_INTEN_SUMsum`i'

bysort cid0`i': replace FROMCHILD_CO_INTEN_SUM`i' = FROMCHILD_CO_INTEN_SUM`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen FROMCHILD_CO_INTEN_SUMsum`i' = total(FROMCHILD_CO_INTEN_SUM`i') if FROMCHILD_CO_INTEN_SUM`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_CO_INTEN_SUM`i' = FROMCHILD_CO_INTEN_SUMsum`i' if FROMCHILD_CO_INTEN_SUMsum`i' < . & FROMCHILD_CO_INTEN_SUMsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_CO_EXTEN_SUM`i' = 1 if FROMCHILD_CO_EXTEN_SUM`i' == 0 & FROMCHILD_CO_INTEN_SUMsum`i' < . & FROMCHILD_CO_INTEN_SUMsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop FROMCHILD_CO_INTEN_SUMsum`i'

bysort cid0`i': replace FROMCHILD_INTEN_SUM`i' = FROMCHILD_INTEN_SUM`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen FROMCHILD_INTEN_SUMsum`i' = total(FROMCHILD_INTEN_SUM`i') if FROMCHILD_CO_INTEN_SUM`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_INTEN_SUM`i' = FROMCHILD_INTEN_SUMsum`i' if FROMCHILD_INTEN_SUMsum`i' < . & FROMCHILD_INTEN_SUMsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace FROMCHILD_EXTEN_SUM`i' = 1 if FROMCHILD_EXTEN_SUM`i' == 0 & FROMCHILD_INTEN_SUMsum`i' < . & FROMCHILD_INTEN_SUMsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop FROMCHILD_INTEN_SUMsum`i'

bysort cid0`i': replace TOCHILD_INTEN_TOTAL`i' = TOCHILD_INTEN_TOTAL`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_INTEN_TOTALsum`i' = total(TOCHILD_INTEN_TOTAL`i') if TOCHILD_INTEN_TOTAL`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_INTEN_TOTAL`i' = TOCHILD_INTEN_TOTALsum`i' if TOCHILD_INTEN_TOTALsum`i' < . & TOCHILD_INTEN_TOTALsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_EXTEN_TOTAL`i' = 1 if TOCHILD_EXTEN_TOTAL`i' == 0 & TOCHILD_INTEN_TOTALsum`i' < . & TOCHILD_INTEN_TOTALsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_INTEN_TOTALsum`i'

bysort cid0`i': replace TOCHILD_NON_INTEN_IRREGULAR`i' = TOCHILD_NON_INTEN_IRREGULAR`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_NON_INTEN_IRREGULARsum`i' = total(TOCHILD_NON_INTEN_IRREGULAR`i') if TOCHILD_NON_INTEN_IRREGULAR`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_NON_INTEN_IRREGULAR`i' = TOCHILD_NON_INTEN_IRREGULARsum`i' if TOCHILD_NON_INTEN_IRREGULARsum`i' < . & TOCHILD_NON_INTEN_IRREGULARsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_NON_EXTEN_IRREGULAR`i' = 1 if TOCHILD_NON_EXTEN_IRREGULAR`i' == 0 & TOCHILD_NON_INTEN_IRREGULARsum`i' < . & TOCHILD_NON_INTEN_IRREGULARsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_NON_INTEN_IRREGULARsum`i'

bysort cid0`i': replace TOCHILD_NON_INTEN_REGULAR`i' = TOCHILD_NON_INTEN_REGULAR`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_NON_INTEN_REGULARsum`i' = total(TOCHILD_NON_INTEN_REGULAR`i') if TOCHILD_NON_INTEN_REGULAR`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_NON_INTEN_REGULAR`i' = TOCHILD_NON_INTEN_REGULARsum`i' if TOCHILD_NON_INTEN_REGULARsum`i' < . & TOCHILD_NON_INTEN_REGULARsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_NON_EXTEN_REGULAR`i' = 1 if TOCHILD_NON_EXTEN_REGULAR`i' == 0 & TOCHILD_NON_INTEN_REGULARsum`i' < . & TOCHILD_NON_INTEN_REGULARsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_NON_INTEN_REGULARsum`i'

bysort cid0`i': replace TOCHILD_NON_INTEN_SUM`i' = TOCHILD_NON_INTEN_SUM`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_NON_INTEN_SUMsum`i' = total(TOCHILD_NON_INTEN_SUM`i') if TOCHILD_NON_INTEN_SUM`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_NON_INTEN_SUM`i' = TOCHILD_NON_INTEN_SUMsum`i' if TOCHILD_NON_INTEN_SUMsum`i' < . & TOCHILD_NON_INTEN_SUMsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_NON_EXTEN_SUM`i' = 1 if TOCHILD_NON_EXTEN_SUM`i' == 0 & TOCHILD_NON_INTEN_SUMsum`i' < . & TOCHILD_NON_INTEN_SUMsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_NON_INTEN_SUMsum`i'

bysort cid0`i': replace TOCHILD_CO_INTEN_SUM`i' = TOCHILD_CO_INTEN_SUM`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_CO_INTEN_SUMsum`i' = total(TOCHILD_CO_INTEN_SUM`i') if TOCHILD_CO_INTEN_SUM`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_CO_INTEN_SUM`i' = TOCHILD_CO_INTEN_SUMsum`i' if TOCHILD_CO_INTEN_SUMsum`i' < . & TOCHILD_CO_INTEN_SUMsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_CO_EXTEN_SUM`i' = 1 if TOCHILD_CO_EXTEN_SUM`i' == 0 & TOCHILD_CO_INTEN_SUMsum`i' < . & TOCHILD_CO_INTEN_SUMsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_CO_INTEN_SUMsum`i'

bysort cid0`i': replace TOCHILD_INTEN_SUM`i' = TOCHILD_INTEN_SUM`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_INTEN_SUMsum`i' = total(TOCHILD_INTEN_SUM`i') if TOCHILD_CO_INTEN_SUM`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_INTEN_SUM`i' = TOCHILD_INTEN_SUMsum`i' if TOCHILD_INTEN_SUMsum`i' < . & TOCHILD_INTEN_SUMsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_EXTEN_SUM`i' = 1 if TOCHILD_EXTEN_SUM`i' == 0 & TOCHILD_INTEN_SUMsum`i' < . & TOCHILD_INTEN_SUMsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_INTEN_SUMsum`i'

bysort cid0`i': replace TOCHILD_INTEN_TOTAL`i' = TOCHILD_INTEN_TOTAL`i' / 2 if hhid0`i'<. & coupleflag`i' == 1
bysort hhid0`i': egen TOCHILD_INTEN_TOTALsum`i' = total(TOCHILD_INTEN_TOTAL`i') if TOCHILD_INTEN_TOTAL`i'<. &  hhid0`i' < . & hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_INTEN_TOTAL`i' = TOCHILD_INTEN_TOTALsum`i' if TOCHILD_INTEN_TOTALsum`i' < . & TOCHILD_INTEN_TOTALsum`i' > 0 &  hhid0`i' < . &  hhflag`i'== 1
bysort hhid0`i': replace TOCHILD_EXTEN_TOTAL`i' = 1 if TOCHILD_EXTEN_TOTAL`i' == 0 & TOCHILD_INTEN_TOTALsum`i' < . & TOCHILD_INTEN_TOTALsum`i'>0 &  hhid0`i' < . & hhflag`i'== 1
drop TOCHILD_INTEN_TOTALsum`i'
}



*******************
/// SAVE SAMPLE ///
*******************
save Sample, replace
