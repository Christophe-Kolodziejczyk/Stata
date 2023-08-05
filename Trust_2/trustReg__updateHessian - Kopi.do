mata:
real matrix trustReg::updateHessian(real rowvector step, 
                                    real rowvector g1)
{

		real matrix H1
		
		if (m_technique=="dfp")  
		{
				if (m_which=="max") H1 = -invsym(DFP(step,-(g1-m_gradk),-m_invB))
				else H1 = invsym(DFP(step,g1-m_grad,m_invB))
		}
		if (m_technique=="bfgs") H1 = BFGS(step,g1-m_grad,m_B,m_which=="max")

		if (m_technique=="dfp" & det(H1)==0) 
		{
				H1 = m_B0
				m_invB = m_invB0
				m_gradk = J(1,m_k,0)
		}
		
		return(H1)

}


end
