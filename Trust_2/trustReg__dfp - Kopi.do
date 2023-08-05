// clear mata
mata:
real matrix DFP(s,y,H)
{
		real matrix updH
		real scalar spY
// "update H"
		spY = cross(s,y)
		updH = H - (H*y'*y*H):/(y*H*y')+ (s'*s)/spY
		

		if (hasmissing(updH)|det(updH)==0) return(H)
		else return(updH)
}

real matrix BFGS(s,y,B,max)
{
		real matrix updB
		real scalar spY, update
		spY = y*s'
		if (max) update = spY < 0  
		else update = spY >0 // cross(s,y)
		// spY

		if (update) 
		{
				updB = B - (B*s'*s*B)/(s*B*s')+ (y'*y)/spY
				_makesymmetric(updB)
				if (!hasmissing(updB)) return(updB)
				else return(B)

		}
		else return(B)

}

real matrix invBFGS(s,y,iB)
{
		real matrix updiB, I, IrhosPy
		real scalar rho
		// B
		rho = 1/(y*s')
		
	    I = I(cols(s))
// 		s'*y
// 		rho
// 		s*s'
		IrhosPy = I-rho*s'*y
		updiB = (IrhosPy)*iB*(IrhosPy)' + rho*cross(s,s)
		// (B*s'*s*B):/(s*B*s')+ (y'*y):/(y*s')
		updiB = (updiB + updiB')/2
		
		_makesymmetric(updiB)
// 		det(updB)
		
		if (hasmissing(updiB)) return(iB)
		else return(updiB)

}


// void pouet()
// {
// 		"pouet!"
// }
//
//
// s = J(1,2,10)
// y = J(1,2,1)
// B = I(2)*2
// iB = invsym(B)
//
// invBFGS(s,y,B)
// invsym(BFGS(s,y,iB))

end
