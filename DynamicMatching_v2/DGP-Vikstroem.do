local N 10000
local T 50

clear 
set obs `N'

set seed 80548115

gen id = _n
gen X   = runiform(-1,1)
gen V_S = runiform(-1,1)
gen V_Y = runiform(-1,1)

// Pr(S=t|S>=t, X, Vs) = 1/(1+exp(a_s + b_s *X + c_s * V_s))
// Pr(Y_t = 1 , Y_t-1 = 0 , X , V_Y) = 1/(1+exp(-3.0 + b_Y * X + c_Y * V_Y ))

scalar c_S = 0
scalar c_Y = 0

scalar a_S = 2
scalar b_S = 0
scalar b_Y = 0
scalar gamma = 0


gen indS =   a_S + b_S * X + c_S * V_S
gen indY =  1.0 + b_Y * X + c_Y * V_Y 

gen PrS = 1/(1 + exp(-indS))
gen PrY = 1/(1 + exp(-indY))


expand `T'
bys id : gen t = _n
sort id t

gen uS = runiform()
gen uY = runiform()
bys id (t) : gen treat = sum( sum(uS <= PrS)) 
bys id (t) : gen Y     = sum( sum( uY <= PrY))

replace treat = . if treat  > 1
replace Y     = . if Y > 1  
bys id (t) : egen t_treat = sum( (treat==1)*t)
bys id (t) : egen t_Y     = sum( (Y    ==1)*t)


gen byte inProg = 0 if t <= t_treat & !missing(Y)
replace inProg = 1 if t_Y > t_treat & Y == 0 & t > t_treat

br id t inProg treat Y t_* Pr* 
keep if !missing(Y)
tabu t_Y
bys id (t) : gen last = _n==_N
keep if last

gen treated = t_treat < t_Y
gen failure = Y == 1
gen trans = failure
stset t_Y , failure(failure) id(id)

rename X, lower
gen weight = 1