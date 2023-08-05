mata:
void cBFGS::printIteration(real scalar iter) 
{
		if (m_which == "min") printf("{text}Iteration : {res}%g {text}- f(p) = {res}%g {text} - nrtol = {res}%g\n",iter,m_f,m_giHg)
		else printf("{text}Iteration : {res}%g {text}- f(p) = {res}%g {text} - nrtol = {res}%g\n",iter,-m_f,m_giHg)
}

void cBFGS::mainLoop()
{

		real colvector p, step
		real colvector grad
		real matrix iB, B
		real scalar f, alpha
		
		real scalar iter, maxIter
// 		m_negate
// 		m_which
		m_nrtol
		
	
		m_iH = I(m_np)
		m_oldGrad = J(m_np, 1, 0)
		
		m_hasConverged = 0
		iter = 0
		
		printf("/**************************************************/\n")
		
		while (!m_hasConverged & iter <= m_maxIter)
		{
				
				
				
				real colvector y, s
// 				real colvector grad 
		
				if (iter == 0) callf2(m_caller,m_todo,m_b,m_f,m_grad=J(m_np,1,.),.,m_negate)
				m_oldGrad = m_grad 
// 				printf("{text}Iteration : {res}%g {text}- f(p) = {res}%g {text}\n",iter,m_f)
				printIteration(iter)

// 				printf("m_f = %g\n", m_f )
				
				
// 				y = m_grad - m_oldGrad
				
				m_pk = -m_iH*m_grad
				
				if (m_trace>=1)
				{
						printf("Gradient\n")
						mm_matlist(m_grad',"%g",3,"","","Gradient")
						printf("Parameters\n")
						mm_matlist(m_b',"%g",3,"","","parameters")
						printf("m_pk = -iH * g \n")
						mm_matlist(m_pk',"%g",3,"","","p")
						printf("Norm(p) = %g \n",norm(m_pk))
				}
// 				if (iter>=1) return
				
				alpha = linearSearch()
				if (m_trace>=1) printf("alpha = %g\n",alpha)
				if (alpha ==.) 
				{
						m_rc = 1
						break
				
				}
				
				m_step = alpha*m_pk
				
				f = m_f
				p = m_b
				
				
				// m_b = m_b + m_step
				callf2(m_caller,1,m_b+m_step,m_f,m_grad=J(2,1,.),.,m_negate)
				m_b = m_b + m_step
				y = m_grad - m_oldGrad
				
				if (iter == 0) {	
						m_iH = m_iH * cross(y,m_step)/cross(y,y)
				}

				m_iH = updateInvHessian(m_step,y,m_iH)
				if (m_trace>=1)
				{
						printf("new inverse Hessian\n")
						mm_matlist(m_iH,"%g", 3)
				}
				
// 				printf("m_f = %g\n", m_f )
// 				printf("/**************************************************/\n")
				m_giHg = 0.5*m_grad'*m_iH*m_grad
				if ( m_giHg <= m_nrtol & ( reldif(m_f,f) <= m_vtol | mreldif(m_b,p) <= m_ptol )  )
				{
						m_hasConverged = 1
						m_rc = 0
				}
// 				else m_oldGrad = m_grad
				iter++
		
		}
		
// 		m_hasConverged
// 		printf("f(p) = %g\n", m_f )
		printIteration(iter)
		
		printf("Vector of parameters:\n")
		mm_matlist(m_b',"%g",3)
		printf("rc = %g",m_rc)
		// invsym(m_iH)

}
end
