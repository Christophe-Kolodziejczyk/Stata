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

rho_k = f(x_k)-f(x_k+p_k)/(m_k(0) - m_k(p_k)) (4.4)

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
mata:

class trustReg {
		
		real scalar m_f
		real rowvector m_p
		real rowvector m_grad
		real matrix    m_B
		
		real scalar m_k
		real scalar m_Delta
		real scalar m_lambda
		
		real scalar m_maxIterSubProb
		
		real rowvector solveSubProb()
		
		pointer scalar evaluator

}

real rowvector trustReg::solveSubProb()
{
		
		real scalar lambda
		real matrix R, H
		real rowvector p, q
		real scalar i
		
		i = 0
		lambda = m_lambda
		
		H = m_B + lambda*I(m_k)
		p = cholsolve(H,-m_grad)
		R = cholesky(H)
		q = lusolve(R,p)

		while (++i <= m_maxIterSubProb) 
		{
				lambda = lambda + (norm(p)/norm(q))^2*((norm(p)-m_Delta)/m_Delta)
		}


}

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

end

mata:

rosen(p0=(0.25,0),f0=.,g0=.,H0=.)

p0
g0
H0

cholsolve(H0,-g0')
end
// exit

mata:
rosen(p0=(0,0),f0=.,g0=.,H0=.)
f0
g0

p0 = (0,0)
rosen(p0,f0=.,g0=.,H0=.)
deltaG = g0
H0 = I(2)
H1 = .
g1 = g0
f1 = f0
j = 0
maxIterOpt = 20

while ( (reldif(f1,f0) > 1e-8 |j==0) & ++j <= maxIterOpt)
{

		printf("Iteration %2.0f\n",j)
		if (j>1) f0 = f1
		oldF = f0
		

		j,f0,oldF
		"p0"
		mm_matlist(p0,"%g",0)
		"g0"
		mm_matlist(g0,"%g",0)
		"H0"
		mm_matlist(H0,"%g",0)
		deltaG
		s1 = cholsolve(H0,-deltaG')' // (0.1,0.1)
		
		"step"
		mm_matlist(s1,"%g",0)
		lambda = 1
		p1 = p0 + lambda*s1
		mm_matlist(p0,"%g",0)
		mm_matlist(p1,"%g",0)
		rosen(p1,f1,g1,H1)

		
		maxIterSteps = 1000
		i = 0
		//f1,oldF
		"Finding step"
		while (f1- oldF > 0  & ++i <= maxIterSteps)
		{
			lambda = lambda/2
			// printf("lambda=%6.5f\n",lambda)
			p1 = p0 + lambda*s1
			// rosen(p1,f1=.,g1=.,H1=.)
			rosen(p1,f1,g1,H1)
			// f1,f0
		}
		lambda
		printf("f1=%9.4f\n",f1)
		
// 		"p1"
// 		p1
// 		"g1"
// 		g1
// 		"H1"
		//H1 = DFP(lambda*s1,(g1-g0),H0)
		"new Hessian"
		mm_matlist(H1,"%g",0)
// 		invsym(H1)
// 		H1
		"f0,f1"
		f0,f1
		// f0 devient f1
		reldif(f1,f0)
		
		// update g and H
		deltaG = g1 // - g0
		g0 = g1
		H0 = H1
		p0 = p1
		
		
		
		

}

end
exit
mata:

M = I(3)
symeigenvalues(M)


end
