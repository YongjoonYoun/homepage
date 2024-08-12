*******************************************
* 5.Variable_Cleaning_KLoSA.do			  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 04/27/2024			  *
*******************************************

set more off
clear all

*********************
///  IMPORT FILE  ///
*********************
// SET DIRECTORY
cd "\\DESKTOP-OK2B73D\Users\Yongjoon\Desktop\Research\1. Unconditional cash transfers and family transfers in Korea\Data"	

// IMPORT DATA 
use SampleHH.dta

*******************************
///  VARIABLE CONSTRUCTION  ///
*******************************
****************
// BACKGROUND //
****************
// RESPONDENT ID
lab var pid "Respondent Identification Number"

// HH ID 
forval i = 1/9{
	rename hhid0`i' hhid`i'
	lab var hhid`i' "Household Identification Number"
}

// COUPLE ID 
forval i = 1/9{
	rename cid0`i' cid`i'
	lab var cid`i' "Couple Identification Number"
}

// AGE
forval i = 1/9{
	rename w0`i'A002_age age`i'
	lab var age`i' "Respondent Age"
}

* SPOUSE 
forval i = 1/9{
	replace w0`i'A020 = 2004 + 2*`i' - w0`i'A020 if w0`i'A020 < . & w0`i'A020 > 0
	rename w0`i'A020 spouse_age`i'
}

// GENDER 
lab def gender 0 "0.Female" 1 "1.Male"
forval i=1/9{
	rename w0`i'gender1 gender`i'
	replace gender`i' = 0 if gender`i' == 5 
	lab var gender`i' "Gender"
	lab val gender`i' gender 
}

// MARITAL STATUS
lab def marital 1 "1.Live with Spouse" 2 "2.Not married/not live w/ spouse"  	
forval i=1/9{
	rename w0`i'marital marital`i'
	replace marital`i' = 2 if marital`i' >= 3 & marital`i' < .
	lab var marital`i' "Marital Status"
	lab val marital`i' marital 
}

// EDUCATION
lab def edu 1 "1.Elementary School" 2 "2.Middle School" 3 "3.High School" 4 "4.College or above"  
forval i=1/9{
	rename w0`i'edu edu`i'
	replace edu`i' = 1 if edu`i' <1
	lab var edu`i' "Education Level"
	lab val edu`i' edu
}

* SPOUSE 
forval i=1/9{
	rename w0`i'A022 spouse_edu`i'
	replace spouse_edu`i' = 1 if spouse_edu`i' <3 | spouse_edu`i' == 97
	replace spouse_edu`i' = 2 if spouse_edu`i' == 4
	replace spouse_edu`i' = 3 if spouse_edu`i' == 5
	replace spouse_edu`i' = 4 if spouse_edu`i' >= 6 & spouse_edu`i' < .
	
	lab var spouse_edu`i' "Education Level"
	lab val spouse_edu`i' edu
}

// EMPLOYMENT 
* RESPONDENT 
lab def emp 0 "0.Not Working" 1 "1.Working"
forval i=1/9{
	rename w0`i'present_labor emp`i'
	replace emp`i' = 1 if emp`i' >= 1 & emp`i' < =2 
	replace emp`i' = 0 if emp`i' >= 3 & emp`i' <. 
	lab var emp`i' "Employment Status"
	lab val emp`i' emp
}


* SPOUSE 
forval i=1/9{
	rename w0`i'A028 spouse_emp`i'
	replace spouse_emp`i' = 1 if spouse_emp`i' >= 1 & spouse_emp`i' < =2 
	replace spouse_emp`i' = 0 if spouse_emp`i' >= 3 & spouse_emp`i' <. 
	lab var spouse_emp`i' "Employment Status"
	lab val spouse_emp`i' emp
}

// LIVING AREAS (STATES)
lab def states 1 "1.Seoul" 2 "2.Busan" 3 "3.Daegu" 4 "4.Incheon" 5 "5.Gwangju" 6 "6.Daejeon" 7 "7.Ulsan" 8 "8.Sejong" 9 "9.Gyeonggi" 10 "10.Gangwon" 11 "11.Chungbuk" 12 "12.Chungnam" 13 "13.Jeonbuk" 14 "14.Jeonam" 15 "15.Gyeongbuk" 16 "16.Gyeongnam"

