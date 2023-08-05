mata:
// modify code for case of maximization instead of minimization 
real rowvector trustReg::computeTau(real matrix B, real rowvector g)
{
		real scalar tau
		real colvector p
		real scalar pz , diff, signPz
		
		m_notConcave = 1
		
		// what about m_k == 1

		if (m_trace>=3) printf("{text}Hard case - Compute tau\n")
		// m_minEv
		p = lusolve(B - m_minEv*I(m_k),-g')
		
		if (norm(p) <= m_Delta)
		{

				diff = m_Delta^2-norm(p)^2
				pz = p'*m_Q[,m_k]
				signPz = (pz == 0 ? 1 : sign(pz))
				tau = diff/(pz+signPz*sqrt(pz^2 + diff))
				
				if (m_trace>=3) 
				{
						printf("Step=\n")
						mm_matlist(p',"%g",0)
						printf("{text}||p|| = {res}%g\n",norm(p))
						printf("pz   = %g \n",pz)
						printf("diff = %g \n",diff)
						printf("tau  = %g \n",tau)
				}

				p = p + tau*m_Q[,m_k]
		}
		if (m_trace>=3) printf("{text}||p|| = {res}%g\n",norm(p))

		return(p')


}
end
