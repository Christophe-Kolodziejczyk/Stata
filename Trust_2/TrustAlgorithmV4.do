/*
Trust region algorithm

We want to minimize f(x)


Subproblem 

p is a step, i.e x_k+1 = x_k + p_k

min m_k(p) = f_k + g_k'*p + (1/2)*p'B_k*p   (4.3)

g_k : gradient at iteration k
B_k : Approximation of the Hessian at iteration k

s.t.  ||p|| <= Delta

Delta trust radius

rho_k = (f(x_k)-f(x_k+p_k))/(m_k(0) - m_k(p_k)) (4.4)

numerator: actual reduction
denominator: predicted reduction

Algorithm
given Delta_hat (max trust region given??), Delta_0 in (0,Delta_hat), eta in (0,0.25)

Obtain p_k by approximately solving (4.3)

Evaluate rho_k by (4.4)

if rho_k < 1/4 then 
	Delta_k+1 = 1/4 * Delta_k
else
	if rho_k > 3/4 and ||pk|| = Delta_k then
		Delta_k+1 = min(2*Delta_k,Delta)
	else
		Delta_k+1 = Delta_k
		
if rho_k > eta then
	x_k+1 = x_k + p_k
else 
	x_k+1 = x_k

	
Subproblem

Given lambda(0),Delta

	p_l = -(B + lamdba*I) ^(-1)*g_l
	
	Factor B + lambda(l)*I = R'R -> cholesky decomposition
	Solve R'Rp_l = -g and R'q_l = p_l
	
	Set 
		lambda(l+1) = lambda(l) + (||p_l||/||q_l||)^2( (||p_l||-Delta)/Delta)
		
Repeat until convergence
	

Compute H = B  + lambda*I

p_l is obtained by cholsolve(H,-g)
q_l by lusolve(R',p_l) where R' = cholesky(H)
|| . || should be calculated with norm()

Evaluator should have the form (up to three extra arguments)

void eval(p, [args1, args2, args3],f,grad,B)
{



}

*/

/*

evaluator

void eval(p,x1,..,xk,f,g,H)
{



}

Rosenbooke

void rosen(p,f,g,H)
{
		real scalar x1, x2
		real scalar g1, g2
		x1 = p[1]
		x2 = p[2]
		f  = 100*(x2-x1^2)^2 + (1-x1)^2
		g1 =-400*(x2-x1^2)*x1-2*(1-x1)
		g2 = 200*(x2-x1^2) 
		
		g = g1,g2
		
		H = ...

}

*/

clear mata
mata: mata set matalnum on

do E:\ProjektDB\KORA\Workdata\704752\trust\caller.do

mata:

real matrix DFP(s,y,H)
{
		real matrix updH
// "update H"
		updH = H - (H*y'*y*H):/(y*H*y')+ (s'*s):/(y*s')
		
// 		H
// 		y
// 		s'
// 		(H*y'*y*H):/(y*H*y')
// 		(s'*s):/(y*s')
// 		y*s'
// 		y
// 		s'
		if (hasmissing(updH)) return(H)
		else return(invsym(updH))
}

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

struct extraArgs {
		
		// 3 extra arguments, in general I will pass a structure
		// to minimize the # of arguments
		transmorphic a1
		transmorphic a2
		transmorphic a3
		real scalar nExtraArgs

}

real scalar isEmpty(transmorphic matrix a) return( (rows(a)==0|cols(a)==0) )

void initExtraArgs(struct extraArgs scalar extra)
{
		extra.a1 = J(0,0,.)
		extra.a2 = J(0,0,.)
		extra.a3 = J(0,0,.)
}

void countExtraArgs(struct extraArgs scalar extra)
{
		real scalar i
		
		extra.nExtraArgs = 0
		if (!isEmpty(extra.a1)) extra.nExtraArgs++
		if (!isEmpty(extra.a2)) extra.nExtraArgs++
		if (!isEmpty(extra.a3)) extra.nExtraArgs++
}

class trustReg {
		
		real scalar m_f
		real scalar m_todo
		real rowvector m_p
		real rowvector m_grad
		real matrix    m_B
		
		real scalar m_k
		real scalar m_Delta, m_Delta_hat
		real scalar m_lambda
		real scalar m_eta
		
