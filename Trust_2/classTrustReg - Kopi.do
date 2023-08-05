/************************************************************
Filename            : classTrustReg.do
Author              : Christophe Kolodziejczyk
Date of creation    : 27-07-2017
Modified            : 03-03-2018
03-03-2018: inserted header
27-07-2017: last saving

Purpose             : code for the trustReg class

Trust Region algorithm:
Newton
Quasi-Newton: BFGS og DFP

Input               :
Output              :



*************************************************************/

// clear mata
mata:
class trustReg {
		real scalar prout()
		void pouet()

		real scalar m_f
		real scalar m_todo
		real rowvector m_p, m_step
		real rowvector m_grad, m_gradk
		real matrix    m_B, m_invB, m_B0, m_invB0
		real scalar    m_notConcave
		
		real scalar m_k
		real scalar m_Delta, m_Delta_hat
		real scalar m_lambda
		real scalar m_eta
		
		real scalar m_maxIterSubProb
		real scalar m_maxIter
		real scalar m_nrtol, m_ftol, m_ptol, m_giBg
		real scalar m_testNrtol, m_testFtol, m_testPtol
		real scalar m_trace
		real scalar m_iter
		real scalar m_hasConverged
		real scalar m_rc
		real scalar m_trustAction
		
		real matrix m_Q
		real rowvector m_Ev
		real scalar m_minEv, m_isPosDef
		
		pointer scalar evaluator
		struct extraArgs scalar extra
		
		string scalar m_technique
		string scalar m_which
		string scalar m_lineBreak
		
		string matrix m_techniqueSeq
		string colvector m_tech
		real   colvector m_techIter
		struct callf_forp scalar caller
// 		transmorphic caller
		

		void trustInit()
		void constructTrust()
		
		
		real rowvector solveSubProb()
		real rowvector computeTau()
		real rowvector newtonStep()
		
		
		void trustProb()
		void printCurrentState()
		void trustOptimize()
		void trustLoopOptimize()
		void initGradHessian()
		
		void displayResults()
		
		void initCaller()
		void passingToCaller()
		
		real scalar computeEigenvect()
		real matrix updateHessian()
		
				
		void new()
		

}

// mata mosave 
// S = trustReg()
// S.pouet()
end

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
