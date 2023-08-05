mata:
void trustReg::trustProb(real rowvector step)
{
		
		scalar rho, f0, f1, m1
		real rowvector p1, p0
		real rowvector g1
		real matrix    H1
		
		if (m_trace>=2) printf("{text}Trust region problem!\n")
		
		f0 = m_f
		p0 = m_p
		p1 = m_p + step 
		// (*evaluator)(p1,m_f,m_grad,m_B)
		
		
// 		S.f_opt_temp = mm_callf(po,S.mu_0)
// 		mm_callf(caller,p1,m_f,m_grad,m_B)
		if (m_trace>=2) 
		{
				printf("{text}Trial parameters:\n")
				mm_matlist(p1,"%g",0)
		}
		passingToCaller(m_todo,p1,f1,g1,H1)
		
// 		if (m_technique=="dfp")  
// 		{
// 				if (m_which=="max") H1 = -invsym(DFP(step,-(g1-m_grad),-m_invB))
// 				else H1 = invsym(DFP(step,g1-m_grad,m_invB))
// 		}
// 		if (m_technique=="bfgs") H1 = BFGS(step,g1-m_grad,m_B)
//
// 		if (m_technique=="dfp" & det(H1)==0) 
// 		{
// 				H1 = m_B0
// 				m_invB = m_invB0
// 		}
		
// 		exit()
		
		// m_grad
// 		if (m_which == "min") {
// 				m1 = - (m_grad*step' + 0.5*step*m_B*step')
// 				rho = (f0-f1)/m1
// 		}
// 		else if (m_which=="max") {
// 				m1 = m_grad*step' + 0.5*step*m_B*step'
// 				rho = (f1-f0)/m1
// 		}

		if (m_which == "min") {
				m1 = - (m_grad*step' + 0.5*step*m_B*step')
				rho = (f0-f1)/m1
		}
		else if (m_which=="max") {
				m1 = m_grad*step' + 0.5*step*m_B*step'
				rho = (f1-f0)/m1
		}
		
		if (m_technique == "bfgs" | m_technique == "dfp") 
		{
				H1 = updateHessian(step,g1)
				
				
		}
		if (m_trace>=2) 
		{
				printf("{text}f0         = {res}%g\n",f0)
				printf("{text}f1         = {res}%g\n",f1)
				printf("{text}f0-f1      = {res}%g\n",f0-f1)
				printf("{text}m1         = {res}%g\n",m1)
				printf("{text}rho        = {res}%g\n",rho)
				printf("{text}norm(step) = {res}%g\n",norm(step))
		}
		
// 		if (rho != .)
// 		{

			if (rho < 0.25)  {
					m_Delta = (0.25)*m_Delta 
					m_trustAction = 1
			}
			else if (rho > 0.75 & reldif(norm(step),m_Delta) < 0.001) {
					m_Delta = min((2*m_Delta,m_Delta_hat))
					m_trustAction = 2
			}			
			else {
					m_Delta = m_Delta
					m_trustAction = 0
			}
			
			if (m_trace>=2) {
					if (m_trustAction==1|m_trustAction==-1) printf("Reducing trust region\n")
					else if (m_trustAction==2) printf("Expanding trust region\n")
					else printf("Trust region unchanged\n")
			}
			if (rho > m_eta ) {
					m_p    = p1
					m_f    = f1
					m_gradk = g1
					m_grad = g1
					m_B    = H1
					m_invB = invsym(m_B)
					m_step = step
					
					
			}
			else {
					m_p = p0
					m_trustAction = -1
					
			}
// 		}
// 		else m_f = .
// 		(*evaluator)(m_p,m_f,m_grad,m_B)
// 		passingToCaller(m_p,m_f,m_grad,m_B)

}
end