forval i=1/9{
	rename w0`i'region1 states`i'
	recode states`i' (11=1)(21=2)(22=3)(23=4)(24=5)(25=6)(26=7)(27=8)(31=9)(32=10)(33=11)(34=12)(35=13)(36=14)(37=15)(38=16)
	lab var states`i' "Living States"
	lab val states`i' states
}

// URBANNESS 
lab def urban 1 "1.LARGE CITY" 2 "2.MIDDLE CITY" 3 "3.COUNTRY"
forval i=1/9{
	rename w0`i'region3 urban`i'
	lab var urban`i' "Urbanness"
	lab val urban`i' urban
}

// NUMBER OF LIVING CHILDREN 
forval i=1/9{
	rename w0`i'Ba003 livchildren`i'
	lab var livchildren`i' "Number of Living Children"
}

// NUMBER OF LIVING GRAND CHILDREN 
forval i=1/9{
	rename w0`i'Ba068 livgrandchildren`i'
	lab var livgrandchildren`i' "Number of Living Grand Children"
}

// GRANDCHILD CARE LAST YEAR
lab def answer 0 "0.No" 1 "1.Yes"
forval i=1/9{
	rename w0`i'Ba075 grandchildcare`i'
	replace grandchildcare`i' = 0 if grandchildcare`i' == 5
	lab var grandchildcare`i' "Number of Living Grand Children"
	lab val grandchildcare`i' answer 
}

// GRANDCHILD CARE HOURS
forval i=1/9{
	rename w0`i'Ba076 grandchildcare_AMOUNT`i'
	lab var grandchildcare_AMOUNT`i' "Number of Living Grand Children"
	lab val grandchildcare_AMOUNT`i' answer 
}

// NUMBER OF ADL 
forval i=1/9{
	rename w0`i'adl ADL`i'
	lab var ADL`i' "Number of ADLs"
}

// NUMBER OF IADL 
forval i=1/9{
	rename w0`i'iadl IADL`i'
	lab var IADL`i' "Number of ADLs"
}

// NET LABOR INCOME 
forval i=1/9{
	rename w0`i'E003 laborincome`i'
	lab var laborincome`i' "After Tax Labor Income"
}

// NET BUSINESS INCOME 
forval i=1/9{
	rename w0`i'E012 businessincome`i'
	lab var businessincome`i' "After Tax Business Income"
}


**********************
// SUBJECTIVE BELIF //
**********************
// SUBJECTIVE HEALTH CONDITION 
lab def health 1 "1.Very Bad" 2 "2.Relatively Bad" 3 "3.Okay" 4 "4.Good" 5 "5.Very Good"
forval i=1/9{
	rename w0`i'C152 subjecthealth`i'
	recode subjecthealth`i' (1=5)(5=1)(2=4)(4=2)
	lab var subjecthealth`i' "Subjective Health Condition"
	lab val subjecthealth`i' health 
}

// SUBJECTIVE BELIEF ABOUT GIVING BEQUEST OF $0.75m or over
forval i=1/9{
	rename w0`i'G001 subjectbequestGIVE`i'
	lab var subjectbequestGIVE`i' "Subjective Giving Bequest Chance"
}


// SUBJECTIVE BELIEF ABOUT RECEIVING BEQUEST OF $0.75m or over
forval i=1/9{
	rename w0`i'G002 subjectbequestGET`i'
	lab var subjectbequestGET`i' "Subjective Receiving Bequest Chance"
}

// SUBJECTIVE BELIEF ABOUT GOVERNMENT'S OLD-AGE SECURITY
forval i=1/9{
	rename w0`i'G017 subjectbequestSECURITY`i'
	lab var subjectbequestSECURITY`i' "Subjective Belief About Gov's Role"
}

// SUBJECTIVE BELIEF ABOUT FUTURE WILL BE BETTER
forval i=1/9{
	rename w0`i'G015 subjectFUTURE`i'
	lab var subjectFUTURE`i' "Subjective Belief About Future"
}

// SUBJECTIVE BELIEF ABOUT CLOSENESS WITH CHILDREN
forval i=1/9{
	rename w0`i'G029 subjectCHILDCLOSE`i'
	lab var subjectCHILDCLOSE`i' "Subjective Belief Closeness With Children"
}

// SUBJECTIVE BELIEF ABOUT CLOSENESS WITH SPOUSE
forval i=1/9{
	rename w0`i'G028 subjectSPOUSECLOSE`i'
	lab var subjectSPOUSECLOSE`i' "Subjective Belief Closeness With Spouse"
}

**************
// CHILDREN //
**************
* # CHILD'S AGE 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba008_0`j' child`j'_age`i'
	lab var child`j'_age`i' "Age"
}
}

