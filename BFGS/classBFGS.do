mata:
struct extraArgs {
		
		// 3 extra arguments, in general I will pass a structure
		// to minimize the # of arguments
		transmorphic a1
		transmorphic a2
		transmorphic a3
		real scalar nExtraArgs

}

class cBFGS {
		
		real scalar    m_todo
		real scalar    m_f , m_np, m_alpha
		real colvector m_b, m_step, m_pk
		real matrix    m_grad, m_oldGrad
		real matrix    m_iH, m_H
		real scalar    m_alo, m_ahi, m_dphi0
		real scalar    m_c1, m_c2
		real scalar    m_vtol, m_ptol, m_nrtol, m_giHg
		
		string scalar m_which 
		real scalar m_negate, m_transpose
		
		real scalar m_maxIter
		real scalar m_hasConverged
		real scalar m_trace	
		real scalar m_rc
		
		pointer scalar m_evaluator
		struct callf_forp scalar m_caller
		struct extraArgs scalar m_extra
		
		real matrix updateInvHessian()
		
		void initCaller()
		void mainLoop()
		void BfgsInit()
		void BfgsInit_arguments()
		void BfgsOptimize()
		real scalar Wolfe()
		real scalar zoom()
		real scalar Phi()
		real scalar quadInterpol()
		real scalar cubicInterpol()
		real scalar cubicInterpol2()
		real scalar linearSearch()
		void BfgsInitWhich()
		void printIteration()
		void callf2()
		
		
		

}
end

