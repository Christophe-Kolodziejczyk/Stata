mata:
void trustReg::trustLoopOptimize(real scalar maxIter)
{
		real scalar iter
		real scalar nrtol, ptol, ftol, f0
		real rowvector step, p0
		
		iter = 1

// 		m_ftol, m_nrtol 
		
		while ( !m_hasConverged & m_iter <= m_maxIter & iter <= maxIter)
		{
				m_notConcave = 0
				p0 = m_p
				f0 = m_f
				if (m_trace>=1) printf(m_lineBreak)
				// if (m_trace > -1) printf("{text}Iteration: {res}%g {text}{col 20}- f(p) = {res}%g{text} {col 45}, norm(gradient) = {res}%g{text}{col 75}, tol = %g \n",m_iter,m_f,norm(m_grad), m_giBg)
				if (m_trace > -1) printIteration(m_iter,m_f,norm(m_grad), m_giBg, m_testFtol, norm(step))
				
// 				if (m_technique != "nr" ) m_todo = 1
// 				else m_todo = 2
				// Solve sub-problem
				step = solveSubProb()
				
				// Run trust Problem
				trustProb(step)
				
				if (m_notConcave) printf("{err}Not concave \n")
				
				real matrix invB

				if (m_which=="max") m_invB = -invsym(-m_B) 
				else m_invB = invsym(m_B)
				
				
				if (m_which=="max") invB = invsym(-m_B)
				else invB = m_invB 
				
				m_giBg = m_grad*invB*m_grad'
				
				if (m_technique == "nr" ) nrtol = m_nrtol 
				else nrtol = m_nrtol
				
// 				m_f, f0
// 				m_p\p0\step
// 				m_trustAction

				m_testFtol = reldif(m_f,f0)
				m_testPtol = mreldif(m_p,p0)
				m_testNrtol = (cols(invB)!=0 & rows(invB)!=0 ? m_giBg : 1)


				if (m_f==.) m_testNrtol = .
				if (m_trace>=1) printCurrentState()
// 				m_testFtol, m_testPtol ,  m_f,f0,m_trustAction
				
// 				m_testNrtol <= nrtol,m_testFtol <= m_ftol, m_testPtol <= m_ptol
				
				m_hasConverged = (m_trustAction >= 0 &
				 m_testNrtol <= nrtol  & ( m_testFtol <= m_ftol | m_testPtol <= m_ptol) )
// 				 abs(det(invB))
// 				if (abs(det(invB))<=0) m_hasConverged = 0
// 				m_hasConverged 
				m_iter++
				iter++
		}
		// if (m_trace > -1) printf("{text}Iteration: {res}%g {text}{col 20}- f(p) = {res}%g{text} {col 45}, norm(gradient) = {res}%g{text}{col 75}, tol = %g \n",m_iter,m_f,norm(m_grad), m_giBg)
		if (m_trace > -1) printIteration(m_iter,m_f,norm(m_grad), m_giBg,m_testFtol,norm(step))
}
void printIteration(real scalar iter,
                    real scalar f,
					real scalar ngrad,
					real scalar giBg,
					real scalar ftol,
					real scalar nstep)
{
		printf("{text}Iteration: {res}%g {text}{col 17}- f(p) = {res}%g{text} {col 40} - grad = {res}%g{text}{col 60} - tol = {res}%g{col 80}{text} - ftol = {res}%g{col 100}{text} - step = {res}%g\n",iter,f,ngrad,giBg,ftol,nstep)
}
end