* # CHILD'S EDUCATION 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba009_0`j' child`j'_edu`i'
	replace child`j'_edu`i' = 1 if child`j'_edu`i' < 3 | child`j'_edu`i' == 97
	replace child`j'_edu`i' = 2 if child`j'_edu`i' == 4 
	replace child`j'_edu`i' = 3 if child`j'_edu`i' == 5
	replace child`j'_edu`i' = 4 if child`j'_edu`i' >= 6 & child`j'_edu`i' < . 
	lab var child`j'_edu`i' "Education Attainment"
	lab val child`j'_edu`i' edu
}
}

* # CHILD'S EMPLOYMENT 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba012_0`j' child`j'_emp`i'
	replace child`j'_emp`i' = 0 if !(child`j'_emp`i' ==1) & child`j'_emp`i' <. 
	lab var child`j'_emp`i' "Employment Status"
	lab val child`j'_emp`i' emp
}
}
	
* # CHILD'S GENDER 
forval i=1/9{
	forval j=1/9{
	rename w0`i'chgender_0`j' child`j'_gender`i'
	replace child`j'_gender`i' = 0 if child`j'_gender`i'== 5 & child`j'_gender`i' <. 
	lab var child`j'_gender`i' "Gender"
	lab val child`j'_gender`i' gender
}
}	
	
* # CHILD'S CORESIDENCE STATUS WITH RESPONDENT
lab def cores 0 "0.Not Living Together" 1 "1.Living Together" 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba013_0`j' child`j'_cores`i'
	replace child`j'_cores`i' = 0 if !(child`j'_cores`i'==1) & child`j'_cores`i' < . 
	lab var child`j'_cores`i' "Coresidence Status"
	lab val child`j'_cores`i' cores
}	
}
	
* # CHILD'S HOMEOWNERSHIP
lab def ownhome 0 "0.Not Have House" 1 "1.Have House" 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba015_0`j' child`j'_ownhome`i'
	replace child`j'_ownhome`i' = 0 if !(child`j'_ownhome`i'==1) & child`j'_ownhome`i' < . 
	lab var child`j'_ownhome`i' "Home Ownership Status"
	lab val child`j'_ownhome`i' ownhome
}	
}
	
* # CHILD'S MARITAL STATUS 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba016_0`j' child`j'_marital`i'
	replace child`j'_marital`i' = 0 if !(child`j'_marital`i'==1) & child`j'_marital`i' < . 
	lab var child`j'_marital`i' "Marital Status"
	lab val child`j'_marital`i' marital 
}	
}
	
* # CHILD'S NUMBER OF LIVING CHILDREN
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba017_0`j' child`j'_livchildren`i'
	lab var child`j'_livchildren`i' "Number of Living Children"
}	
}	
	
* # CHILD'S PHYSICAL PROXIMITY 
lab def proximity 1 "1.Less Than 30 mins w/ Transportation" 2 "2.Less Than 1 Hour w/ Transportation" 3 "3.Less Than 2 Hour w/ Transportation" 4 "4.More Than 2 Hours w/ Transportation"
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba018_0`j' child`j'_proximity`i'
	lab var child`j'_proximity`i' "Physical proximity"
}	
}	


