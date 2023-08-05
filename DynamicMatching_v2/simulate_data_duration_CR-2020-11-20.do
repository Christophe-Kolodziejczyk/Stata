// 1 treatment two competing risks

// haz_S  : hazard to treatment
// haz_U1 : hazard to event 1
// haz_U2 : hazard to event 2
// Ni : number of subjects
// T  : max number of periods

local N 10000
local T 50

clear 
set obs `N'

set seed 80548115

gen id = _n
// drawnorm x
gen x = runiform(-1,1)
// replace x = 0
// replace x = exp(x)

local bS = 0 // 1
local b1 = 0 // 0.4
local b2 = 0 // 0.3

cap drop xb*
gen xbS = -2 + x*`bS'
gen xb1 = -3 + x*`b1' 
gen xb2 = -3 + x*`b2' 
foreach x in S 1 2 {
		gen haz`x' = exp(xb`x')
}

expand `T'
bys id : gen t = _n
sort id t

egen sumHaz = rowtotal(haz1 haz2)
gen  F = 1-exp(-sumHaz)
gen  u = runiform() 
gen uS = runiform()
gen byte failureS = uS <= 1-exp(-hazS) 
gen byte failure  = u <= F
gen u_x = runiform()
gen p = 0
gen cause = 0 if !failure

la def cause 0 "censored" 1  "Process 1" 2 "Process 2" , replace
la val cause cause

local j = 1
foreach x in 1 2 {
		gen p`x' = haz`x'/sumHaz
		replace p = p + p`x'
		replace cause = `j++' if failure & missing(cause) & u_x <= p 
}


bys id (t) : gen _temp = sum(cause)
bys id (t) : gen trans = cause if _n==1  & cause > 0
bys id (t) : replace trans = cause if _n > 1 & _temp[_n-1] == 0 & _temp > 0

bys id (t) : gen inProg = failureS[_n-1] == 1
bys id (t) : replace inProg = 1 if inProg[_n-1] == 1 
// bys id (t) : gen firstCause = cond(_temp[])


order id t _temp trans inProg cause failure sumH* haz*
br 

// for those in the program
// replace sumHaz = 0 if inProg 
// replace hazS = 0 if inProg
// replace pS   = 0 if inProg
local b1 0 // 0.5
local b2 0 // -0.2


replace haz1 = exp(xb1 + `b1') if inProg
replace haz2 = exp(xb2 + `b2') if inProg
replace sumHaz = haz1 + haz2 if inProg
foreach x in 1 2 {
		replace p`x' = haz`x'/sumHaz if inProg
		replace p = p + p`x'
		 
}


replace F = 1-exp(-sumHaz) if inProg
// Random number has to be lower than prob to give a success
replace failure = u <= F if inProg  
replace cause = cond( u_x <= p1 , 1, 2 ) if inProg & failure
// replace cause = cond( haz1/sumHaz < u_x , 2 , 3 ) if inProg & failure


// identify when there is an exit (Process 1 or 2)
// Throw out observations after there is an exit
gen byte exit = 0
replace exit = inlist(cause,1,2) if !inProg & failure 
replace exit = inlist(cause,1,2) if inProg  & failure
replace trans = cause if inProg & failure
bys id (t) : gen _exit = sum(sum(exit))
replace trans = 0 if missing(trans)

cap drop treated
bys id (t) : egen byte treated = sum(failureS==1 & _exit <= 1)
replace treated = treated > 0


drop if _exit > 1
bys id (t) : gen byte last = _n == _N

order id treated t _exit cause trans inProg cause failure failureS u F u_x p* exit  haz* sumHaz 
br id treated t _exit cause trans inProg cause failure failureS u F u_x p* exit  haz* sumHaz 
// exit

// br id t trans inProg _exit if trans == 1
stset t , failure(_exit) id(id)
sts graph , by(treated)

sts test treated

cap drop treated
bys id (t) : egen treated = sum(_t == 1 & failureS)
 
list id t failureS treated _exit in 1 /10

stset t , failure(_exit) id(id)
sts graph , by(treated)

tabu cause treated if last

exit


/*
* Find time to treatment
* find the first period with a transition code equal to 1
* indicator for those who are treated. Is treated if time to treatment is > 0 
* Replace time to treatment to the last period observed. This observation is considered
* censored 
*/

cap drop timeTo*
bys id (t) : egen    timeToTreatment = sum( t *(trans==1)) 
gen treated = timeToTreatment > 0
bys id (t) : replace timeToTreatment = t[_N] if timeToTreatment == 0 // untreated
bys id (t) : egen timeToProcess1   = sum( t *(trans==2)) 
bys id (t) : egen timeToProcess2   = sum( t *(trans==3)) 
replace trans = 0 if cause == 1
replace cause = 0 if cause == 1
bys id (t) : gen last = _n == _N 
br id t trans treated timeTo* inProg if last

keep if last

// decribe
sum treated
tabu treated
sum timeToTreatment if treated
tabu cause
tabstat t timeToTreatment if treated , by(cause) s(mean count )
tabu cause if !treated


stset t if last , failure(treated) id(id)
streg x , d(exp) nohr // nocons
predict xb, xb

cap drop weight
// gen weight = cond(treated, 1,  exp(xb)/(1-exp(xb)))
gen weight = -expm1(-exp(xb))
count if treated
local N1 `r(N)'
sum weight if !treated
// replace weight = weight*`N1'/`r(sum)' if !treated
tabstat weight if last , s(sum count) by(treated)

mpstest x if last, t(treated) mw(weight) show
 
// replace trans = 0 if treated & trans == 2 & t==5 
cap drop failure 
gen byte failure = inlist(cause,2,3)
stset t if last , failure(failure) id(id)
exit

// sts list , by(treated)

stset t if last , failure(cause==3) id(id)
sts graph , by(treated)

// stcox x
br id t trans cause timeToTreatment failure weight
exit

/*
tabu timeToTreatment if treated
levelsof timeToTreatment if treated
global levels `r(levels)'
foreach x in $levels {
	
	cap drop s
	cap drop touse
	gen touse = timeToTreatment >= `x'
	gen byte s = timeToTreatment == `x' & treated
	cap drop weight
	cap drop rT
	gen rT = t - `x'
	gen weight = cond(s,1,1/exp(xb)) if touse
	stset rT if touse [iw=weight], failure(trans==2) id(id) 
// 	sts graph
	
}
*/


levelsof timeToTreatment if last
foreach x in `r(levels)' {
	
	cap drop d_treat
	gen byte d_treat = timeToTreatment == `x' & treated if last  & timeToTreatment >= `x'
	tabu _t d_treat if last & timeToTreatment >= `x'
	
}


tabu inProg if last

exit


cap drop d_treat
gen byte d_treat = timeToTreatment == 10 & treated if last  & timeToTreatment >= 10

tabu _t d_treat if last  

