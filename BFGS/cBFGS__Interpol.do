mata:
real scalar cBFGS::Phi(real scalar alpha,
                       real colvector grad)
{
		real scalar f
		real matrix iH
		
		callf(m_caller,1,m_b+alpha*m_pk,f,grad,iH)
		
		return(f)
}

real scalar dPhi(real colvector p,
                 real colvector grad)
{
		return(cross(grad,p))
}

real scalar cBFGS::quadInterpol(real scalar alpha0, 
								real scalar f0)
{
		real scalar phiQ, alpha1
		
// 		"quadInterpol"
		callf(m_caller,0,m_b+alpha0*m_pk,f0=.,.,.)
// 		m_b+alpha0*m_step
// 		f0, m_f, dphi0
		
		alpha1 = 0.5*m_dphi0*(alpha0^2)/(f0-m_f-m_dphi0*alpha0)
			
		return(alpha1)
}

real scalar cBFGS::cubicInterpol(real scalar alpha0,
                                 real scalar alpha1,
                                 real scalar f0, 
								 real scalar f1)
{

		real colvector sol, phi
		real rowvector alpha
		real matrix coeff
		real scalar denom, alpha2

		
// 		"cubic"
		callf(m_caller,0,m_b+alpha1*m_pk,f1=.,.,.)
		
		denom = (alpha0^2)*(alpha1^2)*(alpha1-alpha0)
		phi = (f1\f0)-m_dphi0*(alpha1\alpha0):-m_f
		
// 		"f1,f0"
// 		f1,f0
//		
// 		phi

		coeff = (alpha0^2,-alpha1^2\-alpha0^3,alpha1^3)
		
		sol = coeff*phi/denom
// 		coeff
// 		phi 
// 		denom
// 		"sol"
// 		sol
		real scalar a,b
		a = sol[1]; b= sol[2]
// 		b^2-3*a*m_dphi0
		alpha2 = (-b + sqrt(b^2-3*a*m_dphi0))/(3*a)
		
		return(alpha2)
}

end
