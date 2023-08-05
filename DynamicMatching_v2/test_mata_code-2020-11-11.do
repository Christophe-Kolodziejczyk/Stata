global DM R:\__econometrie\stata\DynamicMatching
global root $DM

include $root\header.do

global do run
$do $DM\duration-2020-11-11.do
$do $DM\mergeMatrices-v2.do

cap mata: mata drop main2()
mata:
pointer matrix main()
{
	struct duration scalar s, s_dm
	
	
	`RC' timeToTreatment 
	timeToTreatment = st_data(.,"timeToTreatment","last")
	
	s.xvar = "x"
	s.hazvar = "weight"
	
	s._t = &st_data(.,"_t","last")
	s.failure = &st_data(.,"_d","last")
	s.censored = &(!(*s.failure))
	s.cause  = &st_data(.,"trans","last")
	s.by  = &st_data(.,"treated","last")
	s.p_X   = &st_data(.,s.xvar,"last")
	
	s.t = _factor(*s._t)
	s.group = _factor(*s.by)
	s.f = join_factors(s.t,s.group)
	s.failcode = 2
	
	
	s.p_haz = &(s.hazvar !="" ? st_data(.,s.hazvar,"last") : .)
	s.p_w = &(*s.by :* 1 :+ !*s.by:*exp(*s.p_haz):/(1:-exp(*s.p_haz)))
// 	s.p_w = &.
	s.wtype = "iweight"
	

	count(s)
	bias(s)

	`RC' touse, time_treatment, treated
	`RS' nTimesTreat, i 

	s.ftimeTreat = _factor(select(timeToTreatment,*s.by:==1))
	time_treatment = s.ftimeTreat.keys

	nTimesTreat = length(time_treatment)
	s.maxTimeTreat = 2
	
	// keep a copy of the whole structure
	s_dm = s
	

	pointer matrix results
	results = J(2,nTimesTreat,NULL)

// 	timeToTreatment[1..5,]
	
	`RS' maxTimeTreat 
	
	i = 0
	`RC' failure
	failure = *s_dm.failure
	printf("{text}Max Time to Treatment : {res}%9.0g{text}\n",s.maxTimeTreat)
// 	for ( i = 1; i <= nTimesTreat ; i++)
	while (time_treatment[++i] <= s.maxTimeTreat)
	{
		printf("{text}***** Time to treatment = {res}%9.0g{text} *****\n",time_treatment[i])
		
		// at risk the week after treatment
		touse = timeToTreatment:>= time_treatment[i] :& *s_dm._t :> time_treatment[i]  // :| !(*s_dm.by)
		
		(*s_dm._t)       = select(*s_dm._t,touse)
		failure          = select(failure,touse)
		(*s_dm.cause)    = select(*s_dm.cause,touse)
		timeToTreatment  = select(timeToTreatment,touse)
		(*s_dm.by)       = select(*s_dm.by,touse) 
		(*s_dm.p_X)      = select(*s_dm.p_X,touse)
		(*s_dm.p_haz)    = select(*s_dm.p_haz,touse)
		(s_dm.treated)  = &( timeToTreatment:== time_treatment[i] :& *s_dm.by) 
		
		// censored those who have not failed or those in the control group who are treated later but //
		// fail after treatment begins
		// time to censoring is equal to the time where they begin treatment
		
		`RC' laterTreated 
		laterTreated = ( *s_dm.by :& timeToTreatment :> time_treatment[i])
// 		size(laterTreated,"laterTreated")
		
		(*s_dm.censored) = (!failure :| ( laterTreated :& (*s_dm._t) :> timeToTreatment ))
		(*s_dm.failure)  = !*s_dm.censored
		`RC' t, index
// 		s_dm.censored,*s_dm._t
		
		index = selectindex(laterTreated :& (*s_dm._t) :> timeToTreatment)
		t = *s_dm._t
		size(timeToTreatment,"timeToTreatment")
		t[index] = timeToTreatment[index] // J(rows(index),1,timeToTreatment[index])
// 		(t[index],index)[1..10,]
// 		(*s_dm.failure,failure,*s_dm.censored,*s_dm._t,t,timeToTreatment,*s_dm.by,laterTreated)[1..10,.]
// 		exit()
// 		size(t,"t") ; size(index,"index")
		
		
		s_dm.t = _factor(t)
		s_dm.group = _factor(*s_dm.treated)
		s_dm.f = join_factors(s_dm.t,s_dm.group)
		
// 		`RV' index
		`RV' sumWeights 
		
		s_dm.group.panelsetup()
		
		
		
		index = selectindex(!*s_dm.by)
		(*s.p_w) = *s_dm.by :* 1 :+ !*s_dm.by:*(*s.p_haz):/(1:-(*s.p_haz)) //  J(rows(index),1,1) 
		s.wtype = "iweight"
		if (*s.p_w != . )
		{
			sumWeights = aggregate_sum(s_dm.group,s_dm.group.sort(*s.p_w),.,"")
			printf("Sum of weights treatment group ={res} %9.2f {text} \n",sumWeights[2])
			printf("Sum of weights control   group ={res} %9.2f {text} \n",sumWeights[1])
			 
	// 		(*s_dm.p_w)[index] = (*s_dm.p_w)[index]*(sumWeights[2]/sumWeights[1]) 
			printf("After correction\n")
			sumWeights = aggregate_sum(s_dm.group,s_dm.group.sort(*s.p_w),.,"")
			printf("Sum of weights treatment group ={res} %9.2f {text} \n",sumWeights[2])
			printf("Sum of weights control   group ={res} %9.2f {text} \n",sumWeights[1])
	// 		s.p_w = &.
				
		}
		

		s_dm.f.panelsetup()
		size(*s_dm._t)
		
// 		if (*s_dm.p_w !=.) *s_dm.p_w = s_dm.f.sort(*s_dm.p_w) 

		
		count(s_dm)
		
		data = s_dm.n_failed,s_dm.n_censored, s_dm.n_cs ,(s_dm.f).keys,s_dm.counts

		`RC' N0, N1 , k
		k = cols(data)
		
		N0 = sum(select(data[,k],data[,k-1]:==0))
		N1 = sum(select(data[,k],data[,k-1]:==1))
		
// 		data[1..5,.]
// 		exit()
		
		
		printf("{text}N treated = {res}%9.0g{text}, N controls = {res}%9.0g{text}\n",N1, N0)
		printf("{text}Controls\n")
		results[1,i] = &m_cif2( select(data,data[,cols(data)-1]:==0))
		printf("{text}Treated\n")
		results[2,i] = &m_cif2( select(data,data[,cols(data)-1]:==1))
		
		bias(s_dm)
		
	}
	
// 	exit()
	
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
			
			
			Streat = merge(Streat,res[,(1,3)])
			res[,2] = res[,2]*wcontrols[i]
			Scontrols = merge(Scontrols,res[,(1,2)])
			
			
		}
		
		weights = 1:/rownonmissing(Streat[,2..cols(Streat)]) 
		
		Streat[,2..cols(Streat)] = J(1,cols(Streat)-1,weights):*Streat[,2..cols(Streat)]
		res = Scontrols[,1],rowsum(Streat[,2..nTimesTreat]),rowsum(Scontrols[,2..nTimesTreat])		
		res = res,res[,2]-res[,3]
		
		
		mm_matlist(res[,2..4],("%5.4f"),3,strofreal(res[,1],"%9.0g"),("Treated","Controls","Difference"),"t")
		mm_plot(res[,(4,1)],"line",`"scheme(sj) ytitle(Cumulative incidence) xtitle(time)"')
	
	
	
}
end


mata: results = main()