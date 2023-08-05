clear 
set obs 10000

set seed 80548115
drawnorm x 
drawnorm u v
gen u1 = runiform()


gen t = (x + u)  > 0
gen y = t + v
sum t y


tabstat y , by(t)



probit t x
predict xb , pr
gen l_xb = logit(xb)
// kdensity l_xb

mata:
ps = st_data(.,"l_xb")
t  = st_data(.,"t")


blocks = J(N,1,1)
Nblocks = 1
split = 1
// for (i = 1; i <= 6 ; i++)
while (sum(split) > 0  )
{
	"Splitting"
	printf("Current # of blocks: %4.0g\n", Nblocks)
	
	split = splitBlocks(ps,t,blocks,Nblocks)
	split
	f = _factor(blocks)
	
// 	aggregate_quantile(f,f.sort(ps),.,"",.5)
// 	rows(blocks)

	grid = makeGrid(f, ps, split)
	grid
	blocks = genBlocks(ps,grid)
	Nblocks = max(blocks)
	
	
}
end
exit

// class factor scalar f
f = _factor(t)
f.keys




mean_ps = aggregate_mean(f,f.sort(ps),.,"")
f.keys,f.counts,mean_ps
N = rows(ps)
l = (ps:-!t:*mean_ps[1]-t:*mean_ps[2]):^2
S = aggregate_sum(f,f.sort(l),.,""):/(N-2)
dt = mean_ps[1]-mean_ps[2]

S

t_stat = dt:/sqrt(sum(S):*sum(1:/f.counts))
dt,t_stat

computeVariance(ps,t)



end
exit 

// split factor 

median = mm_quantile(ps,1,0.50)
median 
blocks = 1 :+ (ps :>= median) //  mm_cut(ps,(median,.))
(ps,blocks)[1..10,]
f2 = _factor(blocks)
f = join_factors(f2,f)
mean_ps = aggregate_mean(f,f.sort(ps),.,"")
f.keys,mean_ps

Nblocks = 2 


splitBlocks(ps,t,blocks,2)
end
exit 

split = J(Nblocks,1,.)
medians = aggregate_quantile(f2,f2.sort(ps),.,"",.5)
maxval  = aggregate_max(f2,f2.sort(ps),.,"")
maxval[Nblocks] = .


for (i = 1; i <= Nblocks ; i++)
{
	ps_bl = select(ps,blocks:==i)
	t_bl  = select(t,blocks:==i)
	res = computeVariance(ps_bl,t_bl)
	split[i] = abs(res[2]):>=1
	
}

split

medians = select(medians,split)
maxval  = select(maxval,split)
b =sort( (min(ps)\medians\maxval) , 1 ) 
b


blocks = 1::sum(1:+split)
blocks
end


mata:
ps_blocks = J(N,1,.)
for (i = 1; i < length(b) ; i++)
{
	index = selectindex((ps:>=b[i] :& ps :< b[i+1]))
	ps_blocks[index] = J(rows(index),1,blocks[i])
	
	
}

ps_blocks[1..10,]
end

exit 
ttest l_xb , by(t) 

exit

