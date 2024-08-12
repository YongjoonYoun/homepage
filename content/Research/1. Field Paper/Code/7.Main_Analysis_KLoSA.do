*******************************************
* 7.Main_Analysis_KLoSA.do				  *
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

*FOR HETEROGENUOUS TREATMENT EFFECTS ESTIMATION 
gen BP = . if hhid<. 
order BP, after(BP_FIRST_ABSORB)
sort pid hhid
replace BP = 3 if  household <. & year == 3 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 4 if  household < . & year == 4 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 5 if  household < . & year == 5 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 6 if  household < . & year == 6 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 7 if  household < . & year == 7 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 8 if  household < . & year == 8 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 9 if  household < . & year == 9 & BP_FIRST_ABSORB == 1 & BP == . 
by pid: replace BP = BP[_n-1] if missing(BP) & household < .
replace BP = 0 if BP_FIRST_ABSORB == 0 & BP ==. & household < .
replace BP = . if BP_FIRST_ABSORB == . 


*******************************
/// RESCALE FROM KRW TO USD ///
*******************************
replace BP_CONTINUOUS_AMOUNT = BP_CONTINUOUS_AMOUNT*10000/1350
replace FROMCHILD_INTEN_SUM = FROMCHILD_INTEN_SUM*10000/1350
replace FROMCHILD_CO_INTEN_SUM  = FROMCHILD_CO_INTEN_SUM *10000/1350
replace FROMCHILD_NON_INTEN_SUM = FROMCHILD_NON_INTEN_SUM*10000/1350
replace FROMCHILD_NON_INTEN_IRREGULAR = FROMCHILD_NON_INTEN_IRREGULAR*10000/1350
replace FROMCHILD_NON_INTEN_REGULAR = FROMCHILD_NON_INTEN_REGULAR*10000/1350
replace TOCHILD_INTEN_SUM = TOCHILD_INTEN_SUM*10000/1350
replace TOCHILD_CO_INTEN_SUM  = TOCHILD_CO_INTEN_SUM *10000/1350
replace TOCHILD_NON_INTEN_SUM = TOCHILD_NON_INTEN_SUM*10000/1350
replace TOCHILD_NON_INTEN_IRREGULAR = TOCHILD_NON_INTEN_IRREGULAR*10000/1350
replace TOCHILD_NON_INTEN_REGULAR = TOCHILD_NON_INTEN_REGULAR*10000/1350


gen lnTOCHILD_INTEN_SUM = log(1+TOCHILD_INTEN_SUM)

csdid lnTOCHILD_INTEN_SUM if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	
*************************
/// BINARY TREATMENT  ///
*************************
// CROWD-OUT EFFECTS 
// TOTAL 
csdid FROMCHILD_INTEN_SUM if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_INTEN_SUM if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_INTEN_SUM if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_INTEN_SUM if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

// NON-CORESIDENT: SUM  
csdid FROMCHILD_NON_INTEN_SUM if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_SUM if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_SUM if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_SUM if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

// NON-CORESIDENT: REGULAR
csdid FROMCHILD_NON_INTEN_REGULAR if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_REGULAR if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_REGULAR if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_REGULAR if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

// NON-CORESIDENT: IRREGULAR 
csdid FROMCHILD_NON_INTEN_IRREGULAR if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_IRREGULAR if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_IRREGULAR if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_NON_INTEN_IRREGULAR if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	


// CORESIDENT 
csdid FROMCHILD_CO_INTEN_SUM if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid FROMCHILD_CO_INTEN_SUM if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	


// SPILLOVER EFFECTS 
// TOTAL 
csdid TOCHILD_INTEN_SUM if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_INTEN_SUM if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_INTEN_SUM if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_INTEN_SUM if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

// NON-CORESIDENT: SUM  
csdid TOCHILD_NON_INTEN_SUM if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_SUM if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_SUM if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_SUM if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

// NON-CORESIDENT: REGULAR
csdid TOCHILD_NON_INTEN_REGULAR if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_REGULAR if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_REGULAR if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_REGULAR if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

// NON-CORESIDENT: IRREGULAR 
csdid TOCHILD_NON_INTEN_IRREGULAR if household == 1, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_IRREGULAR if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_IRREGULAR if household == 3, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_NON_INTEN_IRREGULAR if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	


// CORESIDENT 
csdid TOCHILD_CO_INTEN_SUM if household == 2, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

