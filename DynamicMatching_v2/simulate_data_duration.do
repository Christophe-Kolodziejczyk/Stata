clear 
set obs 10000

set seed 80548115
drawnorm x 
drawnorm u v
gen u1 = runiform()

gen delta = 0.1
gen ln_haz_S = 0.5*x
gen ln_haz_U0 = x  
gen ln_haz_U1 = ln_haz_U0 + delta  
gen e_S  = -ln(-ln(runiform()))
gen e_U0  = -ln(-ln(runiform()))
gen e_U1  = -ln(-ln(runiform()))
gen ts = exp(e_S - ln_haz_S)
gen t_U0 = exp(e_U0 - ln_haz_U0)
gen t_U1 = ts + exp(e_U1 - ln_haz_U1)
gen t_U  = cond(t_U0 <= ts , t_U0, t_U1)

gen d = ts < t_U


sum ts  t_U* d

stset ts , failure(d)
stcox x , nohr