		real scalar m_maxIterSubProb
		real scalar m_maxIter
		real scalar m_nrtol, m_ftol, m_ptol
		real scalar m_testNrtol, m_testFtol, m_testPtol
		real scalar m_trace
		
		pointer scalar evaluator
		struct extraArgs scalar extra
		
		string scalar m_technique
		
// 		transmorphic caller
		struct callf_forp scalar caller
		
		real rowvector solveSubProb()
		real rowvector computeTau()
		real rowvector newtonStep()
		
		void trustProb()
		void printCurrentState()
		void trustOptimize()
		
		void initCaller()
		void passingToCaller()
		

}


real rowvector trustReg::solveSubProb()
{
		
		real scalar lambda, minLambda
		real matrix R, H, Q
		real rowvector p0, p1, q
		real scalar i, hasConverged
		real colvector eigenVal
		
		if (m_trace>=3) printf("Solving sub-problem\n")
		
		i = 0
		lambda = m_lambda
		
// 		m_k
// 		m_B
// 		lambda
// 		m_grad
//		

		eigenVal = symeigenvalues(m_B)
		if (m_trace>=3) 
		{
				printf("{text}Eigenvalue of B\n")
				mm_matlist(eigenVal,"%g",0)
		}
		minLambda = min(eigenVal)
		

		if (minLambda <= 0) p1 =computeTau()
		else p1 = newtonStep(eigenVal)
		
		
		if (m_trace>=3) {
				printf("{text}New step found:\n")
				mm_matlist(p1,"%g",0)
				printf("{text}Norm of step = {res}%g\n",norm(p1))
		}
		return(p1)


}



void trustReg::trustProb(real rowvector step)
{
		
		scalar rho, f0, f1, m1
		real rowvector p1, p0
		real rowvector g1
		real matrix    H1
		
		if (m_trace>=2) printf("{text}Trust region problem!\n")
		
		f0 = m_f
		p0 = m_p
		p1 = m_p + step 
		// (*evaluator)(p1,m_f,m_grad,m_B)
		
		
// 		S.f_opt_temp = mm_callf(po,S.mu_0)
// 		mm_callf(caller,p1,m_f,m_grad,m_B)
		if (m_trace>=2) 
		{
				printf("{text}Trial parameters:\n")
				mm_matlist(p1,"%g",0)
		}
		passingToCaller(m_todo,p1,f1,g1,H1)

		if (m_technique=="dfp") H1 = DFP(step,g1-m_grad,invsym(m_B))
// 		H1
// 		exit()
		
		// m_grad
		m1 = -m_grad*step' - 0.5*step*m_B*step'
		
// 		step
// 		f0,m_f
// 		m1
// 		"ok"
		rho = (f0-f1)/m1
		if (m_trace>=2) 
		{
				printf("{text}f0         = {res}%g\n",f0)
				printf("{text}f1         = {res}%g\n",f1)
				printf("{text}f0-f1      = {res}%g\n",f0-f1)
				printf("{text}m1         = {res}%g\n",m1)
				printf("{text}rho        = {res}%g\n",rho)
				printf("{text}norm(step) = {res}%g\n",norm(step))
		}
		
		if (rho < 0.25)  m_Delta = (0.25)*m_Delta 
		else if (rho > 0.75 & reldif(norm(step),m_Delta) < 0.001) m_Delta = min((2*m_Delta,m_Delta_hat))
		else m_Delta = m_Delta
		
		if (rho > m_eta) {
				m_p    = p1
				m_f    = f1
				m_grad = g1
				m_B    = H1
				
		}
		else m_p = p0
		
// 		(*evaluator)(m_p,m_f,m_grad,m_B)
// 		passingToCaller(m_p,m_f,m_grad,m_B)

}

