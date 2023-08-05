mata:
void trustReg::new()
{
		extra = J(1,1,extraArgs())
}

void trustReg::constructTrust(real scalar lambda,
                    real scalar Delta,
					real scalar Delta_hat,
					real scalar eta,
					real scalar maxIterSubProb,
					real scalar maxIter,
					real scalar trace,
					real scalar nrtol,
					real scalar ptol,
					real scalar ftol)
{

		m_lambda = lambda
		m_Delta = Delta
		m_Delta_hat = Delta_hat
		m_eta   = eta
		m_maxIterSubProb = maxIterSubProb
		m_maxIter = maxIter
		m_trace = trace
		m_nrtol = nrtol
		m_ptol  = ptol
		m_ftol  = ftol
		m_which = "min"
		
		initExtraArgs(extra)
}



void trustReg::trustInit()
{
		// extra.a1
		constructTrust(1,0.5,10,0.1,4,10000,0,1e-5,1e-6,1e-7)

}



end