* # CHILD'S FREQUENCY OF MEETING 
lab def meeting 1 "1.Less Than Once a Year" 2 "2.Half-Yearly" 3 "3.Quarterly" 4 "4.Monthly" 5 "5.Weekly" 
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba019_0`j' child`j'_meeting`i'
	replace child`j'_meeting`i' = 1 if child`j'_meeting`i' >= 9 & child`j'_meeting`i' < . 
	replace child`j'_meeting`i' = 2 if child`j'_meeting`i' == 6
	replace child`j'_meeting`i' = 3 if child`j'_meeting`i' == 7 | child`j'_meeting`i' == 8
	replace child`j'_meeting`i' = 4 if child`j'_meeting`i' == 4 
	replace child`j'_meeting`i' = 5 if child`j'_meeting`i' < 4
	lab var child`j'_meeting`i' "Frequency of meeting"
	lab val child`j'_meeting`i' meeting
}	
}	

* # CHILD'S FREQUENCY OF CONTACT
forval i=1/9{
	forval j=1/9{
	rename w0`i'Ba020_0`j' child`j'_contact`i'
	replace child`j'_contact`i' = 1 if child`j'_contact`i' >= 9 & child`j'_contact`i' < . 
	replace child`j'_contact`i' = 2 if child`j'_contact`i' == 6
	replace child`j'_contact`i' = 3 if child`j'_contact`i' == 7 | child`j'_contact`i' == 8
	replace child`j'_contact`i' = 4 if child`j'_contact`i' == 4 
	replace child`j'_contact`i' = 5 if child`j'_contact`i' < 4
	lab var child`j'_contact`i' "Frequency of meeting"
	lab val child`j'_contact`i' meeting
}	
}	

