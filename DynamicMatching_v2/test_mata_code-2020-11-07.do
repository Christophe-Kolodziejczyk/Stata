global DM R:\__econometrie\stata\DynamicMatching
global root $DM

include $root\header.do

global do run
$do $DM\duration.do
$do $DM\mergeMatrices-v2.do

cap mata: mata drop main2()
mata:
pointer matrix main2()
{
	struct duration scalar s, s_dm
	
	
	`RC' timeToTreatment 
	timeToTreatment = st_data(.,"timeToTreatment","last")
	s._t = &st_data(.,"_t","last")
	s.failure = &st_data(.,"_d","last")
	s.censored = &(!(*s.failure))
	s.cause  = &st_data(.,"trans","last")
	s.by  = &st_data(.,"treated","last")
	
	s.t = _factor(*s._t)
	s.group = _factor(*s.by)
	s.f = join_factors(s.t,s.group)
	s.failcode = 2
	s.p_w = &.
	
// 	(s.f).keys,(s.f.counts) 
	
	count(s)
	
	`RC' touse, time_treatment, treated
	`RS' nTimesTreat, i 
// 	class Factor scalar ftimeTreat
	s.ftimeTreat = _factor(select(timeToTreatment,*s.by:==1))
	time_treatment = s.ftimeTreat.keys
// 	time_treatment,s.ftimeTreat.counts
	
// 	time_treatment = uniqrows(select(timeToTreatment,*s.by:==1))
	nTimesTreat = length(time_treatment)
	s.maxTimeTreat = 20
	
	// keep a copy of the whole structure
	s_dm = s
	

	pointer matrix results
	results = J(2,nTimesTreat,NULL)
// 	nTimesTreat 
// 	time_treatment
	timeToTreatment[1..5,]
	
	`RS' maxTimeTreat 
	
	i = 0
	printf("{text}Max Time to Treatment : {res}%9.0g{text}\n",s.maxTimeTreat)
// 	for ( i = 1; i <= nTimesTreat ; i++)
	while (time_treatment[++i] <= s.maxTimeTreat)
	{
		printf("{text}Time to treatment {res}%9.0g{text}\n",time_treatment[i])
		
		// at risk the week after treatment
		touse = timeToTreatment:>= time_treatment[i] :& *s_dm._t :> time_treatment[i]  // :| !(*s_dm.by)
// 		rows(touse)
		
		(*s_dm._t)       = select(*s_dm._t,touse)
		(*s_dm.failure)  = select(*s_dm.failure,touse)
		(*s_dm.censored) = (!(*s_dm.failure))
		(*s_dm.cause)    = select(*s_dm.cause,touse)
		timeToTreatment  = select(timeToTreatment,touse)
// 		treated
		(*s_dm.by)       = select(*s_dm.by,touse)  
		
		s_dm.t = _factor(*s_dm._t)
		s_dm.group = _factor(timeToTreatment:== time_treatment[i] :& *s_dm.by )
		s_dm.f = join_factors(s_dm.t,s_dm.group)
		
		count(s_dm)
		data = s_dm.n_failed,s_dm.n_censored, s_dm.n_cs ,(s_dm.f).keys,s_dm.counts

		`RC' N0, N1 , k
		k = cols(data)
		
		N0 = sum(select(data[,k],data[,k-1]:==0))
		N1 = sum(select(data[,k],data[,k-1]:==1))
		
		printf("{text}N treated = {res}%9.0g{text}, N controls = {res}%9.0g{text}\n",N1, N0)
		printf("{text}Controls\n")
		results[1,i] = &m_cif2( select(data,data[,cols(data)-1]:==0))
		printf("{text}Treated\n")
		results[2,i] = &m_cif2( select(data,data[,cols(data)-1]:==1))
		
	}
	
	
	printf("{text}Making output\n")
	output(results,s)
	
	return(results)
}

void output(pointer matrix results,
            struct duration scalar s)
{
	
	
		// column 3 : CIF, column 7: time
		real matrix index
		real scalar i, nTimesTreat 
		
		real matrix Streat, weights, Scontrols, wcontrols, Ntreat
		real scalar Ntimes 
		
		nTimesTreat = s.maxTimeTreat // cols(results)
		printf("{text}Max Time to Treatment : {res}%9.0g{text}\n",s.maxTimeTreat)
		
		Streat = weights = J(s.t.num_levels, 1,.)
		Scontrols = J(s.t.num_levels,/*nTimesTreat+*/ 1,.)
		Ntreat = s.ftimeTreat.counts[1..nTimesTreat]
		wcontrols = Ntreat:/sum(Ntreat)
		
		Streat[,1] = s.t.keys
		Scontrols[,1] = s.t.keys
	
		index = (7,3)
		
		
		for ( i = 1; i <= nTimesTreat; i++)
		{
			
			res1 = (*results[1,i])[,index]
			res2 = (*results[2,i])[,index]
			
			res = merge(res1,res2)
			res[1,] = editmissing(res[1,],0)		
			_lagMissing(res)
			
	// 		res,res[,3]-res[,2]
			
// 			wcontrols
// 			size(Scontrols)
// 			size(Streat)
// 			size(res)
			
			
			Streat = merge(Streat,res[,(1,3)])
// 			Scontrols[(1..10),]
// 			res[(1..10),(1,2)]
			res[,2] = res[,2]*wcontrols[i]
			Scontrols = merge(Scontrols,res[,(1,2)])
// 			Scontrols[(1..10),]

			
			
		}
		
		weights = 1:/rownonmissing(Streat[,2..cols(Streat)]) 
		
		Streat[,2..cols(Streat)] = J(1,cols(Streat)-1,weights):*Streat[,2..cols(Streat)]
// 		Streat
// 		weights
		
// 		Streat = Streat[,1],rowsum(Streat[,2..nTimesTreat])
		res = Scontrols[,1],rowsum(Streat[,2..nTimesTreat]),rowsum(Scontrols[,2..nTimesTreat])
		
		res = res,res[,2]-res[,3]
		mm_matlist(res[,2..4],("%5.4f"),3,strofreal(res[,1],"%9.0g"),("Treated","Controls","Difference"),"t")
		
		
		mm_plot(res[,(4,1)],"line",`"scheme(sj) ytitle(Cumulative incidence) xtitle(time)"')
		
		/*
		mm_plot((*results[1,i])[,(2,3,7)],"line")
		
		size(*results[1,i])
		size(*results[2,i])
		 
		 `RS' min1, min2
		 min1 = min((rows(*results[1,i]),5) )
		 min2 = min((rows(*results[2,i]),5) )
		(*results[1,i])[1..min1 ,]
		(*results[2,i])[1..min2 ,]
		*/
		
		
	 
	
	
	
}
end


mata: results = main2()