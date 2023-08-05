mata:

void trustReg::printCurrentState()
{
		printf("\n**************************\n")
		printf("{text}Delta     = {res}%g\n",m_Delta)
		printf("{text}Eta       = {res}%g\n",m_eta)
		printf("{text}Delta max = {res}%g\n",m_Delta_hat)
		
		printf("\n**************************\n")
		printf("{text}Value function = {res}%g\n",m_f)
		printf("{text}Current vector :\n")
		mm_matlist(m_p,"%g",0)
		printf("{text}Norm of gradient = {res}%g \n", norm(m_grad))
		printf("{text}Current gradient:\n")
		mm_matlist(m_grad,"%g",0)
		printf("{text}Current hessian:\n")
		mm_matlist(m_B,"%g",0)
		
		printf("{text}ptol = {res}%g {text}, ftol = {res}%g {text}, nrtol = {res}%g\n",m_testPtol,m_testFtol,m_testNrtol)


}


end
