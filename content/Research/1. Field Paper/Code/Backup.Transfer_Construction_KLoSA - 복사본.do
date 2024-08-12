*******************************************
* 3.Transfer_Construction_KLoSA.do				  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 04/27/2024			  *
*******************************************

set more off, perm
clear all
set maxvar 30000

*********************
///  IMPORT FILE  ///
*********************
// SET DIRECTORY

local dir "$root"
if "`dir'"=="" {
	local dir  "C:\Users\Yongjoon\Desktop\Research\"
	}
	
cd "C:\Users\Yongjoon\Desktop\Research\1. Unconditional cash transfers and family transfers in Korea\Data"	

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

**********************************************************************
/// INTENSIVE MARGIN FROM ANY CHILD (CORESIDENT + NON-CORESIDENT) ///
**********************************************************************
forval i=1/9{
	gen FROMCHILD_INTEN_TOTAL`i' = . if hhid0`i' < . 
	replace FROMCHILD_INTEN_TOTAL`i' = w0`i'fromchildren if hhid0`i' < . & w0`i'fromchildren < . & w0`i'fromchildren > 0
	egen mean`i' = mean(FROMCHILD_INTEN_TOTAL`i') if FROMCHILD_INTEN_TOTAL`i' > 0 & FROMCHILD_INTEN_TOTAL`i' < . 
	replace FROMCHILD_INTEN_TOTAL`i' = mean`i' if FROMCHILD_INTEN_TOTAL`i' < 0 & hhid0`i' < . 
	drop mean`i'
	replace FROMCHILD_INTEN_TOTAL`i' = 0 if FROMCHILD_INTEN_TOTAL`i' ==. & hhid0`i' < . 
// a few respondents didn't want to tell the amount though received. Mean imputed for these few responses (less than 0.5% of the sample). 	
}

********************************************************
/// INTENSIVE MARGIN FROM ANY CHILD (NON-CORESIDENT) ///
********************************************************
// IRREGULAR 
forval i=1/9{
	gen FROMCHILD_NON_INTEN_IRREGULAR`i' = .  if hhid0`i' < .
	egen wave`i' = rowtotal(w0`i'Ba029_01-w0`i'Ba029_09) if (w0`i'Ba029_01 < . | w0`i'Ba029_02 < . | w0`i'Ba029_03 < . | w0`i'Ba029_04 < . | w0`i'Ba029_05 < . | w0`i'Ba029_06 < . | w0`i'Ba029_07 < . | w0`i'Ba029_08 < . | w0`i'Ba029_09 < .) & (w0`i'Ba029_01 > 0 | w0`i'Ba029_02 > 0 | w0`i'Ba029_03 > 0 | w0`i'Ba029_04 > 0 | w0`i'Ba029_05 > 0 | w0`i'Ba029_06 > 0 | w0`i'Ba029_07 > 0 | w0`i'Ba029_08 > 0 | w0`i'Ba029_09 > 0) & hhid0`i' < .  // sum transfers from 9 children at the household level 
	
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = wave`i' if w0`i'wave`i' < . & hhid0`i' < . 
}
	
	egen mean`i' = mean(w0`i'Ba029_0`j') if hhid0`i' < . & w0`i'Ba029_0`j' > 0 & w0`i'Ba029_0`j' < . 
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = mean`i' if FROMCHILD_NON_INTEN_IRREGULAR`i' < 0 & hhid0`i' < . 
	drop mean`i'		
	}
replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 0 if FROMCHILD_NON_INTEN_IRREGULAR`i' == .  & hhid0`i' < . 
}
	
// REGULAR: monthly amount x months actually transferred 
forval i=1/9{
gen FROMCHILD_NON_INTEN_REGULAR`i' = 0  if hhid0`i' < .
	replace w01Ba022_0`i' = 5 if w01Ba022_0`i'ct == 1 & hhid0`i' < .
	replace w01Ba022_0`i' = 100 if w01Ba022_0`i'ct == 8 & hhid0`i' < .
	replace w01Ba022_0`i' = 200 if w01Ba022_0`i'ct == 10 & hhid0`i' < .
	forval j=1/9{
	egen mean`i' = mean(w0`i'Ba028_0`j'w5) if w0`i'Ba028_0`j'w5 >0 & w0`i'Ba028_0`j'w5 <.
	replace w0`i'Ba028_0`j'w5 = mean`i' if w0`i'Ba028_0`j'w5 < 0 & hhid0`i' < . 
	drop mean`i'
	egen mean`i' = mean(w0`i'Ba022_0`j') if w0`i'Ba022_0`j'>0 & w0`i'Ba022_0`j'<.
	replace w0`i'Ba022_0`j' = mean`i' if w0`i'Ba022_0`j' < 0 & hhid0`i' < . 
	drop mean`i'
	replace FROMCHILD_NON_INTEN_REGULAR`i' = w0`i'Ba022_0`j'*w0`i'Ba028_0`j'w5 if w0`i'Ba022_0`j' > 0 & w0`i'Ba022_0`j' < . & w0`i'Ba028_0`j'w5 > 0 & w0`i'Ba028_0`j'w5 <. &  FROMCHILD_NON_INTEN_REGULAR`i' == 0 & hhid0`i' < .
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
	forval j=1/9{
	replace FROMCHILD_CO_INTEN_SUM`i' = w0`i'Ba054_0`j' if w0`i'Ba054_0`j' < . &  FROMCHILD_CO_INTEN_SUM`i' == 0 & hhid0`i' < . 
	egen mean`i' = mean(w0`i'Ba054_0`j') if w0`i'Ba054_0`j' > 0 & w0`i'Ba054_0`j' < . 
	replace FROMCHILD_CO_INTEN_SUM`i' = mean`i' if FROMCHILD_CO_INTEN_SUM`i' < 0 & hhid0`i' < . 
	drop mean`i'
	}
	replace FROMCHILD_CO_INTEN_SUM`i' = 0 if hhid0`i' < . & FROMCHILD_CO_INTEN_SUM`i' == .
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
	gen TOCHILD_INTEN_TOTAL`i' = . if hhid0`i' < . 
	replace TOCHILD_INTEN_TOTAL`i' = w0`i'tochildren if hhid0`i' < . & w0`i'tochildren < . 
	egen mean`i' = mean(TOCHILD_INTEN_TOTAL`i') if TOCHILD_INTEN_TOTAL`i' > 0 & TOCHILD_INTEN_TOTAL`i' < .
	replace TOCHILD_INTEN_TOTAL`i' = mean`i' if TOCHILD_INTEN_TOTAL`i' < 0 & hhid0`i' < . 
	drop mean`i'
	replace TOCHILD_INTEN_TOTAL`i' = 0 if hhid0`i' < . & TOCHILD_INTEN_TOTAL`i' == . 
