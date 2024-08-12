*******************************************
* 3.Data_Cleaning_KLoSA.do				  *
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

*========== Time transfer from child ==========*
gen Time_from_child = 0
gen w01C218_04 =0
gen w01C218_05 =0
forval i=1/9{
	forval j=1/5{
	replace Time_from_child = 1 if w0`i'C218_0`j' >2 & w0`i'C218_0`j'<50 & time==`i'
}
}

*========== Time transfer from spouse ==========*
gen Time_from_spouse = 0
forval i=1/9{
	forval j=1/5{
	replace Time_from_spouse = 1 if w0`i'C218_0`j' ==2 & time==`i'
}
}

*============ Hospitalization ===============*
gen hospitalization =0 
forval i=1/9{
	replace hospitalization= 1 if w0`i'C318>=1&w0`i'C318<.
}
gen Hospitalization_care = 0
	forval j=6/9{
	replace Hospitalization_care = 1 if w01Cc21m0`j' ==1 & time==1
}

forval j=10/15{
	replace Hospitalization_care = 1 if w01Cc21m`j' ==1 & time==1
}
forval j=31/32{
	replace Hospitalization_care = 1 if w01Cc21m`j' ==1 & time==1
}

	forval j=1/7{
	replace Hospitalization_care = 1 if w02C323_01a`j'>6 & w02C323_01a`j'<50 & time==2
}

forval i=2/3{
	forval j=1/4{
	replace Hospitalization_care = 1 if w02C323_0`i'a`j'>6 & w02C323_0`i'a`j'<50 & time==2
}
}

forval i=4/6{
	forval j=1/2{
	replace Hospitalization_care = 1 if w02C323_0`i'a`j'>6 & w02C323_0`i'a`j'<50 & time==2
}
}

	forval i=7/9{
	replace Hospitalization_care = 1 if w02C323_0`i'a1>6 & w02C323_0`i'a1<50 & time==2
}    

	forval i=10/12{
	replace Hospitalization_care = 1 if w02C323_`i'a1>6 & w02C323_`i'a1<50 & time==2
}    

	forval i=1/8{
		forval j=1/2{
	replace Hospitalization_care = 1 if w03C323_0`j'a`i'>6 & w03C323_0`j'a`i'<50 & time==3
}    
	}
	
		forval i=1/8{
		forval j=1/2{
	replace Hospitalization_care = 1 if w03C323_0`j'a`i'>6 & w03C323_0`j'a`i'<50 & time==3
}    
	}
	
	forval i=1/4{
			replace Hospitalization_care = 1 if w03C323_03a`i'>6 & w03C323_03a`i'<50 & time==3

	}
	
	
*========== Time transfer to child ==========*
gen Grandchild_care_to_child = 0 
forval i=1/9{
		replace Grandchild_care_to_child = 1 if w0`i'Ba075 ==1 & time==`i'
	}

*========== Time transfer for ADL member ==========*
gen ADL_to_transfer = 0
forval i=1/9{
	replace ADL_to_transfer = 1 if w0`i'bb_adl2==1 & time==`i'
}

*========== Time transfer for IADL member ==========*
gen IADL_to_transfer = 0
forval i=1/9{
	replace IADL_to_transfer = 1 if w0`i'bb_adl3==1 & time==`i'
}

*=====================================================*
* Job search 
gen jobsearch = 0 
forval i=1/9{
	replace jobsearch = 1 if w0`i'job_search==1 & time==`i'
}

*======================================================*
*=== Independent ===* 
*Age 
gen age=. 
forval i=1/9{
	by pid: replace age = w0`i'A002_age if time==`i'
}

// Imputation
by pid: replace age = age[_n-1]+2 if age==. & _n!=1

*Spouse age
replace w01A020 = . if w01A020 <0
gen spouse_age = 2006 - w01A020 if time ==1
by pid: replace spouse_age = spouse_age[_n-1]+2 if spouse_age==. & _n!=1


*Wealth 
gen wealth=.
forval i=1/9{
replace wealth = w0`i'hhnetassets if w0`i'hhnetassets<. & time==`i'	
egen mean_wealth`i' = mean(w0`i'hhnetasset)
replace wealth = mean_wealth`i' if w0`i'hhnetasset ==-9|w0`i'hhnetasset ==-8
}
replace w02hhnetassets = mean_wealth2 if w02hhnetassets==-9| w02hhnetassets==-8
replace wealth = w02hhnetassets if time==1 & wealth==.
by pid: replace wealth = wealth[_n+1] if wealth == . & wealth[_n+1]<. 
drop mean_wealth*

gen log_wealth = log(wealth+80001)

*Income
gen income = . 
forval i=1/9{
replace income = w0`i'hhinc if w0`i'hhinc <. & time== `i'
egen mean_inc`i' = mean(w0`i'hhinc) 
by pid: replace income = mean_inc`i' if income==-9|income==-8|income==. & time==`i'
drop mean_inc`i'
}

replace income = log(income+1)

*edu 
gen edu=.
forval i=1/9{
replace w0`i'edu = 1 if w0`i'edu == -9|w0`i'edu == -8|w0`i'edu == 97
by pid: replace edu = w0`i'edu 	if time== `i'
}

*Spouse edu
forval i=1/9{
	replace w0`i'A022 = 1 if w0`i'A022 <3 | w0`i'A022==97
	replace w0`i'A022 = 2 if w0`i'A022 ==4
	replace w0`i'A022 = 3 if w0`i'A022 ==5
	by pid: replace w0`i'A022 = 4 if w0`i'A022 >=6 & w0`i'A022<.
}

gen spouse_edu = w01A022 if time==1
forval i=2/9{
		replace spouse_edu = w0`i'A022 if spouse_edu==. & !w0`i'A022==. 
}
by pid: replace spouse_edu = spouse_edu[_n-1] if spouse_edu==. & _n!=1



*Region 
gen region =.
forval i=1/9{
	by pid: replace region = w0`i'region1 if  time== `i'
}

*Gender 
gen gender = w01gender //1. male 0. female
replace gender =0 if gender==5

*Marital Status 
// 1. married & lived tgt, 0. otherwise
gen marital = . 
forval i=1/9{
	replace w0`i'marital = 0 if w0`i'marital>=2 & w0`i'marital<=5 
	replace marital = w0`i'marital if time==`i'
}

*grand child
gen grandchild = 0 
forval i=1/9{
	replace grandchild = 1 if  w0`i'Ba068>=1 & w0`i'Ba068<=. & time==`i'
}


*ADL 
rename w01Adl w01adl
gen num_ADL = 0 
forval i=1/9{
	replace num_ADL = w0`i'adl if w0`i'adl>0 & w0`i'adl<10 & time==`i'
}

*IADL 
gen num_IADL = 0 
forval i=1/9{
	replace num_IADL = w0`i'iadl if w0`i'iadl>0 & w0`i'iadl<10 & time==`i'
}

*Health conditions 

*Coresidence

*SES charactistics 

*Income + SS Benefits  

*Wealth 


************************************************
*** Sample selection ***
************************************************
// 1. Age >=50 (age 65 in 2022)
bysort pid: drop if w01A002y>1957

// 2. At least one BP benefit received (Not-yet treated group)
 

// 3.
*Number of children 
gen children =. 
forval i=1/9{
	replace children = w0`i'Ba003 if year ==`i'
}

replace children = 0 if children == -8| children ==-9|children ==.


* 2. At least one child 
// See data generating file
gen mm = 1 if children==0
by pid: carryforward mm, replace
gsort pid -year 
by pid: carryforward mm, replace
bys pid: drop if mm==1
drop mm





*** Use mark for unbalanced panel 









