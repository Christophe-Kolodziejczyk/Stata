mata:
real rowvector trustReg::newtonStep(real rowvector eigenVal,
                                    real matrix B,
									real rowvector g)
{

		if (m_trace>=3) printf("{text}Newton step\n")
		real scalar lambda, minLambda, lambdaL, lambdaU, lambdaS, normG, normB
		real matrix R, H, Q
		real rowvector p0, p1, q
		real scalar i, hasConverged, minEv
		real colvector t_Ev
		
		minLambda = -min(eigenVal)
// 		minLambda
// 		p0 = J(m_k,1,0)
// 		p1 = p0 :+ 1
		
		i = 0
		hasConverged = 0
		lambda = m_lambda // minLambda // m_lambda
		lambdaS = max(-diagonal(B))
		normG = norm(g)
		normB = norm(B,1)
		lambdaU = normG/m_Delta + normB
		lambdaL = max( (0,lambdaS,normG/m_Delta - normB) )
		
		lambda = max((lambda,minLambda+10))
		
		if (m_trace>=4) printf("LambdaS = %g, lambdaL = %g, LambdaU = %g , minLambda= %g \n",lambdaS, lambdaL, lambdaU,minLambda)

		
		while ( !hasConverged & ++i <= m_maxIterSubProb)
		{		
				// Safeguard lambda
				lambda = max( (lambda,lambdaL) )
				lambda = min( (lambda,lambdaU) )
				if (lambda<= lambdaS) lambda = max( (0.001*lambdaU,sqrt(lambdaL*lambdaU)) )

				H  = B + lambda*I(m_k)
				minEv = min( symeigenvalues(H) )
				if (minEv>0)
				{
						p1 = cholsolve(H,-g')
						R  = cholesky(H)
						q  = lusolve(R,p1)
						

						lambda = lambda + (norm(p1)/norm(q))^2*((norm(p1)-m_Delta)/m_Delta)
						if (m_trace>=4) printf("LambdaS = %g, lambdaL = %g, LambdaU = %g , minLambda= %g \n",lambdaS, lambdaL, lambdaU,minLambda)

				}
				
// 				lambda, minLambda
// 				printf("Lambda= %g\n",lambda)

				// Update lamdbaL, lambdaU, lambdaS
				if (lambda >= minLambda) lambdaU = min( (lambdaU,lambda) )
				else lambdaL = max( (lambdaL,lambda))
				if (m_trace>=4)  printf("||R'zhat||^2=%g\n",norm(R'*m_Q[,m_k])^2)
				// norm(m_Q[,m_k])
				lambdaS = max( (lambdaS,lambda-norm(R'*m_Q[,m_k])^2) )
				lambdaL = max((lambdaS,lambdaL))
				if (minEv <= 0) lambda = lambdaS
				
				if (m_trace>=4) 
				{
						printf("lambda = %g \n",lambda)
						printf("Step = \n")
						mm_matlist(p1',"%g",0)
						norm(p1)
						printf("LambdaS = %g, lambdaL = %g, LambdaU = %g , minLambda= %g \n",lambdaS, lambdaL, lambdaU,minLambda)
				}
				
				
// 				-(m_grad*p1 + 0.5*p1'*m_B*p1)
				
				if (!hasmissing(p1)) hasConverged = reldif(norm(p1),m_Delta)<0.001

		}
		
	
		if (m_trace>=3) printf("{text}Number of iterations: {res}%g\n",i)
		return(p1')


}
end
