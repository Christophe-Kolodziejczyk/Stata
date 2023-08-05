mata:
void cBFGS::BfgsInit(real colvector b0,
                     pointer(function) scalar evaluator)
{
		
		m_c1 = 1e-4 ; m_c2 = 0.9 
		m_maxIter = 100
		m_trace = 0
		m_todo = 1
		m_ptol = 1e-6
		m_vtol = 1e-7
		m_nrtol = 1e-5
		
		m_b = b0
		m_np = rows(m_b)
		m_evaluator = evaluator
		m_transpose = 0
		
		// m_caller  = callf_setup(m_evaluator,0)
		
		
		m_extra.nExtraArgs = 0
		initCaller()
		BfgsInitWhich("min")
		
		m_extra.a1 = J(0,0,.)
		m_extra.a2 = J(0,0,.)
		m_extra.a3 = J(0,0,.)


}


end