*Extensive Margin (Transferred to/from at least one child during the survey wave)

forval i=1/9{
	replace child`i'_regtransferamount = . if child`i'_regtransferamount==-9|child`i'_regtransferamount==-8
	replace child`i'_irregtransferamount = . if child`i'_irregtransferamount==-9|child`i'_irregtransferamount==-8
	replace tochild`i'_regtransferamount = . if tochild`i'_regtransferamount==-9|tochild`i'_regtransferamount==-8
	replace tochild`i'_irregtransferamount = . if tochild`i'_irregtransferamount==-9|tochild`i'_irregtransferamount==-8
	replace transfer`i'_coreschild = . if transfer`i'_coreschild==-9|transfer`i'_coreschild==-8
	replace totransfer`i'_coreschild = . if totransfer`i'_coreschild==-9|totransfer`i'_coreschild==-8
}

gen to_child = 0
forval i=1/9{
replace to_child = 1 if tochild`i'_regtransferamount<.|tochild`i'_irregtransferamount<.|totransfer`i'_coreschild<.
}

gen to_child_reg = 0
forval i=1/9{
replace to_child_reg = 1 if tochild`i'_regtransferamount<.
}

gen to_child_irg = 0
forval i=1/9{
replace to_child_irg = 1 if tochild`i'_irregtransferamount<.
}

gen to_child_cor = 0
forval i=1/9{
replace to_child_cor = 1 if totransfer`i'_coreschild<.
}

gen from_child = 0
forval i=1/9{
replace from_child = 1 if child`i'_regtransferamount<.|child`i'_irregtransferamount<.|transfer`i'_coreschild<.
}

gen from_child_reg = 0
forval i=1/9{
replace from_child_reg = 1 if child`i'_regtransferamount<.
}

gen from_child_irg = 0
forval i=1/9{
replace from_child_irg = 1 if child`i'_irregtransferamount<.
}

gen from_child_cor = 0
forval i=1/9{
replace from_child_cor = 1 if transfer`i'_coreschild<.
}



































**********************************************************************
/// INTENSIVE MARGIN FROM ANY CHILD (CORESIDENT + NON-CORESIDENT) ///
**********************************************************************
forval i=1/9{
	gen FROMCHILD_INTEN_TOTAL`i' = 0 if hhid0`i' < . 
	replace FROMCHILD_INTEN_TOTAL`i' = w0`i'fromchildren if hhid0`i' < . & w0`i'fromchildren < . 
	*egen median`i' = median(FROMCHILD_INTEN_TOTAL`i')
	*replace FROMCHILD_INTEN_TOTAL`i' = . /*median`i'*/ if FROMCHILD_INTEN_TOTAL`i' < 0 & hhid0`i' < . 
	*drop median`i'
// a few respondents didn't want to tell the amount though received. Median imputed for these few responses (less than 0.5% of the sample). 	
}

********************************************************
/// INTENSIVE MARGIN FROM ANY CHILD (NON-CORESIDENT) ///
********************************************************
// IRREGULAR 
forval i=1/9{
	gen FROMCHILD_NON_INTEN_IRREGULAR`i' = 0  if hhid0`i' < .
	forval j=1/9{
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = w0`i'Ba029_0`j' if w0`i'Ba029_0`j' < . &  FROMCHILD_NON_INTEN_IRREGULAR`i' == 0 & hhid0`i' < . 
}
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 50 if w01Ba029_0`i'ct == 1 & hhid01 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==0
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 100 if w01Ba029_0`i'ct == 2 & hhid01 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==0
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 200 if w01Ba029_0`i'ct == 3 & hhid01 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==0

forval k = 1/6{
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 50 if w02Ba029_0`k'ct == 1 & hhid02 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==0
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 100 if w02Ba029_0`k'ct == 2 & hhid02 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==0
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 200 if w02Ba029_0`k'ct == 3 & hhid02 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==0

}
	}
		*egen median`i' = median(FROMCHILD_NON_INTEN_IRREGULAR`i')
	*replace FROMCHILD_NON_INTEN_IRREGULAR`i' = . /*median`i'*/ if FROMCHILD_NON_INTEN_IRREGULAR`i' < 0 & hhid0`i' < . 
	*drop median`i'
	

