*******************************************
* 4.Sample_Construction_KLoSA.do		  *
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

**************************
///  SAMPLE SELECTION  ///
**************************
// 1. BORN IN 1956 OR BEFORE
* It is possible to obtain transfer information from children, but then there is no information on their parents' BP; not identifiable. 
* So only use those who are identifiable

* Note: KLoSA describes new samples in 2014 (wave 5) are born in 1962 or 1963 but it is "NOT TRUE" if you actually check. 
* Though small, 60 individuals (less than 1% of the sample) were born before 1962; I will use them as long as they satisfy the sample selection criteria
//////////////////////////55년생 eligible in 2020
keep if w01A002y <= 1955 | w01A002y ==. // original sample 

keep if w05A002y <= 1955 | w05A002y == . // new sample

// 2. PARTICIPATION AT LEAST TWO CONSECUTIVE SURVEYS
forval i=1/9{
	gen participation`i' = 1 if hhid0`i' < .
}

* A variable to count consecutive participations
gen consecutive_participation = .

* To check consecutive participations
qui forval i = 1(1)8 {
	local x = `i' + 1
  replace consecutive_participation = 1 if participation`i' == 1 & participation`x' == 1 
}

drop if consecutive_participation == .

replace hhid05 = hhid05 / 10000 if hhid05 > 10000000 // to match the coding for the new sample

// 3. LONG-TERM CARE NEEDS (FOR REMOVING TIME TRANSFER CHANNEL)
* Standard criteria elsewhere: 1) 3+ ADLs or 2) cognitive impairment
forval i=1/9{
	drop if w0`i'adl >= 3 & w0`i'adl < .
	drop if w0`i'Cadd_01 == 1
}
 
// 4. AT LEAST ONE CHILD AT EACH SURVEY
forval i=1/9{
	drop if w0`i'Ba003 < 1
}
 
// 5. DROP DIVORCE 
forval i=1/9{
	drop if w0`i'marital == 3
}
 
// 6. DROP TOP 0.5% FROM CHILDREN TRANFSFERS (outliers)
forval i=1/9{
	_pctile FROMCHILD_INTEN_SUM`i', p(99.5)
		return list
			gen pct`i' = r(r1)
replace FROMCHILD_INTEN_SUM`i' = 0 if FROMCHILD_INTEN_SUM`i' == . & hhid0`i' < .
		drop if FROMCHILD_INTEN_SUM`i' > pct`i' & hhid0`i' <. 
	}
	drop pct*

// DROP TOP TO CHILDREN TRANSFERS (POTENTIAL BEQUEST) > 6750 ($50000)
forval i=1/9{
	replace TOCHILD_INTEN_SUM`i' = 0 if TOCHILD_INTEN_SUM`i' == . & hhid0`i' < .
		drop if TOCHILD_INTEN_SUM`i' > 6750 & hhid0`i' <. 
}


********************************
///  HOUSEHOLD CONSTRUCTION  ///
********************************
// Generate types of houshold 
// Note: KLoSA missing wave 6 fam data so generated
// Note: KLoSA wave 1-5 & 7-9 have different coding; be careful 

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
	
	
	
// 1. SINGLE LIVING ALONE
forval i=1/9{
	replace household_type`i' = 1 if hhid0`i' < . & w0`i'hhsize == 1 
}

