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
mata:

real matrix DFP(s,y,H)
{
		real matrix updH

		updH = H - (H*y'*y*H):/(y*H*y')+ (s'*s):/(y*s')
		
		return(updH)
}

void rosen(p,f,g,H)
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
		real rowvector m_p
		real rowvector m_grad
		real matrix    m_B
		
		real scalar m_k
		real scalar m_Delta, m_Delta_hat
		real scalar m_lambda
		real scalar m_eta
		
		real scalar m_maxIterSubProb
		real scalar m_maxIter
		real scalar m_tol
		
		pointer scalar evaluator
		struct extraArgs scalar extra
		
		transmorphic caller
		
		real rowvector solveSubProb()
		real rowvector computeTau()
		real rowvector newtonStep()
		
		void trustProb()
		void printCurrentState()
		void trustOptimize()
		
		void passingToCaller()
		

}


real rowvector trustReg::solveSubProb()
{
		
		real scalar lambda, minLambda
		real matrix R, H, Q
		real rowvector p0, p1, q
		real scalar i, hasConverged
		real colvector eigenVal
		
		printf("Solving sub-problem\n")
		
		i = 0
		lambda = m_lambda
		
// 		m_k
// 		m_B
// 		lambda
// 		m_grad
//		

		eigenVal = symeigenvalues(m_B)
		printf("Eigenvalue of B\n")
		mm_matlist(eigenVal,"%g",0)
		minLambda = min(eigenVal)
		

		if (minLambda <= 0) p1 =computeTau()
		else p1 = newtonStep(eigenVal)
		
// 		hasConverged = 0
// 		p0 = J(m_k,1,0)
// 		p1 = p0 :+ 1
// 		else {
// 				while ( !hasConverged & ++i <= m_maxIterSubProb)
// 				{
// 		// 		"loop"
// 						p0 = p1
// 						H  = m_B + lambda*I(m_k)
// 						p1 = cholsolve(H,-m_grad')
// 						R  = cholesky(H)
// 						q  = lusolve(R,p1)
//						
// 						// symeigenvalues(m_B)
//						
//
// 						lambda = lambda + (norm(p1)/norm(q))^2*((norm(p1)-m_Delta)/m_Delta)
// 		// 				lambda, minLambda
// 						lambda = max((lambda,minLambda))
// 						lambda 
//						
// 						if (!hasmissing(p1) ) hasConverged = mreldif(p0,p1)>0.001
// 		// 				p1
//						
// 		// 				lambda = 1
// 				}
// 		}
		
// 		printf("Number of iterations: %g\n",i)
		
		printf("New step found:\n")
		mm_matlist(p1,"%g",0)
		printf("Norm of step = %g\n",norm(p1))
		return(p1)


}



void trustReg::trustProb(real rowvector step)
{
		
		scalar rho, f0, f1, m1
		real rowvector p1, p0
		real rowvector g1
		real matrix    H1
		
		printf("Trust region problem!\n")
		
		f0 = m_f
		p0 = m_p
		p1 = m_p + step 
		// (*evaluator)(p1,m_f,m_grad,m_B)
		
		
// 		S.f_opt_temp = mm_callf(po,S.mu_0)
// 		mm_callf(caller,p1,m_f,m_grad,m_B)
		printf("Trial parameters:\n")
		mm_matlist(p1,"%g",0)
		passingToCaller(p1,f1,g1,H1)
		
		// m_grad
		m1 = -m_grad*step' - 0.5*step*m_B*step'
		
// 		step
// 		f0,m_f
// 		m1
// 		"ok"
		rho = (f0-f1)/m1
		printf("f0         = %g\n",f0)
		printf("f1         = %g\n",f1)
		printf("f0-f1      = %g\n",f0-f1)
		printf("m1         = %g\n",m1)
		printf("rho        = %g\n",rho)
		printf("norm(step) = %g\n",norm(step))
		
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
		printf("Delta     = %g\n",m_Delta)
		printf("Eta       = %g\n",m_eta)
		printf("Delta max = %g\n",m_Delta_hat)
		
		printf("\n**************************\n")
		printf("Value function = %g\n",m_f)
		printf("Current vector :\n")
		mm_matlist(m_p,"%g",0)
		printf("Norm of gradient = %g \n", norm(m_grad))
		printf("Current gradient:\n")
		mm_matlist(m_grad,"%g",0)
		printf("Current hessian:\n")
		mm_matlist(m_B,"%g",0)


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
		
		printf("Compute tau\n")
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
		"p"
		mm_matlist(p',"%g",0)
		printf("||norm(p)|| = %g\n",norm(p))
// 		sum((X[,1..k]'*S.m_grad'):^2:/((lambda[1..k]:-lambda[cols(lambda)]):^2))
	
		
		delta = 5
		real scalar normPsq 
		normPsq = quadsum(((Xs*m_grad'):^2):/(w:^2))
		printf("normP=%g\n",sqrt(normPsq))
		tau = sqrt(m_Delta:^2-norm(p):^2)
		printf("tau=%g\n",tau)
		printf("m_Delta=%g\n",m_Delta)

		
		p = p + tau*z
		printf("||norm(p)|| = %g\n",norm(p))
		
		return(p')


}

real rowvector trustReg::newtonStep(real rowvector eigenVal)
{

		printf("Newton step\n")
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
		printf("Number of iterations: %g\n",i)
		return(p1')


}

void trustReg::trustOptimize()
{
		real scalar iter, maxIter
		real rowvector step
		
		caller  = mm_callf_setup(evaluator,0) 
		
		iter = 0
		m_f = m_grad = m_B = .
// 		(*evaluator)(m_p,m_f,m_grad,m_B)
// 		mm_callf(caller,m_p,m_f,m_grad,m_B)
		passingToCaller(m_p,m_f,m_grad,m_B)
		printf("Starting values\n")
		printCurrentState()
		
		
		while (norm(m_grad)> m_tol & ++iter<=m_maxIter)
		{			
				printf("\n{text}********************************\n")
				printf("{text}Iteration: {res}%g\n",iter)
				printf("{text}f(p) = {res}%g\n",m_f)
				step = solveSubProb()
				
				trustProb(step)
		// 		S.m_p
		// 		S.m_Delta
				printCurrentState()
		}
		
		printf("\n{text}********************************\n")
		if (norm(m_grad)<= m_tol) {	
				
				printf("optimum achieved after %g iterations \n",--iter)
				printf("Value at the optimum = %g\n",m_f)
				printf("Vector of parameters\n")
				mm_matlist(m_p,"%g",0)
		}
		else {
				printf("Convergence not achieved after %g iterations\n",--iter)
		
		}


}

void trustReg::passingToCaller(p,f,grad,B)
{
		
// 		printf("# of extra arguments = %g\n",extra.nExtraArgs)
		if (extra.nExtraArgs==0) mm_callf(caller,p,f,grad,B)
		else if (extra.nExtraArgs==1) mm_callf(caller,p,extra.a1,f,grad,B)
		else if (extra.nExtraArgs==2) mm_callf(caller,p,extra.a1,extra.a2,f,grad,B)
		else if (extra.nExtraArgs==3) mm_callf(caller,p,extra.a1,extra.a2,extra.a3,f,grad,B)
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
		S.m_maxIter = 68
		S.m_tol = 1e-6
		
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
