// global root E:\ProjektDB\KORA\Workdata\704752\stcrmixPack\BFGS
global root P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\statprog\stcrmix-pack-src-all\BFGS
global root C:\Users\chris\OneDrive\Documents\Stata\BFGS
adopath ++ $root

do $root\BFGSV2.do

clear mata
clear
set seed 1010
set obs 100000
drawnorm x
gen draw = runiform()
gen p = invlogit(1+x)
gen y = p>draw

sum 

// logit y x


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

		b  = p[1..l.k]
		
		xb = l.X*b
		d = 1:-l.y
		OnepExb = 1:+exp(xb)
		pr = invlogit(xb)
		f = -sum( l.y:*(xb:-log(OnepExb))+ d:*(-log(OnepExb)) ,1)
		grad = (l.y:*(1:-pr) :+ d:*(-pr) ):*l.X
		
		g = -colsum(grad,1)'
		
		if (todo==2)
		{
				H = cross(l.X,pr:*(1:-pr),l.X)
				_makesymmetric(H)
		}
		// DFP(g,H,f)
		

}

void evalLogitMax(todo,p,struct linear l, f, g, H)
{
		real scalar    ls, s
		real colvector d, xb,OnepExb, pr, b
		real matrix grad

		b  = p[1..l.k]
		
		xb = l.X*b
		d = 1:-l.y
		OnepExb = 1:+exp(xb)
		pr = invlogit(xb)
		f = sum( l.y:*(xb:-log(OnepExb))+ d:*(-log(OnepExb)) ,1)
		grad = (l.y:*(1:-pr) :+ d:*(-pr) ):*l.X
		
		g = colsum(grad,1)'
		
		if (todo==2)
		{
				H = cross(l.X,pr:*(1:-pr),l.X)
				_makesymmetric(H)
		}
		// DFP(g,H,f)
		

}


void test()
{
		class cBFGS scalar bfgs
		struct linear scalar l, j
		real rowvector step
		real colvector b, grad
		real scalar f
		real matrix H
		
		l.y = st_data(.,"y")
		l.X = st_data(.,"x"),J(rows(l.y),1,1)
		l.k = cols(l.X)
		
		bfgs = cBFGS()
		
		bfgs.BfgsInit((10,1)',&evalLogitMax())
		bfgs.BfgsInit_arguments(1,l)
		bfgs.BfgsInitWhich("max")
		
		

// 		bfgs.m_extra.a1.k
// 		real colvector y
		
// 		"ok"
// 		bfgs.callf2(bfgs.m_caller,0,b=(1,1)',f=.,grad=J(2,1,.),H =.,1)
// 		"pouet"
// 		f
// 		bfgs.m_grad
// 		exit()
		bfgs.m_trace = 0
		bfgs.m_maxIter = 10
		bfgs.m_transpose
		bfgs.BfgsOptimize()
			
		
		


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
		optimize_init_technique(S,"bfgs")
		optimize_init_argument(S,1,l)
		optimize_init_params(S,(0,0))
		optimize_init_trace_gradient(S,"on")
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
