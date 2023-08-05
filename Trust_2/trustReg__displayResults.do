mata:

void trustReg::displayResults()
{
// 	"version 1.0"
// 	pouet()
		if (m_hasConverged) {	
				
				printf("{text}Optimization achieved after {res}%g {text}iterations \n",m_iter)
				printf("{text}Value at the optimum = {res}%g\n",m_f)
				printf("{text}Vector of parameters\n")
				mm_matlist(m_p,"%g",0)
		}
		else {
				printf("{text}Convergence not achieved after {res}%g {text}iterations\n",m_iter)
		
		}


}


end