csdid TOCHILD_CO_INTEN_SUM if household == 4, ivar(pid) time(year) gvar(BP) method(dripw) notyet wboot rseed(01012024) saverif(_rif_) replace 
estat all
estat event, window(-3 5) estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods Since the Event") ytitle("Financial Transfers From Children (%)") title("") xlabel(-3(1)5)) stub_lag(Tp#) stub_lead(Tm#) together  plottype(scatter)	

******************************
// ROBUSTNESS CHECKS: ETWFE //
******************************
// FROM SUM
jwdid FROMCHILD_INTEN_SUM BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_INTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_INTEN_SUM BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_INTEN_SUM BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

//FROM NON-CORESIDENT
jwdid FROMCHILD_NON_INTEN_SUM BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_SUM BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_SUM BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_REGULAR BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_REGULAR BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_REGULAR BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_REGULAR BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_IRREGULAR BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_IRREGULAR BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_IRREGULAR BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_NON_INTEN_IRREGULAR BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple


//FROM CORESIDENT
jwdid FROMCHILD_CO_INTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid FROMCHILD_CO_INTEN_SUM BP if household == 4, ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple


// TO CHILD: SUM 
jwdid TOCHILD_INTEN_SUM BP  if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_INTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_INTEN_SUM BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_INTEN_SUM BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple


// TOCHILD NON-CORESIDENT
jwdid TOCHILD_NON_INTEN_SUM BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_SUM BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_SUM BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

// TOCHILD REGULAR
jwdid TOCHILD_NON_INTEN_REGULAR BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_REGULAR BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_REGULAR BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_REGULAR BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple


// TOCHILD IRREGULAR
jwdid TOCHILD_NON_INTEN_IRREGULAR BP if household == 1 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_IRREGULAR BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_IRREGULAR BP if household == 3 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_NON_INTEN_IRREGULAR BP if household == 4 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

// CORESIDENT
jwdid TOCHILD_CO_INTEN_SUM BP if household == 2 , ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple

jwdid TOCHILD_CO_INTEN_SUM BP if household == 4, ivar(hhid) tvar(year) gvar(BP)
estat event, predict(xb)
estat simple


*************************************************************
// SECTION 6.3: de Chaisemartin and d'Haultfoeuille (2024) //
*************************************************************
// FROM SUM
est clear
did_multiplegt_dyn FROMCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn FROMCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn FROMCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn FROMCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "1.tex", replace booktabs se s(p_joint p_placebo controls)

//FROM NON-CORESIDENT
est clear
did_multiplegt_dyn FROMCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn FROMCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn FROMCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn FROMCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "2.tex", replace booktabs se s(p_joint p_placebo controls)

est clear
did_multiplegt_dyn FROMCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn FROMCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn FROMCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn FROMCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "3.tex", replace booktabs se s(p_joint p_placebo controls)

est clear
did_multiplegt_dyn FROMCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn FROMCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn FROMCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn FROMCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "4.tex", replace booktabs se s(p_joint p_placebo controls)

//FROM CORESIDENT
est clear
did_multiplegt_dyn FROMCHILD_CO_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2


did_multiplegt_dyn FROMCHILD_CO_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "5.tex", replace booktabs se s(p_joint p_placebo controls)


// TO SUM
est clear
did_multiplegt_dyn TOCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(10)   
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn TOCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn TOCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn TOCHILD_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "6.tex", replace booktabs se s(p_joint p_placebo controls)

//TO NON-CORESIDENT
est clear
did_multiplegt_dyn TOCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn TOCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn TOCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn TOCHILD_NON_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "7.tex", replace booktabs se s(p_joint p_placebo controls)

est clear
did_multiplegt_dyn TOCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn TOCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn TOCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn TOCHILD_NON_INTEN_REGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "8.tex", replace booktabs se s(p_joint p_placebo controls)

est clear
did_multiplegt_dyn TOCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 1, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_1

did_multiplegt_dyn TOCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2

did_multiplegt_dyn TOCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 3, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_3

did_multiplegt_dyn TOCHILD_NON_INTEN_IRREGULAR  pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "9.tex", replace booktabs se s(p_joint p_placebo controls)

// TO CORESIDENT
est clear
did_multiplegt_dyn TOCHILD_CO_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 2, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_2


did_multiplegt_dyn TOCHILD_CO_INTEN_SUM pid year BP_CONTINUOUS_AMOUNT if household == 4, effects(5) placebo(3) cluster(hhid) continuous(1) graph_off
estadd scalar p_joint = e(p_equality_effects) 
estadd local controls = "No"
est sto model_4

esttab model_* using "10.tex", replace booktabs se s(p_joint p_placebo controls)




