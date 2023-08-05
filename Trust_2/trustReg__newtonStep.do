mata:
real rowvector trustReg::newtonStep(real rowvector eigenVal,
                                    real matrix B,
									real rowvector g)
{

		if (m_trace>=3) printf("{text}Newton step\n")
		real scalar lambda, minLambda
		real matrix R, H, Q
		real rowvector p0, p1, q
		real scalar i, hasConverged
// 		real colvector eigenVal
		
		minLambda = -min(eigenVal)
// 		minLambda
// 		p0 = J(m_k,1,0)
// 		p1 = p0 :+ 1
		
		i = 0
		hasConverged = 0
		lambda = m_lambda // minLambda // m_lambda
// 		lambda
		
		while ( !hasConverged & ++i <= m_maxIterSubProb)
		{
// 		"loop"
// 				p0 = p1
				lambda = max((lambda,minLambda+1))
// 				lambda
				H  = B + lambda*I(m_k)
// 				symeigenvalues(H)
				p1 = cholsolve(H,-g')
				

				R  = cholesky(H)
// 				R
				q  = lusolve(R,p1)
				
				// symeigenvalues(m_B)
				

				lambda = lambda + (norm(p1)/norm(q))^2*((norm(p1)-m_Delta)/m_Delta)
// 				lambda, minLambda

				
				
				if (m_trace>=4) 
				{
						printf("lambda = %g \n",lambda)
						printf("Step = \n")
						mm_matlist(p1',"%g",0)
						norm(p1)
				}
				
				
// 				-(m_grad*p1 + 0.5*p1'*m_B*p1)
				
				if (!hasmissing(p1)) hasConverged = reldif(norm(p1),m_Delta)<0.001

		}
		
	
		if (m_trace>=3) printf("{text}Number of iterations: {res}%g\n",i)
		return(p1')


}
end