// REGULAR: monthly amount x months actually transferred 
forval i=1/9{
gen FROMCHILD_NON_INTEN_REGULAR`i' = 0  if hhid0`i' < .
	replace FROMCHILD_NON_INTEN_REGULAR`i' = 5 if w01Ba022_0`i'ct == 1 & hhid01 < .
	replace FROMCHILD_NON_INTEN_REGULAR`i' = 100 if w01Ba022_0`i'ct == 8 & hhid01 < .
	replace FROMCHILD_NON_INTEN_REGULAR`i' = 200 if w01Ba022_0`i'ct == 10 & hhid01 < . 
	forval j=1/9{
	*egen median`i' = median(w0`i'Ba028_0`j'w5)
	*replace w0`i'Ba028_0`j'w5 = . /*median`i'*/ if w0`i'Ba028_0`j'w5 < 0 & hhid0`i' < . 
	*drop median`i'
	*egen median`i' = median(w0`i'Ba022_0`j')
	*replace w0`i'Ba022_0`j' = . /*median`i'*/ if w0`i'Ba022_0`j' < 0 & hhid0`i' < . 
	*drop median`i'
	replace FROMCHILD_NON_INTEN_REGULAR`i' = w0`i'Ba022_0`j'*w0`i'Ba028_0`j'w5 if w0`i'Ba022_0`j' > 0 & w0`i'Ba022_0`j' < . & w0`i'Ba028_0`j'w5 > 0 & w0`i'Ba028_0`j'w5 <. &  FROMCHILD_NON_INTEN_REGULAR`i' == 0 & hhid0`i' < .
}
}

// SUM = REGULAR + IRREGULAR
forval i=1/9{
egen FROMCHILD_NON_INTEN_SUM`i' = rowtotal(FROMCHILD_NON_INTEN_REGULAR`i'  FROMCHILD_NON_INTEN_IRREGULAR`i') if hhid0`i'<. 
}
/*
forval i=1/9{
gen FROMCHILD_NON_INTEN_SUM`i' = FROMCHILD_NON_INTEN_REGULAR`i' +  FROMCHILD_NON_INTEN_IRREGULAR`i' if hhid0`i'<. 
}	
*/
*****************************************************
/// INTENSIVE MARAGIN FROM ANY CHILD (CORESIDENT) ///
*****************************************************
forval i=1/9{
	gen FROMCHILD_CO_INTEN_SUM`i' = 0 if hhid0`i' < . 
	forval j=1/9{
	replace FROMCHILD_CO_INTEN_SUM`i' = w0`i'Ba054_0`j' if w0`i'Ba054_0`j' < . &  FROMCHILD_CO_INTEN_SUM`i' == 0 & hhid0`i' < . 
}


replace FROMCHILD_CO_INTEN_SUM1 = w01fromchildren - FROMCHILD_NON_INTEN_SUM1 if w01fromchildren < . & w01fromchildren > FROMCHILD_NON_INTEN_SUM1 & indicator1 == 0

/*	replace FROMCHILD_CO_INTEN_SUM`i' = 50 if w01Ba054_0`i'ct == 1 & hhid01 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==.
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 100 if w01Ba029_0`i'ct == 2 & hhid01 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==.
	replace FROMCHILD_NON_INTEN_IRREGULAR`i' = 200 if w01Ba029_0`i'ct == 3 & hhid01 < . & FROMCHILD_NON_INTEN_IRREGULAR`i'==.
*/

}

****************************************
/// INTENSIVE MARAGIN FROM ANY CHILD ///
****************************************
// SUM = CORES + NON-CORES
forval i=1/9{
egen FROMCHILD_INTEN_SUM`i' =  rowtotal(FROMCHILD_NON_INTEN_SUM`i' FROMCHILD_CO_INTEN_SUM`i') if hhid0`i'<.  
}
	




*Transferred to/from old's parents
replace parents_regtransferamount = . if parents_regtransferamount==-8|parents_regtransferamount==-9
replace parents_irregtransferamount=. if parents_irregtransferamount==-8|parents_irregtransferamount==-9 
replace toparents_regtransferamount = . if toparents_regtransferamount==-8|toparents_regtransferamount==-9 
replace toparents_irregtransferamount=. if toparents_irregtransferamount==-8|toparents_irregtransferamount==-9 
replace tofather_regtransferamount = . if tofather_regtransferamount==-8|tofather_regtransferamount==-9 
replace tofather_irregtransferamount = . if tofather_irregtransferamount==-8|tofather_irregtransferamount==-9
replace father_regtransferamount=. if father_regtransferamount==-8|father_regtransferamount==-9

replace father_irregtransferamount =. if father_irregtransferamount ==-8 | father_irregtransferamount ==-9
replace mother_regtransferamount =. if mother_regtransferamount==-8|mother_regtransferamount==-9 
replace mother_irregtransferamount=. if mother_irregtransferamount==-8|mother_irregtransferamount==-9
replace tomother_regtransferamount =. if tomother_regtransferamount ==-8 | tomother_regtransferamount ==-9
replace tomother_irregtransferamount=. if tomother_irregtransferamount ==-8 | tomother_irregtransferamount==-9

gen to_parents = 0
replace to_parents =1 if toparents_irregtransferamount<.| toparents_regtransferamount<. | tofather_irregtransferamount<. | tofather_regtransferamount<. |tomother_irregtransferamount<. |tomother_regtransferamount<.

gen to_parents_reg = 0
replace to_parents_reg =1 if toparents_regtransferamount<. | tofather_regtransferamount<. |tomother_regtransferamount<.

gen to_parents_irg = 0
replace to_parents_irg =1 if toparents_irregtransferamount<.| tofather_irregtransferamount<.| tomother_irregtransferamount<. 

gen from_parents = 0 
replace from_parents = 1 if parents_irregtransferamount<. | parents_regtransferamount<. | father_irregtransferamount<. | father_regtransferamount<. | mother_irregtransferamount<. | mother_regtransferamount<.

gen from_parents_reg = 0 
replace from_parents_reg = 1 if parents_regtransferamount<. | father_regtransferamount<. | mother_regtransferamount<.

gen from_parents_irg = 0 
replace from_parents_irg = 1 if parents_irregtransferamount<. | father_irregtransferamount<. | mother_irregtransferamount<. 

*Transferred to/from other family members

gen to_others = 0 
replace to_others = 1 if (tospouse_dad_irtransfers<.&tospouse_dad_irtransfers>0) | (tospouse_dad_regtransfers <.&tospouse_dad_regtransfers>0) |(tospouse_mom_irtransfers<.&tospouse_mom_irtransfers>0) | (tospouse_mom_regtransfers <.&tospouse_mom_regtransfers>0) |(torelatives_iregtransfers<.&torelatives_iregtransfers>0) | (torelatives_regtransfers <.&torelatives_regtransfers>0) |(tochild_spouse_iregtransfers<.&tochild_spouse_iregtransfers>0) | (tochild_spouse_regtransfers  <.& tochild_spouse_regtransfers>0) |(tospouse_sib_iregtransfers<.&tospouse_sib_iregtransfers>0) | (tospouse_sib_regtransfers <.& tospouse_sib_regtransfers>0) | (tograndchild_iregtransferamount<.& tograndchild_iregtransferamount>0) | (tograndchild_regtransferamount <.&tograndchild_regtransferamount>0) |(tosibling_iregtransfer <.&tosibling_iregtransfer >0) | (tosibling_regtransfer <.&tosibling_regtransfer>0)

gen from_others=0
replace from_others = 1 if (spouse_father_irtransferamount<.&spouse_father_irtransferamount>0)|(spouse_father_regtransferamount<.&spouse_father_regtransferamount>0)|(spouse_mother_irtransferamount<.&spouse_mother_irtransferamount>0)|(spouse_mother_regtransferamount<.&spouse_mother_regtransferamount>0)|(relatives_iregtransfers<.&relatives_iregtransfers>0)|(relatives_regtransfers<.&relatives_regtransfers>0)|(child_spouse_iregtransfers<.&child_spouse_iregtransfers>0)|( child_spouse_regtransfers<.& child_spouse_regtransfers>0)|(spouse_sib_iregtransfers<.&spouse_sib_iregtransfers>0)| (spouse_sib_regtransfers<.&spouse_sib_regtransfers>0)| (grandchild_iregtransferamount<.&grandchild_iregtransferamount>0)|( grandchild_regtransferamount<. & grandchild_regtransferamount>0)| (sibling_iregtransfer<.&sibling_iregtransfer>0)|(sibling_regtransfer<.&sibling_regtransfer>0)

gen to_parentsandother = 0 
replace to_parentsandother = 1 if to_others==1 | to_parents==1

gen from_parentsandother = 0
replace from_parentsandother = 1 if from_others==1 | from_parents==1

gen to_total = 0 
replace to_total = 1 if to_child ==1 | to_parentsandother==1

gen from_total = 0 
replace from_total=1 if from_child==1 | from_parentsandother==1


*Long term care to/from old's parents

현물



* Child rearing .., b////////////////// need to be done in the data creation
gen child_rearing_lastyear = 0
gen child_rearing_life = 0
gen child_rearing_tot = 0
gen w01Ba069 = .
forval i=1/8{
replace child_rearing_lastyear = 1 if w0`i'Ba075 ==1
replace child_rearing_life = 1 if w0`i'Ba069 ==1
}
replace child_rearing_tot=1 if child_rearing_life==1
replace child_rearing_tot=1 if child_rearing_life==0 & child_rearing_lastyear==1


rename w08basic_starty treat 
replace treat = 0 if treat==-9|treat==-8|treat==. 
/*replace treat = 2010 if treat==2009
replace treat = 2012 if treat==2011
replace treat = 2014 if treat==2013
replace treat = 2016 if treat==2015
replace treat = 2018 if treat==2017
replace treat = 2020 if treat==2019*/

* Grand children 
replace num_grandchild = 0 if num_grandchild==-8|num_grandchild==-9
replace num_grandchild = 10 if num_grandchild>10








indicator and children's characteristics 
parallel trends
sample characteristics

1. 변수들 제대로 확인후 만들기 
2. 샘플 샐랙션 제ㅐ로 
3. 평균 그래프 
4. 샘플 인포 
reg x 12 





xtset pid year
egen mean = mean(to_child), by(year)

graph twoway line mean year

 ////////////////////////////////////////////////////////////////////////////////





xtset pid year
//////////////////////////////////////////////////////////////////////////Sample Selection ///////////////////////////////////
///////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Imputation //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
* Gender imputation 
replace gender_spouse = gender_spouse[_n-1] if gender_spouse==. & gender_spouse[_n-1]<.
replace gender_spouse = gender_spouse[_n+1] if gender_spouse==. & gender_spouse[_n+1]<.////////////////////////////////////////////////////////////////////////////////
distinct hhid pid


/*
drop tag
bys pid : gen tag=_n-4==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012
replace tag=2014 if basic_tot==1& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-5==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012|first_treat==2014
replace tag=2016 if basic_tot==1& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-6==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012|first_treat==2014|first_treat==2016
replace tag=2018 if basic_tot==1& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-7==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012|first_treat==2014|first_treat==2016|first_treat==2018
replace tag=2020 if basic_tot==1& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.
drop tag
*/
forval i=1/7{
bys pid: replace first_treat = first_treat[_n+1] if first_treat==.
}
replace first_treat=0 if first_treat==.

ta year first_treat
/////////////////////////////////////////////////////////////////////////////////

forval i=1/8{
bys pid: replace gender = gender[_n+1] if gender==.
}

replace gender =0 if gender==5


*** Dependent variables 
*Total transfers from family members 
replace tot_transfer = 0 if tot_transfer==-9 | tot_transfer==.

*Hours received for care
gen relation_family = 0
gen relation_public = 0 
forval i=1/5{
	replace relation_family=1 if relation`i'_caregiver>=2&relation`i'_caregiver<=50 
	replace relation_public=1 if relation`i'_caregiver>=52&relation`i'_caregiver<=55 
	replace hour`i'_caregiver = 0 if hour`i'_caregiver<0 | hour`i'_caregiver>24
}


gen hour_caregiver = hour1_caregiver+ hour2_caregiver+ hour3_caregiver +hour4_caregiver + hour5_caregiver

// family care
gen familycare = hour_caregiver if relation_family==1 
replace familycare=0 if familycare==-9|familycare==.

// public care 
gen publiccare = hour1_caregiver if relation_public==1
forvalues i=2/4{
	replace publiccare = hour`i'_caregiver if relation_public==1 & hour`i'_caregiver<. & publiccare==.
} 
replace publiccare=0 if publiccare==-9|publiccare==.


gen basic_start = w08basic_starty
replace basic_start = 0 if basic_start==-9|basic_start==-8|basic_start==.
////////////////////////////////////////////////////////////////////////////////
ta year first_treat

*Coresidence
replace w01_fam2 = 3 if w01_fam2>=2 
replace w01_fam2 = 2 if w01_fam2==1
replace w01_fam2 = 1 if w01_fam2==0
rename w01_fam2 coresidence2006

replace w08_fam2 = 3 if w08_fam2>2 
rename w08_fam2 coresidence2020

*Education
replace edu = . if edu==-9 | edu==-8

*cohabit finan support / intentsity and by co habit 
*tot transfer from / children/ parents and others
*relation1_caregiver  /day hour pay amount  / pinc

gen transfer = log(1+tot_transfer)

gen time =year[_n+1]


////////////////////////////////////////////////////////////////////////////////
* Sample Characteristics 

bysort first_treat: su age familycare tot_transfer gender i.coresidence2006 i.edu ADL IADL chronic_total hhassets passets w01G028 w01G029 w01dep1 w01G026


ta year first_treat

bysort first_treat: su w01G001



gen first = first_treat
replace first = 1 if !(first==0)

set scheme s1color
ssc install multidensity

	 
	 
















reg from_child age age_spouse edu edu_spouse hhnetasset num_ADL num_IADL publictransfer basic_pension

*Fixing treatment (G = {2008,2010,...,2020})
/*
drop tag
replace w08basic_starty = 0 if w08basic_starty==.|w08basic_starty==-8|w08basic_starty==-9
gen first_treat=.
bys pid : gen tag=_n-1==1
replace tag=. if tag==0
replace tag=2008 if w08basic_starty==2008& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-2==1
replace tag=. if tag==0|first_treat ==2008
replace tag=2010 if (w08basic_starty==2009|w08basic_starty==2010) &tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-3==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010
replace tag=2012 if (w08basic_starty==2011|w08basic_starty==2012)& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-4==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012
replace tag=2014 if (w08basic_starty==2013|w08basic_starty==2014)& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-5==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012|first_treat ==2014
replace tag=2016 if (w08basic_starty==2015|w08basic_starty==2016)& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-6==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012|first_treat ==2014|first_treat ==2016
replace tag=2018 if (w08basic_starty==2017|w08basic_starty==2018)& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==.

drop tag
bys pid : gen tag=_n-7==1
replace tag=. if tag==0|first_treat ==2008|first_treat==2010|first_treat==2012|first_treat ==2014|first_treat ==2016|first_treat ==2018
replace tag=2020 if (w08basic_starty==2019|w08basic_starty==2020)& tag==1
bys pid: carryforward tag if tag==., replace
replace tag=. if tag==1
replace first_treat = tag if first_treat==. */

*======================================================*



*======================================================*
*======================================================*






// Last year 
* labor income 
forval i=1/8{
	gen  wage`i' = w0`i'wage
}

* Business 
forval i=1/8{
	gen business`i'= w0`i'selfemployed 
}

* Agri 
gen agriculture1 = w01Agriculture 
forval i=2/8{
	gen agriculture`i'= w0`i'agriculture 
}

* other 
forval i=1/8{
	gen other_income`i'= w0`i'sideline 
}

* earned income 
forval i=1/8{
	gen earned_income`i'= w0`i'earned 
}

* financial 
forval i=1/8{
	gen financial`i'= w0`i'financial 
}

* realestate
forval i=1/8{
	gen  realestate`i' = w0`i'realestateinc
}

* asset income 
gen assetinc1 = w01Assetinc 
forval i=2/8{
	gen assetinc`i'= w0`i'assetinc 
}

* Pension income 
forval i=1/8{
	gen pensioninc`i' = w0`i'national 
}

* Particular 
forval i=1/8{
	gen particular`i' = w0`i'particular 
}

* Annuity 
gen annuity1 = w01Annuity
forval i=2/8{
	gen annuity`i' = w0`i'annuity
}

* Unemployment benefit 
forval i=1/8{
	gen unemployment`i' = w0`i'unemployment
}

* industrial 
forval i=1/8{
	gen industrial`i' = w0`i'industrial
}

* Basic living 
forval i=1/8{
	gen basicliving`i' = w0`i'guarantee
}

* veteran
forval i=1/8{
	gen veteran`i' = w0`i'exploit
}

* social welfare
forval i=1/8{
	gen socialwelfare`i' = w0`i'socialwelfare
}

* Other social security
forval i=1/8{
	gen otherssc`i' = w0`i'socialsecurity
}

* Public transfers
forval i=1/8{
	gen publictransfer`i' = w0`i'publictrans
}

* Private pension 
forval i=1/8{
	gen priv_pension`i' = w0`i'personal
}

* Otherpension
forval i=1/8{
	gen other_pension`i' = w0`i'other
}

*Total total income 
  forval i=1/8{
  	gen totlaincome`i' = w0`i'pinc
  }

// Assets
* homevalue 
forval i=1/8{
	gen homevalue`i' = w0`i'residence 
} 

* regular insurance 
forval i=1/8{
	gen regularins`i' = w0`i'regularins
}

* lifeinsurance
forval i=1/8{
	gen lifeins`i' = w0`i'regularins
}

* pension asset
forval i=1/8{
	gen pensionasset`i' = w0`i'pensionins
}

* Insurance asset 
forval i=1/8{
	gen insuranceasset`i' = w0`i'insurance
}

* financial asset
forval i=1/8{
	gen finasset`i' = w0`i'financialasset
}

*business asset 
forval i=1/8{
	gen businessasset`i' = w0`i'businessfarm
}

*real estate asset 
forval i=1/8{
	gen realestateasset`i' = w0`i'realestate
}

* other assets 
forval i=1/8{
	gen otherasset`i' = w0`i'otherasset
}

* total assets 
forval i=1/8{
	gen totalasset`i' = w0`i'passets
}

* total debt 
forval i=1/8{
	gen totaldebt`i' = w0`i'pliabilities
}

* net assets 
forval i=1/8{
	gen netassets`i' = w0`i'pnetassets
}

* hh total income 
forval i=1/8{
	gen hhtotalinc`i' = w0`i'hhinc
}

* hh total assets 
forval i=1/8{
	gen hhtotalasset`i' = w0`i'hhassets
}

* hh total debt 
forval i=1/8{
	gen hhtotaldebt`i' = w0`i'hhliabilities
}

* hh net assets 
forval i=1/8{
	gen hhnetasset`i' = w0`i'hhnetassets
	}



  
save Add_variable.dta, replace
*/











// Chronic disease 
*sum of chronic for wave 7 & 8 missing + chronic disease sum was incorrect (mere sum with categorical values) 
display `"`c(alpha)'"'

forval j = 1/8 {
	foreach k in `c(alpha)' {
		if "`k'"<="j" {
		replace w0`j'chronic_`k' = 0 if !(w0`j'chronic_`k'==1)
        }
        }
}

display `"`c(alpha)'"'

forval i = 1/8 {
		gen w0`i'chronic_total = w0`i'chronic_a +w0`i'chronic_b+w0`i'chronic_c+w0`i'chronic_d+w0`i'chronic_e+w0`i'chronic_f+w0`i'chronic_g+w0`i'chronic_h+w0`i'chronic_i+w0`i'chronic_j
}

forval i=1(1)8{
	rename w0`i'chronic_total chronic_total`i'
	gen chronic_a`i' = w0`i'chronic_a
	gen chronic_b`i' = w0`i'chronic_b 
	gen chronic_c`i' = w0`i'chronic_c
	}

display `"`c(alpha)'"'
forval j = 1/8 {
foreach k in `c(alpha)' {
			if "`k'"<="j" {
	drop w0`j'chronic_`k'
}
}
}

