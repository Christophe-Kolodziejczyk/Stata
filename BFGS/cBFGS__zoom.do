mata:
real scalar cBFGS::zoom(real scalar alo0,
                        real scalar ahi0)
{

		real scalar alpha0, alpha1, alpha2, flo, f1, f0, alo, ahi
		real scalar stop, iter, dphi
		real colvector g1 , glo
		real scalar t2, t3
		real scalar a, b
		
		g1 = glo = J(m_np,1,.)
		alo = alo0 ; ahi = ahi0
		
// 		t2 = 0.1 ; t3= 0.5
		t2 = 0 ; t3 = 0
		if (m_trace>=3) printf("Calling Zoom()\n")
		
// 		alpha0 = ahi
// 		ahi = quadInterpol(alpha0,f0=.)
// 		alpha0,ahi
		
		stop = 0
		iter = 0
		while (!stop) {
// 				"Zoom() loop"
				a = alo + t2*(ahi-alo); b= ahi-t3*(ahi-alo)
// 				printf("reldif(a,b) = %g\n",reldif(alpha1,alpha0))
// 				if (reldif(a,b)<= 1e-5) return(alpha1)
				
				++iter
				if (m_trace>=3) {
						printf("iter = %g\n",iter)
						printf("alo = %g , ahi = %g \n",alo, ahi)
						printf("a = %g , b = %g \n", a, b)
				}
				if (alo ==.  | ahi == .) return(.)
				alpha1 = cubicInterpol2(a,b)
// 				alpha1 = a + runiform(1,1)*(b-a)
				 
				callf2(m_caller,1,m_b + alpha1*m_pk,f1,g1,.,m_negate)
				callf2(m_caller,1,m_b + alo*m_pk,flo,glo,.,m_negate)
				
				if (m_trace>=3) {
						printf("alpha1 = %g\n",alpha1)
						printf("f1 = %g , flo = %g \n",f1 , flo)
				}
				if (f1 > m_f + m_c1*alpha1*m_dphi0 | f1 > flo  )
				{
// 				"1."
// 						f1,flo
// 						ahi = alpha1 // 
						ahi = (alpha1 == . ? ahi*2 : alpha1)
						alo = 0
			
				}
				else 
				{
// 				"2."
						dphi = cross(g1,m_pk)
						if (m_trace>=3) printf("dphi = %g , -m_c2*m_dphi0 = %g \n ",dphi,-m_c2*m_dphi0)
						if ( abs(dphi) <= -m_c2*m_dphi0 ) return(alpha1)
// 						if ( cross(dphi,m_pk)*(ahi-alo) >=0 ) 
                        if ( dphi*(ahi-alo) >=0 )
						{
// 						"2a."
								ahi = alo
						}
						alo = alpha1
						
				
				}
// 				if (alo > ahi | ahi == .) stop = 1
// 				alo,ahi
// 				if (alo > ahi ) swap(alo,ahi)
// 				if (iter >= 10) stop = 1
				
				
				
		}
		
		if (m_trace>=3) printf("End zoom() - alpha1 = %g \n",alpha1)
// 		printf("alpha2 = %g \n",alpha2)

		
		return(alpha1)

}


end
