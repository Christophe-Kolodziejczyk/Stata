mata:
// modify code for case of maximization instead of minimization 
real rowvector trustReg::computeTau(real matrix B, real rowvector g)
{
		real matrix X , lambda
		real colvector w
		real matrix Xs
		real scalar tau, delta
		real colvector z
		real colvector p
		real scalar k
		real scalar lambda1
		
		m_notConcave = 1
		
		// what about m_k == 1
		
		if (m_trace>=3) printf("{text}Compute tau\n")
		symeigensystem(B,X,lambda)		
		z = X[,cols(lambda)]

		lambda1 = -lambda[cols(lambda)]
		printf("{text}lambda1 = {res}%g{text}\n",lambda1)
		k = cols(lambda)-1
		w = (lambda[1..k]:+lambda1)'
		Xs  =X[,1..k]'
// 		Xs
// 		w
// 		quadcross(Xs,1:/w,Xs)
		p = -quadcross(Xs,1:/w,Xs)*g' // (Xs'*m_grad':/w)*Xs 
		if (m_trace>=3) 
		{
				printf("{text}p\n")	
				mm_matlist(p',"%g",0)
				printf("{text}||norm(p)|| = {res}%g\n",norm(p))
		}
// 		sum((X[,1..k]'*S.m_grad'):^2:/((lambda[1..k]:-lambda[cols(lambda)]):^2))
	

		real scalar normPsq 
		normPsq = quadsum(((Xs*g'):^2):/(w:^2))
		if (m_trace>=3) printf("{text}normP   = {res}%g\n",sqrt(normPsq))
		m_Delta:^2-norm(p):^2
		tau = sqrt(m_Delta:^2-norm(p):^2)
		if (m_trace>=3) printf("{text}tau     = {res}%g\n",tau)
		if (m_trace>=3) printf("{text}m_Delta = {res}%g\n",m_Delta)

		p = p + tau*z
		if (m_trace>=3) printf("{text}||norm(p)|| = {res}%g\n",norm(p))
		
		return(p')


}
end
