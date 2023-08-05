mata:
void cBFGS::initCaller()
{

		if (m_extra.nExtraArgs>5)
		{
				_error(3001,"Number of extra arguments greater than 5")
		
		}
		else printf("{text}Number of extra arguments = {res}%g {text}\n",m_extra.nExtraArgs)
		
		m_negate = m_which == "max" 
		
		if (m_extra.nExtraArgs==0) m_caller  = callf_setup(m_evaluator,m_extra.nExtraArgs) // ,a1,a2,a3,a4,a5) 
		else if (m_extra.nExtraArgs==1) m_caller  = callf_setup(m_evaluator,m_extra.nExtraArgs,m_extra.a1) 
		else if (m_extra.nExtraArgs==2) m_caller  = callf_setup(m_evaluator,m_extra.nExtraArgs,m_extra.a1,m_extra.a2) 
		else if (m_extra.nExtraArgs==3) m_caller  = callf_setup(m_evaluator,m_extra.nExtraArgs,m_extra.a1,m_extra.a2,m_extra.a3) 

		

}
end