// 2. SINGLE LIVE WITH CHILDREN (+ OTHERS): ONLY RESPONDENT PARTICIPATED THE SURVEY
forval i=1/9{
	replace household_type`i' = 2 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n == 1 & coupleflag`i' == 0 & lwchildren`i' >= 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & !(w0`i'marital==1)
}

// 3. SINGLE LIVE WITH NON-CHILDREN: ONLY RESPONDENT PARTICIPATED THE SURVEY
forval i=1/9{
	replace household_type`i' = 3 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n == 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' >=0 & !(w0`i'marital==1)
}

// 4. SINGLE LIVE WITH PARENTS: ONLY RESPONDENT PARTICIPATED THE SURVEY
forval i=1/9{
	replace household_type`i' = 4 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n == 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
}

// 5. SINGLE LIVE WITH PARENTS & CHILDREN: ONLY RESPONDENT PARTICIPATED THE SURVEY
forval i=1/9{
	replace household_type`i' = 5 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n == 1 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' ==1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
}

// 2. SINGLE LIVE WITH CHILDREN (+ OTHERS): TWO OR MORE RESPONDENTS PARTICIPATED THE SURVEY (SAME AS 2 BUT AT THE HH LEVEL)
forval i=1/9{
	replace household_type`i' = 2 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 &  hhflag`i' >= 0 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i'== 0 & lwsiblings`i' >= 0 & !(w0`i'marital==1)
}

// 3. SINGLE LIVE WITH NON-CHILDREN: TWO OR MORE RESPONDENTS PARTICIPATED THE SURVEY (SAME AS 2 BUT AT THE HH LEVEL)
forval i=1/9{
	replace household_type`i' = 3 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i' >= 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >=0 & !(w0`i'marital==1)
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. & hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >=0 & !(w0`i'marital==1)
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 0  & lwsiblings`i' >=0 & !(w0`i'marital==1)
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' >=0 & !(w0`i'marital==1)
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 4. SINGLE LIVE WITH PARENTS: TWO OR MORE RESPONDENTS PARTICIPATED THE SURVEY (SAME AS 2 BUT AT THE HH LEVEL)
forval i=1/9{
	replace household_type`i' = 4 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i' >= 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. & hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 5. SINGLE LIVE WITH CHILDREN + PARENTS: TWO OR MORE RESPONDENTS PARTICIPATED THE SURVEY (SAME AS 2 BUT AT THE HH LEVEL)
forval i=1/9{
	replace household_type`i' = 5 if hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i' >= 0 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. & hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >=0 & !(w0`i'marital==1)
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 6. COUPLE HH: ONE SPOUSE PARTICIPATED
forval i=1/9{
	replace household_type`i' = 6 if hhid0`i' < . & w0`i'hhsize == 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1
	replace BP_CONTINUOUS_AMOUNT`i' = BP_CONTINUOUS_AMOUNT`i'*1.8 if hhid0`i' < . & w0`i'hhsize == 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1 & BP_SPOUSE`i' == 1
}

// 7. COUPLE HH + CHILDREN (+OTHERS): ONE SPOUSE PARTICIPATED
forval i=1/9{
	replace household_type`i' = 7 if hhid0`i' < . & w0`i'hhsize >= 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1
	replace BP_CONTINUOUS_AMOUNT`i' = BP_CONTINUOUS_AMOUNT`i'*1.8 if hhid0`i' < . & w0`i'hhsize >= 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1 & BP_SPOUSE`i' == 1
}

// 8. COUPLE HH + OTHERS: ONE SPOUSE PARTICIPATED
forval i=1/9{
	replace household_type`i' = 8 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' >=0 & w0`i'marital==1
	replace BP_CONTINUOUS_AMOUNT`i' = BP_CONTINUOUS_AMOUNT`i'*1.8 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' >=0 & w0`i'marital==1 & BP_SPOUSE`i' == 1
}

// 9. COUPLE HH + PARENTS: ONE SPOUSE PARTICIPATED
forval i=1/9{
	replace household_type`i' = 9 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==1 & lwsiblings`i' >=0 & w0`i'marital==1
	replace BP_CONTINUOUS_AMOUNT`i' = BP_CONTINUOUS_AMOUNT`i'*1.8 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 0 & lwparents`i' ==1 & lwsiblings`i' >=0 & w0`i'marital==1 & BP_SPOUSE`i' == 1
}

// 10. COUPLE HH + CHILDREN + PARENTS: ONE SPOUSE PARTICIPATED
forval i=1/9{
	replace household_type`i' = 10 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' ==1 & lwsiblings`i' >=0 & w0`i'marital==1
	replace BP_CONTINUOUS_AMOUNT`i' = BP_CONTINUOUS_AMOUNT`i'*1.8 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n == 1 & hhflag`i' == 0 & coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' ==1 & lwsiblings`i' >=0 & w0`i'marital==1 & BP_SPOUSE`i' == 1
}

// 6. COUPLE HH: BOTH PARTICIPATED
forval i=1/9{
	replace household_type`i' = 6 if hhid0`i' < . & w0`i'hhsize ==2 & w0`i'panel_n == 2 & hhflag`i' == 1 & coupleflag`i' == 1 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' ==0 & w0`i'marital==1
	bysort cid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & w0`i'hhsize ==2 & w0`i'panel_n == 2 & hhflag`i' == 1 & coupleflag`i' == 1 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' ==0 & w0`i'marital==1
bysort cid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize ==2 & w0`i'panel_n == 2 & hhflag`i' == 1 & coupleflag`i' == 1 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' ==0 & w0`i'marital==1
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 & hhid0`i' < . & w0`i'hhsize ==2 & w0`i'panel_n == 2 & hhflag`i' == 1 & coupleflag`i' == 1 & lwchildren`i' == 0 & lwparents`i' ==0 & lwsiblings`i' ==0 & w0`i'marital==1
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 7. COUPLE HH + CHILDREN (+OTHERS): BOTH PARTICIPATED
forval i=1/9{
	replace household_type`i' = 7 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' >= 0 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i'== 1 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 & hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 8. COUPLE HH + OTHERS: MIXED PARTICIPATED
forval i=1/9{
	replace household_type`i' = 8 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' >= 0 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1 & !(household_type`i' == 6)
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1 & !(household_type`i' == 6)
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 & hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1 & !(household_type`i' == 6)
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 & hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' >= 0 & w0`i'marital==1 & !(household_type`i' == 6)
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 9. COUPLE HH + PARENTS: BOTH PARTICIPATED
forval i=1/9{
	replace household_type`i' = 9 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' >=0 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >= 0 
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >= 0 
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >= 0 
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 & hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 0 & lwparents`i' == 1 & lwsiblings`i' >= 0 
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

// 10. COUPLE HH + CHILDREN + PARENTS: BOTH PARTICIPATED
forval i=1/9{
	replace household_type`i' = 10 if hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' >=0 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >= 0 
	bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >= 0 
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >= 0 
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 & hhid0`i' < . & w0`i'hhsize > 2 & w0`i'panel_n > 1 & hhflag`i' == 1 & coupleflag`i' >= 0 & lwchildren`i' == 1 & lwparents`i' == 1 & lwsiblings`i' >= 0 
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 
}

*REMAINING: SHORT TERM LIVING WITH CHILDREN RECORDED AS LIVING WITH CHILDREN. THEY ARE ACTUALLY COUPLE HH
forval i=1/9{
	replace household_type`i' = 6 if hhid0`i' < . & w0`i'hhsize == 2 & w0`i'marital == 1 & household_type`i' == -1
}

* SINGLE LIVING WITH OTHERS NOT CAPTURED FOR e.g. RELATIVES
forval i=1/9{
	replace household_type`i' = 8 if hhid0`i' < . & w0`i'hhsize >= 2 & !(w0`i'marital == 1) & lwchildren`i' == 0 & lwparents`i' == 0 & lwsiblings`i' == 0 & household_type`i' == -1
}

// HOUSEHOLD TYPE: 1. SINGLE (+ NON-CHILD); 2. SINGLE LIVING WITH CHILD; 3. COUPLE (+ NON-CHILD); 4. COUPLE LIVING WITH CHILD

lab def household_type 1 "1.Single" 2 "2.Single w/ child" 3 "3.Single w/ non-child/parents" 4 "4.Single w/ parents" 5 "5.Single w/ parents & child" 6 "6.Couple" 7 "7.Couple w/ child" 8 "8.Couple w/ non-child/parents" 9 "9.Couple w/ parents" 10 "10.Couple w/ parents & child" 

forval i=1/9{
	lab var household_type`i' "Types of Household"
	lab val household_type`i' household_type
	}


***************************
///  ANALYTICAL SAMPLE  ///
***************************	
forval i=1/9{
	gen household`i' = .
}
	
// CREATING HH LEVEL VARIABLES 
*Use the HH level data from the oldest respondent in the HH 
forval i=1/9{
gsort hhid0`i' -w0`i'A002_age 
by hhid0`i': gen oldest_member`i' = ( _n == 1 )
replace household`i' == household_type`i' 
}







bysort hhid0`i': egen BPsum`i' = total(BP_CONTINUOUS_AMOUNT`i') if BP_CONTINUOUS_AMOUNT`i'<. &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 &  coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & !(w0`i'marital==1) & hhflag`i'== 1
bysort hhid0`i': replace BP_CONTINUOUS_AMOUNT`i' = BPsum`i' if BPsum`i' < . & BPsum`i' > 0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 &  coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & !(w0`i'marital==1) & hhflag`i'== 1
replace BP_CONTINUOUS_EXTEN`i' = 1 if BP_CONTINUOUS_EXTEN`i' == 0 & BPsum`i' < . & BPsum`i'>0 &  hhid0`i' < . & w0`i'hhsize > 1 & w0`i'panel_n > 1 &  coupleflag`i' == 0 & lwchildren`i' == 1 & lwparents`i' == 0 & lwsiblings`i' >= 0 & !(w0`i'marital==1) & hhflag`i'== 1
drop BPsum`i'
replace BP_CONTINUOUS_EXTEN`i' =1 if BP_CONTINUOUS_AMOUNT`i' > 0 & BP_CONTINUOUS_AMOUNT`i' < . & BP_CONTINUOUS_EXTEN`i' == 0 & hhid0`i' < . 
replace BP_FIRST_ABSORB`i' = 1 if BP_FIRST_ABSORB`i' == 0 & BP_CONTINUOUS_EXTEN`i' == 1 & hhid0`i'<. 









	
	
save "SampleHH.dta", replace	
	
	