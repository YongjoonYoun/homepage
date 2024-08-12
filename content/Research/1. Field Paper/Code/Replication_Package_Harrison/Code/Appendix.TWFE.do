*******************************************
* TWFE_Analysis_KLoSA.do				  *
* Created By: Harrison Youn				  *
* Last Edited By: Harrison Youn  		  *
* Date Last Edited: 05/27/2024			  *
*******************************************

set more off
clear all

*********************
///  IMPORT FILE  ///
*********************
// SET DIRECTORY
cd ""	

// IMPORT DATA 
use ANALYSIS.dta


// 1. TWFE (NOT HETEROGENITY ROBUST: TWFE BIAS)
// W/O CONTROLS 

* EXTENSIVE MARGINS (FROM)
********************************************************************
reghdfe FROMCHILD_EXTEN_SUM BP_FIRST_ABSORB edu emp livchildren livgrandchild child1_age child1_edu child1_emp child1_own child1_marital if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe FROMCHILD_EXTEN_SUM BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe FROMCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe FROMCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==2 , absorb(hhid year) cluster(urban) // OVERALL FROR SW 

reghdfe FROMCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

reghdfe FROMCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==4 , absorb(hhid year) cluster(urban) // OVERALL FROR CW 

* EXTENSIVE MARGINS (FROM): NON-CORESIDENT CHILDREN 
reghdfe FROMCHILD_NON_EXTEN_SUM BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe FROMCHILD_NON_EXTEN_SUM BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe FROMCHILD_NON_EXTEN_SUM BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

reghdfe FROMCHILD_NON_EXTEN_REGULAR BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe FROMCHILD_NON_EXTEN_REGULAR BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe FROMCHILD_NON_EXTEN_REGULAR BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

reghdfe FROMCHILD_NON_EXTEN_IRREGULAR BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe FROMCHILD_NON_EXTEN_IRREGULAR BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe FROMCHILD_NON_EXTEN_IRREGULAR BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

* EXTENSIVE MARGINS (FROM): CORESIDENT CHILDREN 
reghdfe FROMCHILD_CO_EXTEN_SUM BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe FROMCHILD_CO_EXTEN_SUM BP_FIRST_ABSORB if household ==2 , absorb(hhid year) cluster(urban) // OVERALL FROR SW 

reghdfe FROMCHILD_CO_EXTEN_SUM BP_FIRST_ABSORB if household ==4 , absorb(hhid year) cluster(urban) // OVERALL FROR CW 
********************************************************************


* EXTENSIVE MARGINS (TO)
********************************************************************
reghdfe TOCHILD_EXTEN_SUM BP_FIRST_ABSORB edu emp livchildren livgrandchild child1_age child1_edu child1_emp child1_own child1_marital if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe TOCHILD_EXTEN_SUM BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe TOCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe TOCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==2 , absorb(hhid year) cluster(urban) // OVERALL FROR SW 

reghdfe TOCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

reghdfe TOCHILD_EXTEN_SUM BP_FIRST_ABSORB if household ==4 , absorb(hhid year) cluster(urban) // OVERALL FROR CW 

* EXTENSIVE MARGINS (TO): NON-CORESIDENT CHILDREN 
reghdfe TOCHILD_NON_EXTEN_SUM BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe TOCHILD_NON_EXTEN_SUM BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe TOCHILD_NON_EXTEN_SUM BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

reghdfe TOCHILD_NON_EXTEN_REGULAR BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe TOCHILD_NON_EXTEN_REGULAR BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe TOCHILD_NON_EXTEN_REGULAR BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

reghdfe TOCHILD_NON_EXTEN_IRREGULAR BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe TOCHILD_NON_EXTEN_IRREGULAR BP_FIRST_ABSORB if household ==1 , absorb(hhid year) cluster(urban) // OVERALL FROR SO 

reghdfe TOCHILD_NON_EXTEN_IRREGULAR BP_FIRST_ABSORB if household ==3 , absorb(hhid year) cluster(urban) // OVERALL FROR CO 

* EXTENSIVE MARGINS (TO): CORESIDENT CHILDREN 
reghdfe TOCHILD_CO_EXTEN_SUM BP_FIRST_ABSORB if household <. , absorb(hhid year) cluster(urban) // OVERALL FOR ALL SAMPLE 

reghdfe TOCHILD_CO_EXTEN_SUM BP_FIRST_ABSORB if household ==2 , absorb(hhid year) cluster(urban) // OVERALL FROR SW 

reghdfe TOCHILD_CO_EXTEN_SUM BP_FIRST_ABSORB if household ==4 , absorb(hhid year) cluster(urban) // OVERALL FROR CW 
********************************************************************


// 2. EXTENDED TWFE (HETEROGENITY ROBUST)
// W/O CONTROLS 

* EXTENSIVE MARGINS (FROM): SUM
********************************************************************
jwdid FROMCHILD_EXTEN_SUM BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_EXTEN_SUM BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_EXTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_EXTEN_SUM BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_EXTEN_SUM BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

* EXTENSIVE MARGINS (FROM): NON-CORESIDENT CHILDREN 
jwdid FROMCHILD_NON_EXTEN_SUM BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_SUM BP if household ==1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_SUM BP if household ==3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_REGULAR BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_REGULAR BP if household ==1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_REGULAR BP if household ==3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_IRREGULAR BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_IRREGULAR BP if household ==1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_NON_EXTEN_IRREGULAR BP if household ==3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

* EXTENSIVE MARGINS (FROM): CORESIDENT CHILDREN 
jwdid FROMCHILD_CO_EXTEN_SUM BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_CO_EXTEN_SUM BP if household ==2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid FROMCHILD_CO_EXTEN_SUM BP if household ==4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
********************************************************************


* EXTENSIVE MARGINS (TO): SUM
********************************************************************
jwdid TOCHILD_EXTEN_SUM BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_EXTEN_SUM BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_EXTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_EXTEN_SUM BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_EXTEN_SUM BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

* EXTENSIVE MARGINS (TO): NON-CORESIDENT CHILDREN 
jwdid TOCHILD_NON_EXTEN_SUM BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_SUM BP if household ==1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_SUM BP if household ==3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_REGULAR BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_REGULAR BP if household ==1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_REGULAR BP if household ==3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_IRREGULAR BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_IRREGULAR BP if household ==1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_NON_EXTEN_IRREGULAR BP if household ==3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

* EXTENSIVE MARGINS (TO): CORESIDENT CHILDREN 
jwdid TOCHILD_CO_EXTEN_SUM BP if household <. , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_CO_EXTEN_SUM BP if household ==2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)

jwdid TOCHILD_CO_EXTEN_SUM BP if household ==4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
********************************************************************