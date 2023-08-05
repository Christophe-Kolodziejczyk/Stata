mata:
void cBFGS::BfgsInit_arguments(real scalar n, Arg)
{
		
		m_extra.nExtraArgs = max((m_extra.nExtraArgs,n))
		
		
		if (n==1) m_extra.a1 = Arg
		else if (n==2) m_extra.a2 = Arg
		else if (n==3) m_extra.a3 = Arg
		
		// update caller
		// m_caller  = callf_setup(m_evaluator,m_extra.nExtraArgs)
		initCaller()
		

}
end
