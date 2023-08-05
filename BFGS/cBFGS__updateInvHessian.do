mata:
real matrix cBFGS::updateInvHessian(s,y,iB)
{
		real matrix updiB, I, IrhosPy
		real scalar rho
		// B
		rho = 1/cross(y,s)
		if (m_trace>=1) printf("rho = %g\n",rho)
		
// 		if (!m_negate & rho < 0) return(iB) 
// 		else if (m_negate & rho> 0) return(iB)
		if (rho <= 0) return(iB) 
	    I = I(m_np)


		IrhosPy = I-rho*s*y'
// 		iB
// 		if (m_negate) updiB = (IrhosPy)*iB*(IrhosPy)' - rho*s*s'
// 		else 
		updiB = (IrhosPy)*iB*(IrhosPy)' + rho*s*s'
// 		updiB
		// (B*s'*s*B):/(s*B*s')+ (y'*y):/(y*s')
// 		updiB = (updiB + updiB')/2
		
		_makesymmetric(updiB)

		return(updiB)

}
end