forval j = 5/8 {
	drop w0`j'chronic_k w0`j'chronic_l 
}

forval j = 1/6 {
	drop w0`j'chronic_sum w0`j'chronic_sum
}

drop w07chronic_m w08chronic_m 

// cross-weight 
forval i=1/8{
	rename w0`i'wgt_c wgt_c`i'
}

forval i=2/8{
	drop w0`i'wgt_p
}

forval j=6/8{
	drop w0`j'wgt_ac w0`j'wgt_ap
}
drop w05wgt_a

//number of panels in survey / fam characteristics
gen w08A003=.
gen w06_fam2=.
gen w05chid_10=.
gen w06chid_10=.
gen w07chid_10=.
gen w08chid_10=.
rename w06Ba021_09 w06Ba021_09w5
rename w07Ba021_09 w07Ba021_09w5
rename w08Ba021_09 w08Ba021_09w5
rename w01Agriculture w01agriculture
rename w01Assetinc w01assetinc
rename w01Annuity w01annuity
forval i=1/9{
rename w05Ba021_0`i'w5 w05Ba021m01_0`i' 
rename w06Ba021_0`i'w5 w06Ba021m01_0`i'
rename w07Ba021_0`i'w5 w07Ba021m01_0`i'
rename w08Ba021_0`i'w5 w08Ba021m01_0`i'

rename w05Ba028_0`i'w5 w05ba028_0`i'
rename w06Ba028_0`i'w5 w06ba028_0`i'
rename w07Ba028_0`i'w5 w07ba028_0`i'
rename w08Ba028_0`i'w5 w08ba028_0`i'
rename w05Ba029_0`i'w5 w05Ba021m02_0`i'
rename w06Ba029_0`i'w5 w06Ba021m02_0`i'
rename w07Ba029_0`i'w5 w07Ba021m02_0`i'
rename w08Ba029_0`i'w5 w08Ba021m02_0`i'
}

	rename w06E120 w06basic_start

