cap log close
local file E:\ProjektDB\KORA\Workdata\704752\stcrmixPack\trust\rosenbrock.smcl
log using `file' , replace

clear mata
mata:

void rosen(todo,p,f,g,H)
{

		real scalar x1, x2
		real scalar g1, g2
		
		x1 = p[1]
		x2 = p[2]
		H = J(2,2,.)
		
		f  = 100*(x2-x1^2)^2 + (1-x1)^2
		if (todo>=1) 
		{
				g1 =-400*(x2-x1^2)*x1-2*(1-x1)
				g2 = 200*(x2-x1^2) 
		
				g = g1,g2
		}
		
		if (todo>=2)
		{
				H[1,1] = -400*(x2-3*x1^2)+2
				H[2,2] = 200
				H[2,1] = -400*x1
				_makesymmetric(H)
		}
		
// 		H = . // ..

}

S = optimize_init()
optimize_init_which(S,"min")
optimize_init_evaluator(S,&rosen())
optimize_init_evaluatortype(S,"d2")
optimize_init_technique(S,"bfgs")
optimize_init_params(S,(1,-1))
optimize_init_trace_gradient(S,"on")
optimize_init_trace_Hessian(S,"on")
optimize_init_tracelevel(S,"value")
optimize_init_conv_maxiter(S,100)
p = optimize(S)

p

end
log close
view `file'

exit


mata : 
H = (-.5000068, 0\-.9999247 , -2.004639)
_makesymmetric(H)
H
invsym(-H)

end
