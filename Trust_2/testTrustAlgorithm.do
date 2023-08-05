global root E:\ProjektDB\KORA\Workdata\704752\stcrmix
global pado $root\ado
// include "$root\CRSetUp.do"
// di "$pado"

sysdir set PERSONAL $pado\
mata mata mlib index

clear mata
sysuse auto, clear
// replace price = price/100
// replace weight = weight/1000
mata:

struct linear {
		
		real colvector y
		real matrix    X
		real scalar    k

}

void evalLogit(todo,p,struct linear, f, g, H)
{
		real scalar    ls, s
		real colvector d, xb,OnepExb, p
		
		b  = p[1..l.k]'
		
		xb = l.X*b
		d = 1:-l.y
		OnepExb = 1:+exp(xb)
		p = invlogit(xb)
		f = -sum( d:*(xb:-log(OnepExb))+ l.y:*(-log(OnepExb) ),1)
		grad = (d:*(1:-p) :+ l.y*(-p)):*l.X
		
		g = -colsum(grad,1)
		
		H = cross(l.X,p:*(1:-p),l.X)
		

}

void evalLinear(todo,p,struct linear scalar l, f , g, H)
{

		real colvector u
		real colvector b
		real matrix grad
		
		real scalar    ls, s
		b  = p[1..l.k]'
		ls = p[l.k+1] 
		s = exp(ls)
		u = (l.y-l.X*b)/s
		
		f = sum(0.5*u:^2 :+ ls,1)
		
		grad = -(u/s):*l.X,(-u:^2:+1)
		
		g = colsum(grad,1)
// 		g
		H = cross(grad,grad)
		H[1..l.k,1..l.k] = cross(l.X,l.X)/(s^2)
		H[l.k+1,l.k+1]   = 2*cross(u,u)
		H[l.k+1,1..l.k]  = 2*cross(u,l.X)/s
		_makesymmetric(H)

}

void evalLinear2(todo,p,struct linear scalar l, f , g, H)
{

		real colvector u
		real colvector b
		real matrix grad
		
		real scalar    ls, s
		b  = p[1..l.k]'
		ls = p[l.k+1] 
		s = exp(ls)
		u = (l.y-l.X*b)/s
		
		f = sum(0.5*u:^2 :+ ls,1)
		
		
		grad = -(u/s):*l.X,( -u:^2:+1)
		
		g = colsum(grad,1)
		H = cross(grad,grad)
		H[1..l.k,1..l.k] = cross(l.X,l.X)/(s^2)
		H[l.k+1,l.k+1]   = 2*cross(u,u)
		H[l.k+1,1..l.k]    = 2*cross(u,l.X)/s
		_makesymmetric(H)

}

void test()
{
		class trustReg scalar S
		struct linear scalar l
		real rowvector step
		
		l.y = st_data(.,"price")
		l.X = st_data(.,"weight"),J(rows(l.y),1,1)
		l.k = cols(l.X)
		
		
		S = trustReg()
		
		S.evaluator = &evalLinear()
		S.m_p = (0,0,0) // (2.044062586,   -6.707354013 ,   7.811269576   ) // (2,-6.7,7.8) //  (0,0,0)
		S.m_k = cols(S.m_p)
		S.m_lambda = 1
		S.m_Delta = 0.5
		S.m_Delta_hat = 10
		S.m_eta   = 0.2
		S.m_maxIterSubProb = 4
		S.m_maxIter = 2000
		S.m_tol = 1e-8
		S.m_todo = 2
		S.m_trace = 3
		
		S.extra.a1 = J(1,1,l)
// 		initExtraArgs(S.extra)
		
// 		rows(S.extra.a1),cols(S.extra.a1)
		isEmpty(S.extra.a1)
		countExtraArgs(S.extra)
		
		S.extra.nExtraArgs
		
// 		exit()
		S.trustOptimize()	
		
		
		
		


}

void testOptim()
{
		transmorphic S
		struct linear scalar l
		real rowvector p
		
		l.y = st_data(.,"price")
		l.X = st_data(.,"weight"),J(rows(l.y),1,1)
		l.k = cols(l.X)
		
		S = optimize_init()
		optimize_init_which(S,"min")
		optimize_init_evaluator(S,&evalLinear2())
		optimize_init_evaluatortype(S,"d2debug")
		optimize_init_technique(S,"nr")
		optimize_init_argument(S,1,l)
		optimize_init_params(S,(0,0,0))
// 		optimize_init_trace_gradient(S,"on")
		optimize_init_trace_Hessian(S,"on")
		optimize_init_conv_maxiter(S,100)
		
		p = optimize(S)
		p


}

test()
// testOptim()

end

exit
reg price weight
