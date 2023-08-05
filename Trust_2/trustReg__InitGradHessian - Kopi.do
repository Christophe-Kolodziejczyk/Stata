mata:
void trustReg::initGradHessian()
{
		passingToCaller(m_todo,m_p,m_f,m_grad,m_B)
		if (m_technique=="dfp") 
		{
				m_todo = 1
				m_gradk = J(1,m_k,0)
				m_B    = I(m_k)
				m_invB = I(m_k)
				if (m_which=="max") {
						_negate(m_invB)
						_negate(m_B)
						
				}
				m_invB0 = m_invB
				m_B0    = m_B
				
		}
		if (m_technique=="bfgs") 
		{
				m_todo = 1
				m_gradk = J(1,m_k,0)
// 				m_step
// 				m_grad*m_grad'
// 				m_grad*m_step'
				m_B= I(m_k) //*((m_grad*m_grad')/(m_grad*m_step'))
				if (m_which=="max") _negate(m_B)
		}
		else m_todo = 2

		if (m_trace>=1) 
		{
				printf("Starting values\n")
				printCurrentState()
		}
		
		m_hasConverged = 0



}


end