//A-B
forval i=1/8{
	rename w0`i'panel_n panel_n`i'
	rename w0`i'_fam1 fam`i'
	rename w0`i'hhsize hhsize`i'
	rename w0`i'A002 birth`i'
	rename w0`i'A020 birth_spouse`i'
	rename w0`i'A022 educ_spouse`i'
	rename w0`i'A033m01 religion`i'
	rename w0`i'A002_age age`i'
	rename w0`i'marital marital`i'
	rename w0`i'edu edu`i'
	rename w0`i'gender1 gender`i'
	rename w0`i'region1 region1`i'
	rename w0`i'region2 region2`i'
	rename w0`i'region3 region3`i'
	rename w0`i'chgender_01 child1gender`i'
	rename w0`i'chgender_02 child2gender`i'
	rename w0`i'chgender_03 child31gender`i'
	rename w0`i'chgender_04 child41gender`i'
	rename w0`i'chgender_05 child5gender`i'
	rename w0`i'chgender_06 child6gender`i'
	rename w0`i'chgender_07 child7gender`i'
	rename w0`i'chgender_08 child8gender`i'
	rename w0`i'chgender_09 child9gender`i'
	rename w0`i'Ba008_01 child1age`i'
	rename w0`i'Ba008_02 child2age`i'
	rename w0`i'Ba008_03 child3age`i'
	rename w0`i'Ba008_04 child4age`i'
	rename w0`i'Ba008_05 child5age`i'
	rename w0`i'Ba008_06 child6age`i'
	rename w0`i'Ba008_07 child7age`i'
	rename w0`i'Ba008_08 child8age`i'
	rename w0`i'Ba008_09 child9age`i'
	rename w0`i'Ba009_01 child1edu`i'
	rename w0`i'Ba009_02 child2edu`i'
	rename w0`i'Ba009_03 child3edu`i'
	rename w0`i'Ba009_04 child4edu`i'
	rename w0`i'Ba009_05 child5edu`i'
	rename w0`i'Ba009_06 child6edu`i'
	rename w0`i'Ba009_07 child7edu`i'
	rename w0`i'Ba009_08 child8edu`i'
	rename w0`i'Ba009_09 child9edu`i'
	rename w0`i'Ba012_01 child1work`i'
	rename w0`i'Ba012_02 child2work`i'
	rename w0`i'Ba012_03 child3work`i'
	rename w0`i'Ba012_04 child4work`i'
	rename w0`i'Ba012_05 child5work`i'
	rename w0`i'Ba012_06 child6work`i'
	rename w0`i'Ba012_07 child7work`i'
	rename w0`i'Ba012_08 child8work`i'
	rename w0`i'Ba012_09 child9work`i'
	rename w0`i'Ba013_01 child1cohabit`i'
	rename w0`i'Ba013_02 child2cohabit`i'
	rename w0`i'Ba013_03 child3cohabit`i'
	rename w0`i'Ba013_04 child4cohabit`i'
	rename w0`i'Ba013_05 child5cohabit`i'
	rename w0`i'Ba013_06 child6cohabit`i'
	rename w0`i'Ba013_07 child7cohabit`i'
	rename w0`i'Ba013_08 child8cohabit`i'
	rename w0`i'Ba013_09 child9cohabit`i'
	rename w0`i'Ba015_01 child1house`i'
	rename w0`i'Ba015_02 child2house`i'
	rename w0`i'Ba015_03 child3house`i'
	rename w0`i'Ba015_04 child4house`i'
	rename w0`i'Ba015_05 child5house`i'
	rename w0`i'Ba015_06 child6house`i'
	rename w0`i'Ba015_07 child7house`i'
	rename w0`i'Ba015_08 child8house`i'
	rename w0`i'Ba015_09 child9house`i'
	rename w0`i'Ba016_01 child1marital`i'
	rename w0`i'Ba016_02 child2marital`i'
	rename w0`i'Ba016_03 child31marital`i'
	rename w0`i'Ba016_04 child4marital`i'
	rename w0`i'Ba016_05 child5marital`i'
	rename w0`i'Ba016_06 child6marital`i'
	rename w0`i'Ba016_07 child7marital`i'
	rename w0`i'Ba016_08 child8marital`i'
	rename w0`i'Ba016_09 child9marital`i'
	rename w0`i'Ba017_01 child1child`i'
	rename w0`i'Ba017_02 child2child`i'
	rename w0`i'Ba017_03 child3child`i'
	rename w0`i'Ba017_04 child4child`i'
	rename w0`i'Ba017_05 child5child`i'
	rename w0`i'Ba017_06 child6child`i'
	rename w0`i'Ba017_07 child7child`i'
	rename w0`i'Ba017_08 child8child`i'
	rename w0`i'Ba017_09 child9child`i'
	rename w0`i'Ba018_01 child1location`i'
	rename w0`i'Ba018_02 child2location`i'
	rename w0`i'Ba018_03 child3location`i'
	rename w0`i'Ba018_04 child4location`i'
	rename w0`i'Ba018_05 child5location`i'
	rename w0`i'Ba018_06 child6location`i'
	rename w0`i'Ba018_07 child7location`i'
	rename w0`i'Ba018_08 child8location`i'
	rename w0`i'Ba018_09 child9location`i'
	rename w0`i'Ba021m01_01 child1finsupport_nocohbit`i'
	rename w0`i'Ba021m01_02 child2finsupport_nocohbit`i'
	rename w0`i'Ba021m01_03 child3finsupport_nocohbit`i'
	rename w0`i'Ba021m01_04 child4finsupport_nocohbit`i'
	rename w0`i'Ba021m01_05 child5finsupport_nocohbit`i'
	rename w0`i'Ba021m01_06 child6finsupport_nocohbit`i'
	rename w0`i'Ba021m01_07 child7finsupport_nocohbit`i'
	rename w0`i'Ba021m01_08 child8finsupport_nocohbit`i'
	rename w0`i'Ba021m01_09 child9finsupport_nocohbit`i'
	rename w0`i'Ba022_01 child1finintensive_nocohbit`i'
	rename w0`i'Ba022_02 child2finintensive_nocohbit`i'
	rename w0`i'Ba022_03 child3finintensive_nocohbit`i'
	rename w0`i'Ba022_04 child4finintensive_nocohbit`i'
	rename w0`i'Ba022_05 child5finintensive_nocohbit`i'
	rename w0`i'Ba022_06 child6finintensive_nocohbit`i'
	rename w0`i'Ba022_07 child7finintensive_nocohbit`i'
	rename w0`i'Ba022_08 child8finintensive_nocohbit`i'
	rename w0`i'Ba022_09 child9finintensive_nocohbit`i'
	rename w0`i'Ba021m02_01 child1finsupport_irregul`i'
	rename w0`i'Ba021m02_02 child2finsupport_irregul`i'
	rename w0`i'Ba021m02_03 child3finsupport_irregul`i'
	rename w0`i'Ba021m02_04 child4finsupport_irregul`i'
	rename w0`i'Ba021m02_05 child5finsupport_irregul`i'
	rename w0`i'Ba021m02_06 child6finsupport_irregul`i'
	rename w0`i'Ba021m02_07 child7finsupport_irregul`i'
	rename w0`i'Ba021m02_08 child8finsupport_irregul`i'
	rename w0`i'Ba021m02_09 child9finsupport_irregul`i'
	rename w0`i'Ba029_01 child1finintensive_irregul`i'
	rename w0`i'Ba029_02 child2finintensive_irregul`i'
	rename w0`i'Ba029_03 child3finintensive_irregul`i'
	rename w0`i'Ba029_04 child4finintensive_irregul`i'
	rename w0`i'Ba029_05 child5finintensive_irregul`i'
	rename w0`i'Ba029_06 child6finintensive_irregul`i'
	rename w0`i'Ba029_07 child7finintensive_irregul`i'
	rename w0`i'Ba029_08 child8finintensive_irregul`i'
	rename w0`i'Ba029_09 child9finintensive_irregul`i'
	rename w0`i'bb_adl1 ADL`i'
	rename w0`i'bb_adl_num1 ADLfam`i'
	rename w0`i'bb_adl3 IADL`i'
	rename w0`i'bb_adl_num3 IADLfam`i'
	rename w0`i'transferfrom tot_transfer`i'
	rename w0`i'fromchildren trans_child`i'
	rename w0`i'fromparent trans_parents`i' 
	rename w0`i'fromothers trans_others`i' 
	rename w0`i'transferto tot_transferto`i' 
	rename w0`i'tochildren transto_child`i'
	rename w0`i'toparent transto_parents`i' 
	rename w0`i'toothers transto_others`i'
	}
	
