global root P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\statprog\stcrmix-pack-src-all\trust 
// E:\ProjektDB\KORA\Workdata\704752\stcrmix
global pado $root\ado
// include "$root\CRSetUp.do"
// di "$pado"

cd $root
run BuildTrustReg.do

sysdir set PERSONAL $pado\
mata mata mlib index

clear mata
clear
set seed 1010
set obs 10000
drawnorm x
gen draw = runiform()
gen p = invlogit(1+x)
gen y = p>draw

sum 

logit y x


// replace price = price/100
// replace weight = weight/1000
mata:

struct linear {
		
		real colvector y
		real matrix    X
		real scalar    k

}


void evalLogit(todo,p,struct linear l, f, g, H)
{
		real scalar    ls, s
		real colvector d, xb,OnepExb, pr, b
		real matrix grad
		
		b  = p[1..l.k]'
		
		xb = l.X*b
		d = 1:-l.y
		OnepExb = 1:+exp(xb)
		pr = invlogit(xb)
		f = -sum( l.y:*(xb:-log(OnepExb))+ d:*(-log(OnepExb)) ,1)
		grad = (l.y:*(1:-pr) :+ d:*(-pr) ):*l.X
		
		g = -colsum(grad,1)
		
		if (todo==2)
		{
				H = cross(l.X,pr:*(1:-pr),l.X)
				_makesymmetric(H)
		}
		// DFP(g,H,f)
		

}


void test()
{
		class trustReg scalar S
		struct linear scalar l
		real rowvector step
		
		l.y = st_data(.,"y")
		l.X = st_data(.,"x"),J(rows(l.y),1,1)
		l.k = cols(l.X)
		
		
		S = trustReg()
		S.trustInit()
		
		S.evaluator = &evalLogit()
		S.m_p = (0,0)
		S.m_todo = 2
		S.m_technique = "nr"
		
// 		S.m_k = cols(S.m_p)
// 		S.m_lambda = 1
		S.m_Delta = 0.1
		S.m_Delta_hat = 100
// 		S.m_eta   = 0.2
		S.m_maxIterSubProb = 5
		S.m_maxIter = 300
// 		S.m_nrtol = 1e-5
// 		S.m_ptol  = 1e-6
// 		S.m_ftol  = 1e-7
// 		S.m_tol = 1e-4
		S.m_trace = 0

		
		S.extra.a1 = J(1,1,l)
		S.trustOptimize()	
		
		
		
		


}

void testOptim()
{
		transmorphic S
		struct linear scalar l
		real rowvector p
		
		l.y = st_data(.,"y")
		l.X = st_data(.,"x"),J(rows(l.y),1,1)
		l.k = cols(l.X)
		
		S = optimize_init()
		optimize_init_which(S,"min")
		optimize_init_evaluator(S,&evalLogit())
		optimize_init_evaluatortype(S,"d2")
		optimize_init_technique(S,"nr")
		optimize_init_argument(S,1,l)
		optimize_init_params(S,(0,0))
		optimize_init_trace_gradient(S,"on")
		optimize_init_trace_Hessian(S,"on")
		optimize_init_conv_maxiter(S,100)
		
		p = optimize(S)
		p


}

test()
testOptim()

end

exit
reg price weight
