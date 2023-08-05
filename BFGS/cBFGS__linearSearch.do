mata:
real scalar cBFGS::linearSearch()
{
		
		real scalar alpha0, alpha1, alpha, f0, iter, dphi
		real scalar f1
		real colvector g1 
		real scalar stop
		real scalar alphaMax
		
		if (m_trace>=2) printf("Begin linear search\n")
		m_dphi0 = cross(m_grad,m_pk)
		if (m_trace>=2) printf("m_dphi0 = %g \n",m_dphi0)
		
		alphaMax = 10
		iter = 0
		stop = 0
		f0 = m_f
		
		alpha0 = 0
		alpha1 = 1
		
		g1 = J(m_np,1,.)
		
		while (!stop) 
		{
				if (m_trace>=2) printf("iteration = %g\n",++iter)
				if (m_trace>=2) printf("alpha0 = %g , alpha1= %g \n", alpha0, alpha1 )
				callf2(m_caller,0,m_b+alpha1*m_pk,f1,.,.,m_negate)
				
// 				printf("reldif(alpha1,alpha0) = %g\n",reldif(alpha1,alpha0))
// 				if (reldif(alpha1,alpha0)<= 1e-8) return(alpha1)
				
				if (f1 == .) alpha1 = alpha1/2
				else {
						if (m_trace>=2) printf("reldif(f1,f0) = %g \n", reldif(f1,f0))
						if (f1 > m_f + m_c1*alpha1*m_dphi0 | f1 > f0 )
						{
// 						"1."
								// if (reldif(alpha1,alpha0) > 1e-8) 
								alpha = zoom(alpha0,alpha1)
								alpha1 = (alpha !=. ? alpha : alpha1/2 )
		// 						printf("alpha0 = %g , alpha1= %g \n", alpha0, alpha1 )
		// 						"End zoom"
// 								return(alpha1)
						}
						
						callf2(m_caller,1,m_b+alpha1*m_pk,f1,g1,.,m_negate)
						dphi = cross(g1,m_pk)
						if (abs(dphi) <= -m_c2*m_dphi0)
						{
		// 				"2."
								m_f = f1
								if (m_trace>=2) printf("end of line search, alpha = %g , f= %g \n", alpha1, m_f)
								
								return(alpha1)
						}
						
						if (dphi >= 0)
						{
		// 				"3."
								alpha = zoom(alpha1,alpha0)
		// 						"End zoom"
								if (alpha !=.) return(alpha)
						}
						
		// 				 return(.)
		// 				"4."
						
		// 				alpha1 = min((2*alpha1,alphaMax))
						
		// 				alpha = cubicInterpol2(2*alpha1-alpha0,alpha1+9*(alpha1-alpha0))
						alpha = cubicInterpol2(alpha0,alpha1)
		// 				"alpha"
		// 				alpha
						alpha0 = alpha1
						alpha1 = ( alpha != . ? alpha : alphaMax) 
						if (m_trace>=2) printf("alpha0 = %g , alpha1= %g \n", alpha0, alpha1 )
		// 				if (alpha1==.) exit()
						f0 = f1
						
				}
// 				if (iter>=5) return(alpha1)
		}
		
		
		return(alpha1)



}

end