void trustReg::printCurrentState()
{
		printf("\n**************************\n")
		printf("{text}Delta     = {res}%g\n",m_Delta)
		printf("{text}Eta       = {res}%g\n",m_eta)
		printf("{text}Delta max = {res}%g\n",m_Delta_hat)
		
		printf("\n**************************\n")
		printf("{text}Value function = {res}%g\n",m_f)
		printf("{text}Current vector :\n")
		mm_matlist(m_p,"%g",0)
		printf("{text}Norm of gradient = {res}%g \n", norm(m_grad))
		printf("{text}Current gradient:\n")
		mm_matlist(m_grad,"%g",0)
		printf("{text}Current hessian:\n")
		mm_matlist(m_B,"%g",0)
		
		printf("{text}ptol = {res}%g {text}, ftol = {res}%g {text}, nrtol = {res}%g\n",m_testPtol,m_testFtol,m_testNrtol)


}



real rowvector trustReg::computeTau()
{
		real matrix X , lambda
		real colvector w
		real matrix Xs
		real scalar tau, delta
		real colvector z
		real colvector p
		real scalar k 
		
		if (m_trace>=3) printf("{text}Compute tau\n")
		symeigensystem(m_B,X,lambda)		
		z = X[,cols(lambda)]
// 		X
		
		k = cols(lambda)-1
		w = (lambda[1..k]:-lambda[cols(lambda)])'
		Xs  =X[,1..k]'
// 		Xs
// 		w
// 		quadcross(Xs,1:/w,Xs)
		p = quadcross(Xs,1:/w,Xs)*m_grad' // (Xs'*m_grad':/w)*Xs 
		if (m_trace>=3) 
		{
				printf("{text}p\n")	
				mm_matlist(p',"%g",0)
				printf("{text}||norm(p)|| = {res}%g\n",norm(p))
		}
// 		sum((X[,1..k]'*S.m_grad'):^2:/((lambda[1..k]:-lambda[cols(lambda)]):^2))
	
		
		delta = 5
		real scalar normPsq 
		normPsq = quadsum(((Xs*m_grad'):^2):/(w:^2))
		if (m_trace>=3) printf("{text}normP   = {res}%g\n",sqrt(normPsq))
		tau = sqrt(m_Delta:^2-norm(p):^2)
		if (m_trace>=3) printf("{text}tau     = {res}%g\n",tau)
		if (m_trace>=3) printf("{text}m_Delta = {res}%g\n",m_Delta)

		
		p = p + tau*z
		if (m_trace>=3) printf("{text}||norm(p)|| = {res}%g\n",norm(p))
		
		return(p')


}

real rowvector trustReg::newtonStep(real rowvector eigenVal)
{

		if (m_trace>=3) printf("{text}Newton step\n")
		real scalar lambda, minLambda
		real matrix R, H, Q
		real rowvector p0, p1, q
		real scalar i, hasConverged
// 		real colvector eigenVal
		
		minLambda = min(eigenVal)
		p0 = J(m_k,1,0)
		p1 = p0 :+ 1
		
		i = 0
		hasConverged = 0
		lambda = m_lambda
// 		lambda
		
		while ( !hasConverged & ++i <= m_maxIterSubProb)
		{
// 		"loop"
				p0 = p1
				H  = m_B + lambda*I(m_k)
				p1 = cholsolve(H,-m_grad')
				R  = cholesky(H)
				q  = lusolve(R,p1)
				
				// symeigenvalues(m_B)
				

				lambda = lambda + (norm(p1)/norm(q))^2*((norm(p1)-m_Delta)/m_Delta)
// 				lambda, minLambda
				lambda = max((lambda,minLambda))
// 				lambda 
				
				if (!hasmissing(p1)|!hasmissing(p0) ) hasConverged = mreldif(p0,p1)<0.001
// 				p1
				
// 				lambda = 1
		}
// 		p1
		if (m_trace>=3) printf("{text}Number of iterations: {res}%g\n",i)
		return(p1')


}

void trustReg::trustOptimize()
{
		real scalar iter, maxIter, hasConverged
		real scalar nrtol, ptol, ftol, f0
		real rowvector step, p0
		
		transmorphic a1, a2, a3, a4, a5
		
// 		if (extra.nExtraArgs==0) caller  = callf_setup(evaluator,extra.nExtraArgs) // ,a1,a2,a3,a4,a5) 
// 		else if (extra.nExtraArgs==1) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1,a2,a3,a4,a5) 
		
		initCaller()
		
		iter = 0
		m_f = m_grad = m_B = .
// 		(*evaluator)(m_p,m_f,m_grad,m_B)
// 		mm_callf(caller,m_p,m_f,m_grad,m_B)

		passingToCaller(m_todo,m_p,m_f,m_grad,m_B)
		if (m_technique=="dfp") 
		{
				m_grad = J(1,m_k,0)
				m_B= invsym(I(m_k))
		}
		
		if (m_trace>=1) 
		{
				printf("Starting values\n")
				printCurrentState()
		}
		
		hasConverged = 0
		while ( !hasConverged & ++iter<=m_maxIter)
		{
				p0 = m_p
				f0 = m_f
				if (m_trace>=1) printf("\n{text}********************************\n")
				printf("{text}Iteration: {res}%g {text}- f(p) = {res}%g{text}\n",iter,m_f)
				// printf("{text}f(p) = {res}%g\n",m_f)
				step = solveSubProb()
				
				trustProb(step)
		// 		S.m_p
		// 		S.m_Delta
				real matrix invB
				invB= invsym(m_B)
				
				m_testFtol = reldif(m_f,f0)
				m_testPtol = mreldif(m_p,p0)
				m_testNrtol = m_grad*invB*m_grad'
				
				if (m_trace>=1) printCurrentState()
				
				
				hasConverged = (m_testNrtol <= m_nrtol  & (m_testFtol <= m_ftol | m_testPtol <= m_ptol) )
				if (abs(det(invB))<=0) hasConverged = 0
		}
		
		printf("\n{text}********************************\n")
		if (hasConverged) {	
				
				printf("{text}Optimum achieved after {res}%g {text}iterations \n",--iter)
				printf("{text}Value at the optimum = {res}%g\n",m_f)
				printf("{text}Vector of parameters\n")
				mm_matlist(m_p,"%g",0)
		}
		else {
				printf("{text}Convergence not achieved after {res}%g {text}iterations\n",--iter)
		
		}


}



void trustReg::passingToCaller(todo,p,f,grad,B)
{
		
// 		printf("# of extra arguments = %g\n",extra.nExtraArgs)

		callf(caller,todo,p,f,grad,B)
// 		if (extra.nExtraArgs==0) callf(caller,todo,p,f,grad,B)
// 		else if (extra.nExtraArgs==1) callf(caller,todo,f,grad,B)
// 		else if (extra.nExtraArgs==2) callf(caller,todo,p,extra.a1,extra.a2,f,grad,B)
// 		else if (extra.nExtraArgs==3) callf(caller,todo,p,extra.a1,extra.a2,extra.a3,f,grad,B)
}

void trustReg::initCaller()
{

		if (extra.nExtraArgs>5)
		{
				_error(3001,"Number of extra arguments greater than 5")
		
		}
		if (extra.nExtraArgs==0) caller  = callf_setup(evaluator,extra.nExtraArgs) // ,a1,a2,a3,a4,a5) 
		else if (extra.nExtraArgs==1) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1) 
		

}

void main()
{
		class trustReg scalar S
		real rowvector step
		
		S = trustReg()
		
		S.evaluator = &rosen()
		S.m_p = (0,0)
		S.m_k = cols(S.m_p)
		S.m_lambda = 1
		S.m_Delta = 0.5
		S.m_Delta_hat = 1
		S.m_eta   = 0.2
		S.m_maxIterSubProb = 4
		S.m_maxIter = 100 
		S.m_trace = 3
		S.m_nrtol = 1e-5
		S.m_ptol  = 1e-6
		S.m_ftol  = 1e-7
		S.m_technique = "dfp"
		
// 		initExtraArgs(S.extra)
		
		//rows(S.extra.a1),cols(S.extra.a1)
		// isEmpty(S.extra.a1)
		countExtraArgs(S.extra)
		printf("# of extra arguments = %g \n",S.extra.nExtraArgs)
		
		
		
// 		exit()
		S.trustOptimize()
		
		transmorphic po
		
		


}



main()

end


global root E:\ProjektDB\KORA\Workdata\704752\stcrmix
global pado $root\ado
// include "$root\CRSetUp.do"
// di "$pado"

sysdir set PERSONAL $pado\


mata:
mata mlib create ltrustreg , replace dir(PERSONAL)
mata mlib add ltrustreg *() , dir(PERSONAL) complete

end
