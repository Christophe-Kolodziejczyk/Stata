mata:
real scalar cBFGS::cubicInterpol2(real scalar alo,
                                  real scalar ahi)
{

		real scalar    alpha, d1, d1a, d2, flo, fhi
		real colvector glo, ghi  
		real scalar    dphi_lo, dphi_hi
		
// 		"cubicInterpol2()"
		
		callf2(m_caller,1,m_b + alo*m_pk,flo,glo=J(m_np,1,.),.,m_negate) 
		callf2(m_caller,1,m_b + ahi*m_pk,fhi,ghi=J(m_np,1,.),.,m_negate) 
// 		glo 
// 		ghi
		
		dphi_lo = cross(glo,m_pk)
		dphi_hi = cross(ghi,m_pk)
		
// 		alo,ahi
		
		d1  = dphi_lo + dphi_hi-3*(flo-fhi)/(alo-ahi)
		d1a = d1^2-dphi_lo*dphi_hi
		d2  = sign(ahi-alo)*sqrt(d1a)
		
		
		alpha = ahi - (ahi-alo)*(dphi_hi + d2 - d1)/(dphi_hi - dphi_lo + 2*d2)
		
// 		if (alpha == .)
// 		{
// 				if (fhi < flo) alpha = ahi
// 				else alpha = alo
//		
// 		}
		
// 		if (alpha > ahi) 
// 		{
// 			if (fhi <= flo)	alpha = ahi
// 			else            alpha = alo
// 		}
// 		else if (alpha < alo) 
// 		{
// 				if (flo <= fhi) alpha = alo
// 				else            alpha = ahi
//		
// 		}
		
		if (m_trace>=4)
		{
				printf("flo = %g , fhi = %g \n", flo , fhi)
				printf("alo = %g , ahi = %g \n", alo , ahi)
				printf("d1^2-dphi_lo*dphi_hi= %g \n",d1a)
				printf("d1= %g, d2 = %g\n", d1, d2)
				printf("alpha = %g \n", alpha)
		}
		return(alpha)
}

end
