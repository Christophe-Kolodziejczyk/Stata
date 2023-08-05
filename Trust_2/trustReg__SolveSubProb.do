mata:
real rowvector trustReg::solveSubProb()
{
		
		real scalar lambda, minLambda
		real matrix R, H, Q
		real rowvector p0, p1, q, g
		real scalar i, hasConverged
		real colvector eigenVal
		
		if (m_trace>=3) printf("Solving sub-problem\n")
		
		i = 0
		lambda = m_lambda
		
// 		m_k
// 		m_B
// 		lambda
// 		m_grad
//		

		if (m_which=="max") 
		{
				eigenVal = symeigenvalues(-m_B)
				H =  -m_B
				g = -m_grad'
		}
		else 
		{
				eigenVal = symeigenvalues(m_B)
				H = m_B
				g = m_grad'
		}
		
		scalar rc 
		
		rc = computeEigenvect(H)
		
		
		
		if (m_trace>=3) 
		{
				printf("{text}Eigenvalue of B\n")
				mm_matlist(eigenVal,"%g",0)
		}
		
		minLambda = min(eigenVal)
// 		"norm(invsym(H)*g)"
// 		norm(invsym(H)*g)
// 		m_Q[,m_k]'*m_grad'
// 		m_grad
// 		lusolve(H-I(m_k),-g)
// 		exit()
// 		if (m_trace>=3) "solving step"
// 		if (m_which=="max") p1 = lusolve(-m_B + minLambda*I(m_k),-m_grad')
// 		else p1 = lusolve(m_B + minLambda*I(m_k),m_grad')
// 		if (m_trace>=3) 
// 		{
// 				mm_matlist(p1',"%g",0)
// 				norm(p1)
// 		}

		m_isPosDef = minLambda > 0
		
		
	
// 		if (minLambda <= 0) {
		if (rc==0) {
				printf("Hard case\n")
				if (m_which=="max") p1 =computeTau(-m_B,-m_grad)
				else p1 =computeTau(m_B,m_grad)
		}
		else {

				if (m_isPosDef & norm(invsym(H)*g) <  m_Delta) 
				{ 
						
						p1 = lusolve(H,-g)'
						if (m_trace>=3) {
								printf("B pos. definite, step inside region\n")
								printf("norm(step)= %g\n",norm(p1))
						}
// 						norm(-invsym(H)*g)
// 						p1
// 						-(p1*g + 0.5*p1*H*p1')
				}
				else {
						
						if (m_which=="max") p1 = newtonStep(eigenVal,-m_B,-m_grad)
						else p1 = newtonStep(eigenVal,m_B,m_grad)
						if (m_trace >= 3) {
								printf("Compute lambda with Newton method\n")
								printf("norm(step)= %g , delta = %g \n",norm(p1),m_Delta)
						}
				}
		}
		
		if (m_trace>=3) {
				printf("{text}New step found:\n")
				mm_matlist(p1,"%g",0)
				printf("{text}m_Delta      = {res}%g\n",m_Delta)
				printf("{text}Norm of step = {res}%g\n",norm(p1))
		}
// 		exit()
		return(p1)


}
end
