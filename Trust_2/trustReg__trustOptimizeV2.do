mata:
void trustReg::trustOptimize()
{
		real scalar iter, maxIter, hasConverged
		
		
		
		transmorphic a1, a2, a3, a4, a5
		
// 		if (extra.nExtraArgs==0) caller  = callf_setup(evaluator,extra.nExtraArgs) // ,a1,a2,a3,a4,a5) 
// 		else if (extra.nExtraArgs==1) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1,a2,a3,a4,a5) 

		printf("{text}{col 15}Nonlinear optimization with trust region algorithm\n")
		printf("{res}{hline 80}\n\n")
		
// 		printf("{text}by Christophe Kolodziejczyk (c) 2017 :-)\n")
// 		printf("This program is dedicated to Pusling\n\n")
		
		// counting # of extra arguments of evaluator
		// passed when initiating algorithm
		countExtraArgs(extra)
		
		printf("{text}Technique : {res}%s{text}\n",m_technique)
		printf("{text}# of extra arguments = {res}%g {text}\n",extra.nExtraArgs)
		
		initCaller()
		
		m_lineBreak = "\n{res}{hline 80}\n"
		m_iter = 0
		m_f = m_grad = m_B = .
		m_k = cols(m_p)
		
		if (mod(cols(tokens(m_technique)),2)!=0) m_techniqueSeq = colshape((tokens(m_technique)," "),2)
		else m_techniqueSeq = colshape(tokens(m_technique),2)
		
		m_tech    = m_techniqueSeq[,1]
		m_techIter= strtoreal(m_techniqueSeq[,2])
		
		m_technique = m_tech[1]
		initGradHessian()
		
		printf(m_lineBreak)
		
		real scalar j
		
		j = 1
		while (!m_hasConverged & m_iter <= m_maxIter)
		{
				
				
				m_technique = m_tech[j]
				iter = m_techIter[j]
				
				printf("{text}Switching to {res}%s{text}\n",m_technique)
				if (m_technique=="nr") m_todo = 2
				else m_todo = 1
				
				trustLoopOptimize(iter)
				
				if (j==rows(m_techniqueSeq)) j = 1
				else j++
		}
		
		if (m_hasConverged) printf("{res}Model has converged{text}\n")
		printf(m_lineBreak)
		displayResults()


}
end
