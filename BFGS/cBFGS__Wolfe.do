mata:
real scalar cBFGS::Wolfe(real scalar alphaMax)
{
		real colvector p
		real scalar alpha0, alpha1, alpha2, alpha, f
		real scalar iter, stop
		real matrix grad, iH
		real scalar c1, c2
		
		real scalar phi, phi0, dphi0, dphi
		
		alpha0 = 1 ; iter = 0
		alpha1 = 1
		stop = 0
		c1 = 1e-4 ; c2 = 0.9 
		m_dphi0 = cross(m_grad,m_pk)
		printf("m_dphi0 = %g \n",m_dphi0)
// 		"dphi0"
// 		dphi0
		
		grad = J(2,1,.)
		phi = .
		while (!stop) {
			real scalar f0, f1
			
			p = m_b + alpha0*m_pk
			callf(m_caller,0,p,f0,.,.)
			
			zoom(0,10)
			
			alpha1 = quadInterpol(1,f0=.)
			alpha2 = cubicInterpol(alpha0,alpha1,f0,f1=.) 
			callf(m_caller,1,m_b+alpha2*m_pk,f=.,grad,.)
// 			f
			printf("alpha1 = %g \n",alpha1)
			printf("alpha2 = %g \n",alpha2)
// 			"m_f,phi"
// 			m_f,f 
// 			"grad"
// 			grad
			dphi = cross(grad,m_pk)
			phi0 = m_f + c1*alpha2*m_dphi0
// 			if (f < phi0) stop = 1
			if (iter <= 2) stop = 1
			iter++
			if (abs(dphi)<abs(c2*dphi0)) stop = 1
// 			"Møf"
		}
		
		alpha = alpha2
		return(alpha)
		



}



end
