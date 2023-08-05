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


struct extraArgs {
		
		// 3 extra arguments, in general I will pass a structure
		// to minimize the # of arguments
		transmorphic a1
		transmorphic a2
		transmorphic a3
		real scalar nExtraArgs

}

end
