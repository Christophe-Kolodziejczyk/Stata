mata:
void trustReg::trustOptimize()
{
		real scalar iter, maxIter, hasConverged
		real scalar nrtol, ptol, ftol, f0
		real rowvector step, p0
		string scalar lineBreak
		
		transmorphic a1, a2, a3, a4, a5
		
// 		if (extra.nExtraArgs==0) caller  = callf_setup(evaluator,extra.nExtraArgs) // ,a1,a2,a3,a4,a5) 
// 		else if (extra.nExtraArgs==1) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1,a2,a3,a4,a5) 

		printf("{text}{col 15}Nonlinear optimization with trust region algorithm\n")
		printf("{res}{hline 80}\n\n")
		
// 		printf("{text}by Christophe Kolodziejczyk (c) 2017 :-)\n")
// 		printf("This program is dedicated to Pusling\n\n")
		
		// counting # of extra arguments of evaluator
		// passed when initiating algorithm
		countExtraArgs(extra)
		
		printf("{text}Technique : {res}%s{text}\n",m_technique)
		printf("{text}# of extra arguments = {res}%g {text}\n\n",extra.nExtraArgs)
		
		initCaller()
		
		lineBreak = "\n{res}{hline 80}\n"
		iter = 0
		m_f = m_grad = m_B = .
		m_k = cols(m_p)

		passingToCaller(m_todo,m_p,m_f,m_grad,m_B)
		if (m_technique=="dfp") 
		{
				m_todo = 1
				m_grad = J(1,m_k,0)
				m_B    = I(m_k)
				m_invB = I(m_k)
				if (m_which=="max") {
						_negate(m_invB)
						_negate(m_B)
						
				}
				m_invB0 = m_invB
				m_B0    = m_B
				
		}
		if (m_technique=="bfgs") 
		{
				m_todo = 1
				m_grad = J(1,m_k,0)
				m_B= I(m_k)
				if (m_which=="max") _negate(m_B)
		}

		if (m_trace>=1) 
		{
				printf("Starting values\n")
				printCurrentState()
		}
		
		hasConverged = 0
		while ( !hasConverged & ++iter<=m_maxIter)
		{
				m_notConcave = 0
				p0 = m_p
				f0 = m_f
				if (m_trace>=1) printf(lineBreak)
				printf("{text}Iteration: {res}%g {text}- f(p) = {res}%g{text}\n",iter,m_f)
				// printf("{text}f(p) = {res}%g\n",m_f)
				
// 				if (m_which=="max") {
// 						_negate(m_grad)
// 						_negate(m_B)
// 				}
				

				
				
// 				else m_invB= invsym(m_B)

				step = solveSubProb()
				trustProb(step)
				
				if (m_notConcave) printf("{err}Not concave \n")
				real matrix invB
				
				if (m_which=="max") m_invB = -invsym(-m_B) 
				else m_invB = invsym(m_B)
				
				
				if (m_which=="max") invB = invsym(-m_B)
				else invB = m_invB 
		// 		S.m_p
		// 		S.m_Delta
// 				real matrix invB
				

				m_testFtol = reldif(m_f,f0)
				m_testPtol = mreldif(m_p,p0)
				m_testNrtol = m_grad*invB*m_grad'

				if (m_trace>=1) printCurrentState()
				
// 				invB
// 				m_B
// 				invsym(m_B)
				
				hasConverged = (m_testNrtol <= m_nrtol  & (m_testFtol <= m_ftol | m_testPtol <= m_ptol) )
				if (abs(det(invB))<=0) hasConverged = 0
		}
		
		printf(lineBreak)
		if (hasConverged) {	
				
				printf("{text}Optimization achieved after {res}%g {text}iterations \n",--iter)
				printf("{text}Value at the optimum = {res}%g\n",m_f)
				printf("{text}Vector of parameters\n")
				mm_matlist(m_p,"%g",0)
		}
		else {
				printf("{text}Convergence not achieved after {res}%g {text}iterations\n",--iter)
		
		}


}
end
