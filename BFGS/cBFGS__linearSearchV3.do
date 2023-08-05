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
		
		alphaMax = 1000
		iter = 0
		stop = 0
		f0 = m_f
		
		alpha0 = 0
		alpha1 = 1
		
		g1 = J(m_np,1,.)
		callf2(m_caller,1,m_b+alpha1*m_pk,f1,g1,.,m_negate)
		if (f1==.) alpha1 = 1/norm(m_grad)
		
		while (!stop) 
		{
				if (m_trace>=2) printf("Linear search iteration = %g\n",++iter)
				if (m_trace>=2) printf("alpha0 = %g , alpha1= %g \n", alpha0, alpha1 )
				
				if (m_trace>=2) printf("(LS) \n")
				callf2(m_caller,0,m_b+alpha1*m_pk,f1,.,.,m_negate)
				callf2(m_caller,0,m_b+alpha0*m_pk,f0,.,.,m_negate)
				
// 				printf("reldif(alpha1,alpha0) = %g\n",reldif(alpha1,alpha0))
// 				if (reldif(alpha1,alpha0)<= 1e-8) return(alpha1)

				
				if (f1 == .) alpha1 = alpha1/2
				else {
						if (m_trace>=2) printf("reldif(f1,f0) = %g \n", reldif(f1,f0))
						if (f1 > m_f + m_c1*alpha1*m_dphi0 | f1 > f0 )
						{
						if (m_trace>=2) printf("No sufficient decrease")
								if (m_trace>=2) "1."
								// if (reldif(alpha1,alpha0) > 1e-8) 
								alpha = zoom(alpha0,alpha1)
// 								alpha1 = (alpha !=. ? alpha : alpha1/ )
								if (alpha == .) 
								{
										alpha0 = 0
										alpha1 = 1/norm(m_grad)
// 										continue
										
								}
								else alpha1 = alpha
								if (m_trace>=2) printf("alpha = %g , alpha1 = %g\n", alpha, alpha1)
								
// 								callf2(m_caller,1,m_b+alpha1*m_pk,f1,g1,.,m_negate)

						}
						else {
								if (m_trace>=2) printf("Sufficient decrease \n")
								dphi = cross(g1,m_pk)
								if (abs(dphi) <= -m_c2*m_dphi0)
								{

										if (m_trace>=2) printf("2. sufficient curvature \n")
										m_f = f1
										// if (m_trace>=2) 
										if (m_trace>=2) printf("End of (LS) - alpha = %g , f= %g \n", alpha1, m_f)
										
										return(alpha1)
								}
								
								else if (dphi >= 0)
								{

										if (m_trace>=2) printf("3. phi'(alpha)>=0\n")
										alpha = zoom(alpha1,alpha0)
										if (m_trace>=2)  printf("alpha = %g \n", alpha)
				// 						"End zoom"
										if (alpha !=.) return(alpha)
								}
								else if (m_trace>=2) printf("Insufficient curvature\n")
						}

// 						alpha = cubicInterpol2(alpha0,alpha1)
						if (m_trace>=2)  printf("Update alpha \n")
						if (alpha !=.)
						{
								alpha0 = alpha1
								alpha1 = alpha
								// alpha1 = ( alpha != . ? alpha : alphaMax) 
						}
						else 
						{
						    if (m_trace>=2)  printf("alpha missing\n")
							alpha1 = 2*alpha1
						}
						if (reldif(alpha0,alpha1) < 1e-4) stop = 1
						
						if (m_trace>=2) printf("(LS) alpha0 = %g , alpha1= %g \n", alpha0, alpha1 )
						f0 = f1
						
				}
// 				if (iter>=5) return(alpha1)
		}
		
		
		return(alpha1)



}

end
