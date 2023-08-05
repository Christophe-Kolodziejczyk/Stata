local e1
// clear mata
mata:
struct callf_forp {
		pointer(function) scalar f
		real scalar              n
		pointer scalar           p1
		pointer scalar           p2
		pointer scalar           p3
		pointer scalar           p4
		pointer scalar           p5
		

}

struct callf_forp scalar callf_setup(
		pointer(function) scalar f,
        real scalar n,| a1,a2,a3,a4,a5)
{
		struct callf_forp scalar p
		
		p.f = f
		p.n = n
		p.p1 = &a1 ; p.p2 = &a2 ; p.p3 = &a3 ; p.p4 = &a4 ; p.p5 = &a5;
		
		return(p)



}

// transmorphic callf(struct callf_forp p, todo, b, f, g, H)
// {
//
// 		if (p.n==0) return( (*p.f)(todo, b, f, g, H) )
// 		if (p.n==1) return( (*p.f)(todo, b, *p.p1, f, g, H) ) 
// 		if (p.n==2) return( (*p.f)(todo, b, *p.p1, *p.p2,  f, g, H) ) 
// 		if (p.n==3) return( (*p.f)(todo, b, *p.p1, *p.p2, *p.p3, f, g, H) ) 
// 		if (p.n==4) return( (*p.f)(todo, b, *p.p1, *p.p2, *p.p3, *p.p4, f, g, H) ) 
// 		if (p.n==5) return( (*p.f)(todo, b, *p.p1, *p.p2, *p.p3, *p.p4, *p.p5,  f, g, H) )
//
//
//
// }

void cBFGS::callf2(struct callf_forp p, todo, b, f, g, H,negate)
{
		if (m_transpose) _transposeonly(b)
		
		if (p.n==0) (*p.f)(todo, b, f, g, H) 
		if (p.n==1) (*p.f)(todo, b, *p.p1, f, g, H)
		if (p.n==2) (*p.f)(todo, b, *p.p1, *p.p2,  f, g, H)  
		if (p.n==3) (*p.f)(todo, b, *p.p1, *p.p2, *p.p3, f, g, H) 
		if (p.n==4) (*p.f)(todo, b, *p.p1, *p.p2, *p.p3, *p.p4, f, g, H) 
		if (p.n==5) (*p.f)(todo, b, *p.p1, *p.p2, *p.p3, *p.p4, *p.p5,  f, g, H)
		
// 		"m_transpose"
// 		m_transpose
		
		if (m_transpose) 
		{	
				f = colsum(f,1)
				g = colsum(g,1)	
				_transposeonly(g)
				_transposeonly(b)
		}
		
		if (negate)
		{
				_negate(f)
				if (todo >= 1) _negate(g)
				if (todo >= 2) _negate(H)
		
		}
		


}



end