//
gen  w01C218_04=.
gen  w01C218_05=.
gen  w01C219_04=.
gen  w01C219_05=.
gen  w01C220_04=.
gen  w01C220_05=.
gen  w01C221_04=.
gen  w01C221_05=.

forval i=1/8{
	rename w0`i'C001 healthcond`i'
	rename w0`i'C152 SRH`i' 
	rename w0`i'C003 obstacle`i' 
	rename w0`i'C005 laborlimit`i'
	rename w0`i'C144 depress`i' 
	rename w0`i'C218_01 relation1_caregiver`i' 
	rename w0`i'C218_02 relation2_caregiver`i' 
	rename w0`i'C218_03 relation3_caregiver`i' 
	rename w0`i'C218_04 relation4_caregiver`i' 
	rename w0`i'C218_05 relation5_caregiver`i'
	rename w0`i'C219_01 day1_caregiver`i' 
	rename w0`i'C219_02 day2_caregiver`i' 
	rename w0`i'C219_03 day3_caregiver`i'
	rename w0`i'C219_04 day4_caregiver`i' 
	rename w0`i'C219_05 day5_caregiver`i'
	rename w0`i'C220_01 hour1_caregiver`i' 
	rename w0`i'C220_02 hour2_caregiver`i' 
	rename w0`i'C220_03 hour3_caregiver`i'
	rename w0`i'C220_04 hour4_caregiver`i' 
	rename w0`i'C220_05 hour5_caregiver`i'
	rename w0`i'C221_01 pay1_caregiver`i' 
	rename w0`i'C221_02 pay2_caregiver`i' 
	rename w0`i'C221_03 pay3_caregiver`i'
	rename w0`i'C221_04 pay4_caregiver`i' 
	rename w0`i'C221_05 pay5_caregiver`i'
	rename w0`i'C222_01 amount1_caregiver`i' 
	rename w0`i'C301 NHIS`i'
	rename w0`i'C302 NHIS_type`i'
	rename w0`i'C303 NHIS_type_job`i'
	rename w0`i'C304 Homeowner`i'
	rename w0`i'C305 whopay_NHIS`i'
	rename w0`i'C306 monthly_NHIS`i'
	rename w0`i'C310 private_Insure`i'
	rename w0`i'C311 num_private`i'
	rename w0`i'C312 pay_private`i'
	rename w0`i'present_ecotype employ`i'
	rename w0`i'job_search lookforjob`i'
	rename w0`i'present_labor work`i'
	rename w0`i'emp worktype`i' 
	rename w0`i'ind industry`i'
	rename w0`i'job jobtype`i'
	rename w0`i'job_starty startyear`i' 
	rename w0`i'wage wageinc`i'
	rename w0`i'selfemployed selfemployedinc`i'
	rename w0`i'agriculture agricinc`i'
	rename w0`i'sideline sidelineinc`i'
	rename w0`i'earned earnedinc`i'
	rename w0`i'financial financialinc`i'
	rename w0`i'realestateinc realestateinc`i'
	rename w0`i'assetinc assetinc`i' 
	rename w0`i'national nationalinc`i' 
	rename w0`i'particular particularinc`i' 
	rename w0`i'annuity annuityinc`i' 
	rename w0`i'unemployment unemployedinc`i'
	rename w0`i'industrial industrialinc`i' 
	rename w0`i'guarantee guaranteeinc`i' 
	rename w0`i'exploit exploitinc`i'
	rename w0`i'socialwelfare socialwelfareinc`i' 
	rename w0`i'socialsecurity socialsecurityinc`i'
	rename w0`i'publictrans publictransinc`i' 
	rename w0`i'personal personal`i'
	rename w0`i'residence residence`i' 
	rename w0`i'residence_ residence_`i' 
	rename w0`i'regularins regularins`i' 
	rename w0`i'wholelifeins wholelifeins`i' 
	rename w0`i'pensionins pensionins`i'
	rename w0`i'insurance insurance`i'
	rename w0`i'financialasset financialasset`i' 
	rename w0`i'businessfarm businessfarm`i'
	rename w0`i'realestate realestate`i' 
	rename w0`i'otherasset otherasset`i' 
	rename w0`i'passets passets`i' 
	rename w0`i'pliabilities liabilities`i' 
	rename w0`i'pnetassets netassets`i' 
	rename w0`i'f001type homeownership`i'
	rename w0`i'hhinc hhinc`i'
	rename w0`i'pinc pinc`i'
	rename w0`i'hhassets hhassets`i'
	rename w0`i'hhliabilities hhliabilities`i' 
	rename w0`i'hhnetassets hhnetassets`i' 
}
rename w01year1 bornyear 
rename w01year2 bornyear_spouse

