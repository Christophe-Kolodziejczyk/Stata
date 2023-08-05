mata:
real scalar cBFGS::quadInterpol2(real scalar alo,
                                 real scalar ahi)
{
		real scalar    alpha, d1, d1a, d2, flo, fhi
		real colvector glo, ghi  
		real scalar    dphi_lo, dphi_hi
		

		callf(caller,1,m_b + alo*m_pk,flo,glo=J(m_np,1,.),.) 
		callf(caller,0,m_b + ahi*m_pk,fhi,.,.)
		
		dphi_lo = cross(glo,m_pk)
		
		alpha = dphi_lo*ahi/()
		
		return(alpha)


}



end