***************
// HOUSEHOLD //
***************
// NET HH ASSETS
forval i=1/9{
	rename w0`i'hhnetasset netassets`i'
	lab var netassets`i' "Net Household Assets"
	}

// TOTAL HH INCOME
forval i=1/9{
	rename w0`i'hhinc hhincome`i'
	replace hhincome`i' = hhincome`i' - BP_CONTINUOUS_AMOUNT`i'
	lab var hhincome`i' "Total Household Income"
	}

// TOTAL HH ASSETS
forval i=1/9{
	rename w0`i'hhassets hhassets`i'
	lab var hhassets`i' "Total Household Assets"
	}

// TOTAL HH DEBTS
forval i=1/9{
	rename w0`i'hhliabilities hhdebts`i'
	lab var hhdebts`i' "Total Household Debts"
	}


//KEEP NECESSARY VARIABLES
keep pid hhid* respid cid* lwchildren* lwsiblings* lwparents* household1-household9 spouse_age* age* spouse_edu* marital* spouse_emp* edu* gender* states* urban* livchildren* child*_age* child*_edu* child*_emp* child*_cores* child*_ownhome* child*_marital* child*_gender* child*_livchildren* child*_proximity* child*_meeting* child*_contact* livgrandchildren* grandchildcare* grandchildcare_AMOUNT* subjecthealth* ADL* IADL* emp* laborincome* businessincome* hhincome* hhassets* hhdebts* netassets* subjectbequestGIVE* subjectbequestGET* subjectFUTURE* subjectbequestSECURITY* subjectSPOUSECLOSE* subjectCHILDCLOSE* BP_FIRST* last* BP_FIRST_ABSORB* BP_CONTINUOUS_AMOUNT* BP_CONTINUOUS_EXTEN* FROMCHILD_EXTEN_TOTAL* FROMCHILD_NON_EXTEN_IRREGULAR* FROMCHILD_NON_EXTEN_REGULAR* FROMCHILD_NON_EXTEN_SUM* FROMCHILD_NON_EXTEN_GOODS* FROMCHILD_CO_EXTEN_SUM* FROMCHILD_EXTEN_SUM* TOCHILD_EXTEN_TOTAL* TOCHILD_NON_EXTEN_IRREGULAR* TOCHILD_NON_EXTEN_REGULAR* TOCHILD_NON_EXTEN_SUM* TOCHILD_NON_EXTEN_GOODS* TOCHILD_CO_EXTEN_SUM* TOCHILD_EXTEN_SUM* FROMCHILD_INTEN_TOTAL* FROMCHILD_NON_INTEN_IRREGULAR* FROMCHILD_NON_INTEN_REGULAR* FROMCHILD_NON_INTEN_SUM* FROMCHILD_CO_INTEN_SUM* FROMCHILD_INTEN_SUM* TOCHILD_INTEN_TOTAL* TOCHILD_NON_INTEN_IRREGULAR* TOCHILD_NON_INTEN_REGULAR* TOCHILD_NON_INTEN_SUM* TOCHILD_CO_INTEN_SUM* TOCHILD_INTEN_SUM*


********************************
///  WIDE TO LONG CONVERSION ///
********************************
reshape long hhid cid lwchildren lwsiblings lwparents household spouse_age age spouse_edu marital spouse_emp edu gender states urban livchildren child1_age child2_age child3_age child4_age child5_age child6_age child7_age child8_age child9_age child1_gender child2_gender child3_gender child4_gender child5_gender child6_gender child7_gender child8_gender child9_gender child1_edu child2_edu child3_edu child4_edu child5_edu child6_edu child7_edu child8_edu child9_edu child1_emp child2_emp child3_emp child4_emp child5_emp child6_emp child7_emp child8_emp child9_emp child1_cores child2_cores child3_cores child4_cores child5_cores child6_cores child7_cores child8_cores child9_cores child1_ownhome child2_ownhome child3_ownhome child4_ownhome child5_ownhome child6_ownhome child7_ownhome child8_ownhome child9_ownhome child1_marital child2_marital child3_marital child4_marital child5_marital child6_marital child7_marital child8_marital child9_marital child1_livchildren child2_livchildren child3_livchildren child4_livchildren child5_livchildren child6_livchildren child7_livchildren child8_livchildren child9_livchildren child1_proximity child2_proximity child3_proximity child4_proximity child5_proximity child6_proximity child7_proximity child8_proximity child9_proximity child1_meeting child2_meeting child3_meeting child4_meeting child5_meeting child6_meeting child7_meeting child8_meeting child9_meeting child1_contact child2_contact child3_contact child4_contact child5_contact child6_contact child7_contact child8_contact child9_contact livgrandchildren grandchildcare grandchildcare_AMOUNT subjecthealth ADL IADL emp laborincome businessincome hhincome hhassets hhdebts netassets subjectbequestGIVE subjectbequestGET subjectFUTURE subjectbequestSECURITY subjectSPOUSECLOSE subjectCHILDCLOSE BP_FIRST BP_FIRST_ABSORB BP_CONTINUOUS_AMOUNT BP_CONTINUOUS_EXTEN FROMCHILD_EXTEN_TOTAL FROMCHILD_NON_EXTEN_IRREGULAR FROMCHILD_NON_EXTEN_REGULAR FROMCHILD_NON_EXTEN_SUM FROMCHILD_NON_EXTEN_GOODS FROMCHILD_CO_EXTEN_SUM FROMCHILD_EXTEN_SUM TOCHILD_EXTEN_TOTAL TOCHILD_NON_EXTEN_IRREGULAR TOCHILD_NON_EXTEN_REGULAR TOCHILD_NON_EXTEN_SUM TOCHILD_NON_EXTEN_GOODS TOCHILD_CO_EXTEN_SUM TOCHILD_EXTEN_SUM FROMCHILD_INTEN_TOTAL FROMCHILD_NON_INTEN_IRREGULAR FROMCHILD_NON_INTEN_REGULAR FROMCHILD_NON_INTEN_SUM FROMCHILD_CO_INTEN_SUM FROMCHILD_INTEN_SUM TOCHILD_INTEN_TOTAL TOCHILD_NON_INTEN_IRREGULAR TOCHILD_NON_INTEN_REGULAR TOCHILD_NON_INTEN_SUM TOCHILD_CO_INTEN_SUM TOCHILD_INTEN_SUM,i(pid) j(year)


*****************************
///  SAMPLE CONSTRUCTION  ///
*****************************	
save "ANALYSIS.dta", replace 
