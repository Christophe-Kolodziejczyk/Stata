cap mata: mata drop computeVariance()
cap mata: mata drop splitBlocks()
cap mata: mata drop genBlocks()
cap mata: mata drop makeGrid()
mata:
real matrix computeVariance(ps,d)
{
	class Factor scalar f
	real vector mean_ps, l
	real scalar S, dt, t_stat, N
	
	f = _factor(d)
	mean_ps = aggregate_mean(f,f.sort(ps),.,"")
// 	f.keys,f.counts,mean_ps
	N = sum(f.counts)
	
	l = (ps:-!d:*mean_ps[1]-d:*mean_ps[2]):^2
	S = aggregate_sum(f,f.sort(l),.,""):/(N-2)
	dt = mean_ps[1]-mean_ps[2]


	t_stat = dt:/sqrt(sum(S):*sum(1:/f.counts))
	
	return( (dt,t_stat) )
	
}

real matrix splitBlocks(real colvector ps,
						real colvector t,
                        real colvector blocks,
						real scalar Nblocks)
{
	
	class Factor scalar f
	real colvector split , medians, maxval, ps_bl, t_bl, res
	
// 	f = _factor(blocks)
	
	split = J(Nblocks,1,.)
// 	medians = aggregate_quantile(f,f.sort(ps),.,"",.5)
// 	maxval  = aggregate_max(f,f.sort(ps),.,"")
// 	maxval[Nblocks] = .

	
	for (i = 1; i <= Nblocks ; i++)
	{
		ps_bl = select(ps,blocks:==i)
		t_bl  = select(t,blocks:==i)
		res = computeVariance(ps_bl,t_bl)
		split[i] = abs(res[2]):>=1
		
	}
	
	return(split)
}

real vector makeGrid(class Factor scalar b,
                     real colvector ps,
					 real colvector split)
{
	
		real colvector medians, maxval, grid
		real scalar i
		
		b.panelsetup()
	
		medians = aggregate_quantile(b,b.sort(ps),.,"",.5)
		maxval  = aggregate_max(b,b.sort(ps),.,"")
		maxval[length(maxval)] = .
		
		medians = select(medians,split)
// 		maxval  = select(maxval,split)
		grid =sort( (min(ps)\medians\maxval) , 1 ) 
				
		return(grid)
}


real matrix genBlocks(real colvector ps,
                      real vector grid)
{
	real colvector ps_blocks, index, blocks
	real scalar i, keys
	k = length(grid)
	
	blocks = 1::k-1
	
	ps_blocks = J(rows(ps),1,.)
	for (i = 1; i < k ; i++)
	{
		index = selectindex( ps :>= grid[i] :& ps :< grid[i+1] )
		ps_blocks[index] = J(rows(index),1,blocks[i])
		
	}

// 	ps_blocks[1..10,]
	
	return(ps_blocks)
	
}

end