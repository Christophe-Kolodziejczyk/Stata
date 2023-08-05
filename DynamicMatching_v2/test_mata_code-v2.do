global DM R:\__econometrie\stata\DynamicMatching

do $DM\duration.do
do $DM\mergeMatrices-v2.do

cap mata: mata drop main2()
mata:
void main2()
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
	class Factor scalar ftimeTreat
	ftimeTreat = _factor(select(timeToTreatment,*s.by:==1))
	time_treatment = ftimeTreat.keys
	time_treatment,ftimeTreat.counts
	
// 	time_treatment = uniqrows(select(timeToTreatment,*s.by:==1))
	nTimesTreat = 1 // length(time_treatment)
	
	// keep a copy of the whole structure
	s_dm = s
	
	"ok"
	pointer matrix results
	results = J(2,nTimesTreat,NULL)
	nTimesTreat 
	time_treatment
	timeToTreatment[1..5,]
	
	
	
	for ( i = 1; i <= nTimesTreat ; i++)
	{
		i
		printf("Time to treatment %9.0g\n",time_treatment[i])
		
		// at risk the week after treatment
		touse = timeToTreatment:>= time_treatment[i] :& *s_dm._t :> time_treatment[i]  // :| !(*s_dm.by)
		rows(touse)
		
		*s_dm._t     = select(*s_dm._t,touse)
		*s_dm.failure = select(*s_dm.failure,touse)
		*s_dm.censored = (!(*s_dm.failure))
		*s_dm.cause = select(*s_dm.cause,touse)
		timeToTreatment = select(timeToTreatment,touse)
		treated
		*s_dm.by    = select(*s_dm.by,touse)  
		
		s_dm.t = _factor(*s_dm._t)
		s_dm.group = _factor(timeToTreatment:== time_treatment[i] :& *s_dm.by )
		s_dm.f = join_factors(s_dm.t,s_dm.group)
		
		count(s_dm)
		data = s_dm.n_failed,s_dm.n_censored, s_dm.n_cs ,(s_dm.f).keys,s_dm.counts
		
		`RC' N0, N1 , k
		k = cols(data)
		
		N0 = sum(select(data[,k],data[,k-1]:==0))
		N1 = sum(select(data[,k],data[,k-1]:==1))
		
		printf("N treated = %9.0g, N controls = %9.0g\n",N1, N0)
	
// 		s_dm.f.keys
// 		"colmin"
// 		colmin(select(data,data[,cols(data)-1]:==0))
// 		colmin(select(data,data[,cols(data)-1]:==1))
		results[1,i] = &m_cif2( select(data,data[,cols(data)-1]:==0))
		results[2,i] = &m_cif2( select(data,data[,cols(data)-1]:==1))
		
	
		// column 3 : CIF, column 7: time
		`RM' index
		index = (7,3)
		res1 = (*results[1,i])[,index]
		res2 = (*results[2,i])[,index]
		
		res = merge(res1,res2)
		res[1,] = editmissing(res[1,],0)		
		_lagMissing(res)
		
		res,res[,3]-res[,2]
		
		
	
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
	 
	
	
	
}
end


mata:main2()