// a few respondents didn't want to tell the amount though received. Mean imputed for these few responses (less than 0.5% of the sample). 	
}
















******************************************************
/// INTENSIVE MARGIN TO ANY CHILD (NON-CORESIDENT) ///
******************************************************
// IRREGULAR 
forval i=1/9{
	gen TOCHILD_NON_INTEN_IRREGULAR`i' = .  if hhid0`i' < .
	forval j=1/9{
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = w0`i'Ba045_0`j' if w0`i'Ba045_0`j' < . & hhid0`i' < . 
}
}
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = 50 if w01Ba045_0`i'ct == 1 & hhid0`i' < . & TOCHILD_NON_INTEN_IRREGULAR`i'<0
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = 100 if w01Ba045_0`i'ct == 2 & hhid0`i' < . & TOCHILD_NON_INTEN_IRREGULAR`i'<0
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = 200 if w01Ba045_0`i'ct == 3 & hhid0`i' < . & TOCHILD_NON_INTEN_IRREGULAR`i'<0
	
	egen mean`i' = mean(TOCHILD_NON_INTEN_IRREGULAR`i') if hhid0`i' < . & TOCHILD_NON_INTEN_IRREGULAR`i' > 0 & TOCHILD_NON_INTEN_IRREGULAR`i' < . 
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = mean`i' if TOCHILD_NON_INTEN_IRREGULAR`i' < 0 & hhid0`i' < . 
	drop mean`i'
	replace TOCHILD_NON_INTEN_IRREGULAR`i' = 0 if hhid0`i' < . & TOCHILD_NON_INTEN_IRREGULAR`i' == . 
	}
	
// REGULAR: monthly amount x months actually transferred 
forval i=1/9{
gen TOCHILD_NON_INTEN_REGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	egen mean`i' = mean(w0`i'Ba046_0`j'w5) if w0`i'Ba046_0`j'w5 > 0 & w0`i'Ba046_0`j'w5 < .
	replace w0`i'Ba046_0`j'w5 = mean`i' if w0`i'Ba046_0`j'w5 < 0 & hhid0`i' < . 
	drop mean`i'
	egen mean`i' = median(w0`i'Ba038_0`j') if w0`i'Ba038_0`j' > 0 & w0`i'Ba038_0`j' < .
	replace w0`i'Ba038_0`j' = mean`i' if w0`i'Ba038_0`j' < 0 & hhid0`i' < . 
	drop mean`i'
	replace TOCHILD_NON_INTEN_REGULAR`i' = w0`i'Ba038_0`j'*w0`i'Ba046_0`j'w5 if w0`i'Ba038_0`j' > 0 & w0`i'Ba038_0`j' < . & w0`i'Ba046_0`j'w5 > 0 & w0`i'Ba046_0`j'w5 <. &  TOCHILD_NON_INTEN_REGULAR`i' == 0 & hhid0`i' < .
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
	gen TOCHILD_CO_INTEN_SUM`i' = . if hhid0`i' < . 
	forval j=1/9{
	replace TOCHILD_CO_INTEN_SUM`i' = w0`i'Ba061_0`j' if w0`i'Ba061_0`j' < . &  TOCHILD_CO_INTEN_SUM`i' == . & hhid0`i' < . 
	egen mean`i' = mean(w0`i'Ba061_0`j') if w0`i'Ba061_0`j'>0 & w0`i'Ba061_0`j'<.
	replace TOCHILD_CO_INTEN_SUM`i' = mean`i' if TOCHILD_CO_INTEN_SUM`i' < 0 & TOCHILD_CO_EXTEN_SUM`i' == 1 & hhid0`i' < . 
	drop mean`i'
	}
}

// Wave 1 amount for coresident children not given; non-identifiable 

**************************************
/// INTENSIVE MARAGIN TO ANY CHILD ///
**************************************
// SUM = CORES + NON-CORES
forval i=1/9{
egen TOCHILD_INTEN_SUM`i' =  rowtotal(TOCHILD_NON_INTEN_SUM`i' TOCHILD_CO_INTEN_SUM`i') if hhid0`i'<.  
}

drop w*fromchildren w*Ba021m02_* w*Ba021m01_* w*Ba021m03_* w*Ba053_* w*tochildren w*Ba037m02_* w*Ba037m01_* w*Ba037m03_* w*Ba060_* w*Ba029_* w*Ba029_*ct w*Ba028_*w5 w*Ba022_* w*Ba022_*ct  w0*Ba054_* w*Ba045_*  w*Ba045_*ct w*Ba046_*w5 w*Ba038_* w*Ba061_* w*Ba035m*_* w*Ba051m*_*


*save Sample, replace
