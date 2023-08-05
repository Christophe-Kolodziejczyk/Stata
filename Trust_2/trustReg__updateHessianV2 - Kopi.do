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
		if (m_technique=="bfgs") 
		{
			real scalar     eps
			real scalar     dbdgp, dgHdgp, gPg, bPb
			real colvector  d
			real matrix     db, dg
// 			real matrix     V

			
			dg = g1-m_gradk
			db = step
			m_B
			H1      = invsym(-m_B)
			eps     = 1e-8
// 			db      = S.params - S.oldparams
// 			dg      = S.gradient - S.oldgrad
			dbdgp   = db * dg'
			dgHdgp  = dg * H1 * dg'
			bPb     = db * db'
			gPg     = dg * dg'
			if (abs(dbdgp*dgHdgp) > eps*gPg*bPb) {
					// NOTE: -ml_e0_bfgs- can get slightly different results due
					// to the subtraction
					d = db' / dbdgp - H1*dg' / dgHdgp
					H1 = H1 - db'*db/dbdgp + dgHdgp*d*d' - (H1*dg')*(dg*H1')/dgHdgp
					H1 = (H1 + H1')/2
			}

			H1
			invBFGS(step,dg,invsym(-m_B))
			
			invsym(H1)
			H1 = BFGS(step,dg,m_B)
			H1
			
		}
		
		if (m_technique=="dfp" & det(H1)==0) 
		{
				H1 = m_B0
				m_invB = m_invB0
				m_gradk = J(1,m_k,0)
		}
		
		
		return(H1)

}


end
