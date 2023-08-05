mata:
real scalar trustReg::computeEigenvect(real matrix B)
{
		real scalar k, lambda1
		real scalar rc, scalarProd
		
		if (m_trace>=3) {
				printf("B\n")
				mm_matlist(B,"%g",0)
		}
		symeigensystem(B,m_Q,m_Ev)
		
		k = cols(m_Ev)
		m_minEv = m_Ev[k]
		lambda1 = -m_minEv
		
		if (m_trace>=3) 
		{
				printf("# of eigenvalues = %g\n",k)
				mm_matlist(m_Ev,"%g",0)
// 				mm_matlist(m_Q[,k],"%g",0)
		}
		scalarProd = m_Q[,k]'*m_grad'
		
// 		if (m_trace>=3) {
// 				m_B + lambda1*I(k)
// 		}

		if (scalarProd==0)
		{
				real rowvector p
				
				if (m_which == "min") p = lusolve(B-lambda1*I(m_k),-m_grad')
				else p = lusolve(B-lambda1*I(m_k),m_grad')
				
				if (m_trace>=2)
				{
						printf("p_lambda1=\n")
						mm_matlist(p',"%g",0)
						printf("||p_lambda1|| = %g\n",norm(p))
				}
				
				scalarProd = (norm(p)>=m_Delta) 
				
		}
		
		rc = scalarProd != 0 
		return(rc)
}



end