//Basic income

forval i=2/4{
	rename w0`i'G110 basicold_apply`i'
	rename w0`i'G111 basicold_receive`i'
	rename w0`i'G113 basicold_eligible`i'
	rename w0`i'G114 basicold_why`i' 
	rename w0`i'G116 basicold_future`i'
}
forval i=5/8{
	rename w0`i'G110 basic_apply`i'
	rename w0`i'G111 basic_receive`i'
	rename w0`i'G113 basic_eligible`i'
	rename w0`i'G114 basic_why`i' 
	rename w0`i'G116 basic_future`i'
	rename w0`i'E111 lastyr_basic_apply`i'
	rename w0`i'E112 lastyr_basic_period`i'
	rename w0`i'E113 lastyr_basic_month`i'
	rename w0`i'senior_pension basic_income`i'
	gen basicold_apply`i'=.
	gen basicold_receive`i'=.
	gen basicold_eligible`i'=.
	gen basicold_why`i' =.
	gen basicold_future`i'=.
	}

	
//LTCI 
forval i=5/8{
	rename w0`i'C318n LTCI_know`i'
	rename w0`i'C319n LTCI_apply`i' 
	rename w0`i'C320n LTCI_received`i'
	rename w0`i'C327n LTCI_type`i'
	rename w0`i'C328n LTCI_exceed`i' 
	}

