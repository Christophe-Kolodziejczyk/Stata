
global root E:\ProjektDB\KORA\Workdata\704752\stcrmixPack
global pado $root\ado
// include "$root\CRSetUp.do"
// di "$pado"

sysdir set PERSONAL $pado
adopath ++ $pado

// cd E:\ProjektDB\KORA\Workdata\704752\trust
cd $root\trust
cap erase $pado\ltrustreg.mlib
do BuildTrustReg.do
mata: mata mlib index

clear mata
mata: mata mlib index
mata: mata describe using ltrustreg



// clear mata
mata: mata set matalnum on
// do E:\ProjektDB\KORA\Workdata\704752\trust\caller.do

mata:

void rosen(todo,p,f,g,H)
{

		real scalar x1, x2
		real scalar g1, g2
		real scalar h11, h21, h22
		
		x1 = p[1]
		x2 = p[2]
		
		f  = 100*(x2-x1^2)^2 + (1-x1)^2
		g1 =-400*(x2-x1^2)*x1-2*(1-x1)
		g2 = 200*(x2-x1^2) 
		
		g = g1,g2
		
		h11 = -400*(x2-3*x1^2)+2
		h22 = 200
		h21 = -400*x1
		H = (h11,h21\h21,h22) // ..
		
// 		H = . // ..

}

void main()
{
		class trustReg scalar S
		real rowvector step
		
		S = trustReg()
		S.pouet()
		
		S.extra
		S.extra.a1
		S.trustInit()
// 		S.constructTrust(1,0.5,10,0.1,4,10000,0,1e-5,1e-6,1e-7)
// 		exit()
		
		
		S.evaluator = &rosen()
		S.m_p = (1,-1)
		S.m_k = cols(S.m_p)
		S.m_lambda = 1
		S.m_Delta = 2
		S.m_Delta_hat = 0
		S.m_eta   = 0.2
		S.m_maxIterSubProb = 4
		
		S.m_trace = 0
		S.m_nrtol = 1e-5
		S.m_ptol  = 1e-6
		S.m_ftol  = 1e-7
		S.m_technique = "bfgs"
		initExtraArgs(S.extra)
		
		S.trustInit()
		S.m_maxIter = 250
		S.m_trace = 1
		S.m_Delta = 0.5
		S.m_Delta_hat = 50
		
		initExtraArgs(S.extra)
		
		//rows(S.extra.a1),cols(S.extra.a1)
		// isEmpty(S.extra.a1)
		countExtraArgs(S.extra)
		
		
		
		
// 		exit()
		S.trustOptimize()
		
		transmorphic po
		
		


}



main()

end

