mata:
void rosenbrock(todo,p,f,g,H)
{

		real scalar x1, x2
		real scalar g1, g2
		real scalar h11, h21, h22
		
		x1 = p[1]
		x2 = p[2]
		
		
		f  = 100*(x2-x1^2)^2 + (1-x1)^2
		if (f==.) return
		
		if (todo >= 1)
		{
				g[1] =-400*(x2-x1^2)*x1-2*(1-x1)
				g[2] = 200*(x2-x1^2) 
		}
		
		if (todo>=2)
		{
				H[1,1] = -400*(x2-3*x1^2)+2
				H[2,2] = 200
				H[2,1] = -400*x1
				_makesymmetric(H)
		}
		// H = (h11,h21\h21,h22) // ..
		
// 		H = . // ..

}
end