forval i=1/4{
	gen LTCI_exceed`i'=.
	gen LTCI_type`i'=.
	gen LTCI_received`i'=.
	gen LTCI_apply`i'=.
	gen LTCI_know`i'=.
}
forval i=1/4{
	gen basic_future`i'=.
	gen basic_why`i' =. 
	gen basic_eligible`i'=.
	gen basic_receive`i'=.
	gen basic_apply`i'=.
	gen basic_month`i'=.
	gen basic_income`i'=.
	gen lastyr_basic_apply`i'=. 
	gen lastyr_basic_period`i'=. 
	gen lastyr_basic_month`i'=.
}
	gen basicold_apply1=.
	gen basicold_eligible1=.
	gen basicold_future1=.
	gen basicold_receive1=.
	gen basicold_why1=.

reshape long wgt_c panel_n fam basic_income lastyr_basic_apply lastyr_basic_period lastyr_basic_month hhsize birth birth_spouse educ_spouse religion age marital edu gender region1 region2 region3 child1gender child1age child1edu child1work child1cohabit child1house child1marital child1child child1location child1finsupport_nocohbit child1finintensive_nocohbit child1finsupport_irregul child1finintensive_irregul child2gender child2age child2edu child2work child2cohabit child2house child2marital child2child child2location child2finsupport_nocohbit child2finintensive_nocohbit child2finsupport_irregul child2finintensive_irregul child31gender child3age child3edu child3work child3cohabit child3house child31marital child3child child3location child3finsupport_nocohbit child3finintensive_nocohbit child3finsupport_irregul child3finintensive_irregul child41gender child4age child4edu child4work child4cohabit child4house child4marital child4child child4location child4finsupport_nocohbit child4finintensive_nocohbit child4finsupport_irregul child4finintensive_irregul child5gender child5age child5edu child5work child5cohabit child5house child5marital child5child child5location child5finsupport_nocohbit child5finintensive_nocohbit child5finsupport_irregul child5finintensive_irregul child6gender child6age child6edu child6work child6cohabit child6house child6marital child6child child6location child6finsupport_nocohbit child6finintensive_nocohbit child6finsupport_irregul child6finintensive_irregul child7gender child7age child7edu child7work child7cohabit child7house child7marital child7child child7location child7finsupport_nocohbit child7finintensive_nocohbit child7finsupport_irregul child7finintensive_irregul child8gender child8age child8edu child8work child8cohabit child8house child8marital child8child child8location child8finsupport_nocohbit child8finintensive_nocohbit child8finsupport_irregul child8finintensive_irregul child9gender child9age child9edu child9work child9cohabit child9house child9marital child9child child9location child9finsupport_nocohbit child9finintensive_nocohbit child9finsupport_irregul child9finintensive_irregul ADL ADLfam IADL IADLfam tot_transfer trans_child trans_parents trans_others tot_transferto transto_child transto_parents transto_others healthcond SRH obstacle laborlimit depress relation1_caregiver relation2_caregiver relation3_caregiver relation4_caregiver relation5_caregiver day1_caregiver day2_caregiver day3_caregiver day4_caregiver day5_caregiver hour1_caregiver hour2_caregiver hour3_caregiver hour4_caregiver hour5_caregiver pay1_caregiver pay2_caregiver pay3_caregiver pay4_caregiver pay5_caregiver amount1_caregiver NHIS NHIS_type NHIS_type_job Homeowner whopay_NHIS monthly_NHIS private_Insure num_private pay_private employ lookforjob work worktype industry jobtype startyear wageinc pinc selfemployedinc agricinc sidelineinc earnedinc financialinc realestateinc assetinc nationalinc particularinc annuityinc unemployedinc industrialinc guaranteeinc exploitinc socialwelfareinc socialsecurityinc publictransinc personal residence residence_ regularins wholelifeins pensionins insurance financialasset businessfarm realestate otherasset passets liabilities netassets homeownership hhinc hhassets hhliabilities hhnetassets chronic_total chronic_a chronic_b chronic_c basic_future basic_why basic_eligible basic_receive basic_apply LTCI_exceed LTCI_type LTCI_received LTCI_apply LTCI_know basicold_apply basicold_receive basicold_eligible basicold_future basicold_why,i(pid) j(year)

save "fieldpaper.dta", replace 









*======================================================*
*** Variable Construction 

* Year Variable 
gen time=year
replace year=2006 if year==1
replace year=2008 if year==2
replace year=2010 if year==3
replace year=2012 if year==4
replace year=2014 if year==5
replace year=2016 if year==6
replace year=2018 if year==7
replace year=2020 if year==8
replace year=2022 if year==9
 
* Treatment variable 
// For BP recipients identification, the following steps were undertaken:
// w0`i'basic_starty: the year recipients started to receive BP benefits
forval i=7/9{
	replace w0`i'basic_starty = . if w0`i'basic_starty<0
}
replace w06E120y = . if w06E120y<2008
replace w05E120 = . if w05E120<2008

// 1. Use the report for when i started to receive BP 
gen BP = w05E120
replace BP = 2008 if BP>=200800 & BP<=200812
replace BP = 2009 if BP>=200900 & BP<=200912
replace BP = 2010 if BP>=201000 & BP<=201012
replace BP = 2011 if BP>=201100 & BP<=201112
replace BP = 2012 if BP>=201200 & BP<=201212
replace BP = 2013 if BP>=201300 & BP<=201312
replace BP = 2014 if BP>=201400 & BP<=201412

// update from the oldest data to the old data
replace BP =  w06E120y if BP ==. &  w06E120y <.

replace BP = w07basic_starty if BP==. & w07basic_starty<.

replace BP = w08basic_starty if BP==. & w08basic_starty<.

replace BP = w09basic_starty if BP==. & w09basic_starty<.


// 3. Fill out the remaining missing information from the earlest actual receipt 

*2008 data 
replace BP = 2008 if w02G111 ==1 & BP ==.

*2010 data 
replace BP = 2008 if w03G110==1 & w03G111==1 & BP ==. 
replace BP = 2008 if w03G110==3 & w03G111==1 & BP ==. 
replace BP = 2009 if w03G110==6 & w03G111==1 & BP ==. 
replace BP = 2010 if w03G110==7 & w03G111==1 & BP ==. 

*2012 data 
replace BP = 2008 if w04G110==1 & w04G111==1 & BP ==. 
replace BP = 2008 if w04G110==2 & w04G111==1 & BP ==. 
replace BP = 2009 if w04G110==3 & w04G111==1 & BP ==. 
replace BP = 2010 if w04G110==4 & w04G111==1 & BP ==. 
replace BP = 2011 if w04G110==5 & w04G111==1 & BP ==. 
replace BP = 2012 if w04G110==6 & w04G111==1 & BP ==. 

*2014 data 
replace BP = 2008 if w05G110==1 & w05G111==1 & BP ==. 
replace BP = 2008 if w05G110==2 & w05G111==1 & BP ==. 
replace BP = 2009 if w05G110==3 & w05G111==1 & BP ==. 
replace BP = 2010 if w05G110==4 & w05G111==1 & BP ==. 
replace BP = 2011 if w05G110==5 & w05G111==1 & BP ==. 
replace BP = 2012 if w05G110==6 & w05G111==1 & BP ==. 
replace BP = 2013 if w05G110==7 & w05G111==1 & BP ==. 
replace BP = 2014 if w05G110==8 & w05G111==1 & BP ==. 

*2016 data 
replace BP = 2008 if w06G110==1 & w06G111==1 & BP ==. 
replace BP = 2008 if w06G110==2 & w06G111==1 & BP ==. 
replace BP = 2009 if w06G110==3 & w06G111==1 & BP ==. 
replace BP = 2010 if w06G110==4 & w06G111==1 & BP ==. 
replace BP = 2011 if w06G110==5 & w06G111==1 & BP ==. 
replace BP = 2012 if w06G110==6 & w06G111==1 & BP ==. 
replace BP = 2013 if w06G110==7 & w06G111==1 & BP ==. 
replace BP = 2014 if w06G110==8 & w06G111==1 & BP ==. 
replace BP = 2015 if w06G110==9 & w06G111==1 & BP ==. 


*2018 data 
replace BP = 2008 if w07G110==1 & w07G111==1 & BP ==. 
replace BP = 2008 if w07G110==2 & w07G111==1 & BP ==. 
replace BP = 2009 if w07G110==3 & w07G111==1 & BP ==. 
replace BP = 2010 if w07G110==4 & w07G111==1 & BP ==. 
replace BP = 2011 if w07G110==5 & w07G111==1 & BP ==. 
replace BP = 2012 if w07G110==6 & w07G111==1 & BP ==. 
replace BP = 2013 if w07G110==7 & w07G111==1 & BP ==. 
replace BP = 2014 if w07G110==8 & w07G111==1 & BP ==. 
replace BP = 2015 if w07G110==9 & w07G111==1 & BP ==. 
replace BP = 2016 if w07G110==10 & w07G111==1 & BP ==. 
replace BP = 2017 if w07G110==11 & w07G111==1 & BP ==. 


*2020 data 
replace BP = 2008 if w08G110==1 & w08G111==1 & BP ==. 
replace BP = 2008 if w08G110==2 & w08G111==1 & BP ==. 
replace BP = 2009 if w08G110==3 & w08G111==1 & BP ==. 
replace BP = 2010 if w08G110==4 & w08G111==1 & BP ==. 
replace BP = 2011 if w08G110==5 & w08G111==1 & BP ==. 
replace BP = 2012 if w08G110==6 & w08G111==1 & BP ==. 
replace BP = 2013 if w08G110==7 & w08G111==1 & BP ==. 
replace BP = 2014 if w08G110==8 & w08G111==1 & BP ==. 
replace BP = 2015 if w08G110==9 & w08G111==1 & BP ==. 
replace BP = 2016 if w08G110==10 & w08G111==1 & BP ==. 
replace BP = 2017 if w08G110==11 & w08G111==1 & BP ==. 
replace BP = 2018 if w08G110==12 & w08G111==1 & BP ==. 
replace BP = 2019 if w08G110==13 & w08G111==1 & BP ==. 
replace BP = 2020 if w08G110==14 & w08G111==1 & BP ==. 


*2022 data 
replace BP = 2008 if w09G110==1 & w09G111==1 & BP ==. 
replace BP = 2008 if w09G110==2 & w09G111==1 & BP ==. 
replace BP = 2009 if w09G110==3 & w09G111==1 & BP ==. 
replace BP = 2010 if w09G110==4 & w09G111==1 & BP ==. 
replace BP = 2011 if w09G110==5 & w09G111==1 & BP ==. 
replace BP = 2012 if w09G110==6 & w09G111==1 & BP ==. 
replace BP = 2013 if w09G110==7 & w09G111==1 & BP ==. 
replace BP = 2014 if w09G110==8 & w09G111==1 & BP ==. 
replace BP = 2015 if w09G110==9 & w09G111==1 & BP ==. 
replace BP = 2016 if w09G110==10 & w09G111==1 & BP ==. 
replace BP = 2017 if w09G110==11 & w09G111==1 & BP ==. 
replace BP = 2018 if w09G110==12 & w09G111==1 & BP ==. 
replace BP = 2019 if w09G110==13 & w09G111==1 & BP ==. 
replace BP = 2020 if w09G110==14 & w09G111==1 & BP ==. 
replace BP = 2021 if w09G110==15 & w09G111==1 & BP ==. 
replace BP = 2022 if w09G110==16 & w09G111==1 & BP ==. 

replace BP = 0 if BP==.



replace BP = 2010 if BP ==2009
replace BP = 2012 if BP ==2011
replace BP = 2014 if BP ==2013
replace BP = 2016 if BP ==2015
replace BP = 2018 if BP ==2017
replace BP = 2020 if BP ==2019
replace BP = 2022 if BP ==2021


*BP actual receipt
gen BP_receive=0 
forval i=2/9{
	replace BP_receive=1 if w0`i'G111==1 & time==`i'
}


********************************
///  WIDE TO LONG CONVERSION ///
********************************
reshape long mark ,i(pid) j(year)
