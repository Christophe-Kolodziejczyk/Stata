sysdir set PLUS C:\Users\B058718\ado\plus
global DM R:\__econometrie\stata\DynamicMatching
global DM C:\Users\B058718\DynamicMatching
global root $DM

// clear mata
// include $root\Build_MataCode.do
include $root\header.do
di "`SDS'"
di "`cFs'"



mata:
void main()
{
	
	`SDS' s, s_0
	
	s.xvar = "x"
	s.weightData = 1 ; s.wtype = "iweight"
	getData(s)
	
	s_0 = s
	
	`RS' i, maxT_treat
	`RV' timesToTreatment, pTreatment, nTreated
	`PM' results
	`cFs' f_tTreat
	
	
	maxT_treat = 10
	f_tTreat = _factor( select(*s_0._t,*s_0.treat:==1) )
// 	f_tTreat.keys,f_tTreat.counts

	
	timesToTreatment = f_tTreat.keys[1::maxT_treat]
	nTreated = f_tTreat.counts[1::maxT_treat]
	
	pTreatment = nTreated/sum(nTreated)
	
	printf("Distribution of treatment times\n")
	`RC' prob 
	prob = (pTreatment*100)
	prob = prob\sum(prob)
	mm_matlist( (prob),("%4.2f") , 3, strofreal(timesToTreatment,"%4.0f")\"Total" ,
	"Share","t") 

// 	weights(s_0,timesToTreatment)
// 	exit()
	results = J(2,length(timesToTreatment),NULL)
	
	`RC' touse
	`RM' bias
	`SV' vnames
	
	
	for ( i = 1; i <= maxT_treat ; i++)
	{
		`RS' tTreat
		tTreat =  timesToTreatment[i]
		
		printf("{text}Time to treatment:  {res}%9.0g{text}\n",tTreat)
		touse = *s._t :>= tTreat
		selectData(s,touse)
		prepareData(s,tTreat)
		
		if (s.p_X!=NULL & s.weightData)
		{
			
			touse = *s._t:==tTreat
			
			k = cols(*s.p_X)
			printf("{res}Computing weights{text}\n")
			data    = (s.group).sort(select(*s.p_X, touse))
			s.p_haz = &logitreg(*s.treated,data)
			if (s.weightData) data  = (s.group).sort( (data,*s.p_haz))
			
			printf("{hline 80}\n")
			computeWeights(s)
			weights = s.weightData ? *s.p_w : .	
			
		}
		
		results[,i] = computeCIFs(s,tTreat)
		
		
		bias = bias2(s.group,data,weights,s.wtype) // doesn't work , bias should come first , routine fo rcomputing the weights and determining the sample
		printf("\n{text}Standardized differences\n")
		vnames = s.weightData ? (s.xvar,"p") : s.xvar
		mm_matlist(bias,"%12.3f", 3,vnames,("means treated","means controls","Dif.","Bias"))
		printf("{text}N treated = {res}%12.0g {text}, N controls = {res}%12.0g \n",s.group.counts[2],s.group.counts[1])
	}
	
	outputResults(results,timesToTreatment,pTreatment)
	
}


void outputResults(`PM' results,
                   `RM' timesToTreatment,
				   `RV' pTreatment)
{
	
	`RV' res1, res2, index
	`RM' res, ATET
	`RS' i, k
	
	i = 1
	index = (7,3)
	k = cols(results)
	
	for (i = 1; i <= k ; i++)
	{
		
		printf("time to treatment: %9.0g\n",timesToTreatment[i])
		
		
		if (results[1,i] !=NULL & results[2,i]!=NULL)
		{
			res2 = (*results[1,i])[,index] // controls
			res1 = (*results[2,i])[,index] // treated
		
			res = merge(res1,res2)
			res[1,] = editmissing(res[1,],0)
			res[,1] = res[,1]:-timesToTreatment[i]
			_lagMissing(res)
			
			// t, F treated, F controls, Difference
			res = res,res[,2]-res[,3]
			
			
			mm_matlist(res[,2..4],("%5.4f"),3,strofreal(res[,1],"%9.0g"),("Treated","Controls","Difference"),"t")
		}
		else printf("{err}No results!{text}\n")
		
		if (i == 1) ATET = res[,1],res[,4]*pTreatment[i]
		else        ATET = merge(ATET, (res[,1],res[,4]*pTreatment[i]))
		
			
	}
	
	ATET = select(ATET,rowmissing(ATET):==0)
	
	// ATET[,1],rowsum(ATET[,2..cols(ATET)])
	time = strofreal(ATET[,1])
	ATET = rowsum(ATET[,2..cols(ATET)])
	mm_matlist(ATET,"%5.4f",3,time,("ATET"),"t")
	
	
}

void  getData(`SDS' s)
{
	
	s.id      = &st_data(.,"id","_st")
	s._t      = &st_data(.,"_t","_st")
	s.failure = &st_data(.,"_d","_st")
	s.trans   = &st_data(.,"cause","_st")
	s.treat   = &st_data(.,"failureS","_st")
	s.failcode = 2
	s._cs =  &((*s.trans):==s.failcode)
	if (s.xvar !="") s.p_X = &st_data(.,s.xvar,"_st")

	
}

void selectData(`SDS' s,
                `RC' touse)
{
	
		printf("{res}Selecting data{text}!\n")
// 		s.id,s._t,s.failure,s.trans,s._csd
		
		*s.id = select(*s.id,touse)
		*s._t = select(*s._t,touse)
		*s.failure = select(*s.failure,touse)
		*s.trans = select(*s.trans,touse)
		*s.treat = select(*s.treat,touse)
		s._cs = &((*s.trans):==s.failcode)
// 		s.p_X
		if (s.p_X != NULL) *s.p_X = select(*s.p_X,touse)
		
		/* size(*s.id,"*s.id")
		size(*s._t,"*s._t")
		size(*s.failure,"*s.failure")
		size(*s.trans,"*s.trans")
		size(*s.treat,"*s.treat")
		size(*s._cs,"*s._cs")*/
	
}


void prepareData(`SDS' s,
                 `RS' timeTreat)
{
	
	printf("{res}Preparing data{text}\n")
	s.f_id = _factor(*s.id)
	s.f_id.panelsetup()
	
	`RV' laterTreated, index_laterTreated, lastIndex, cs
	`RV' weights
	`SS' wtype
	`PV' results

	s.f_id = _factor(*s.id)
	s.f_id.panelsetup()	
	// select observations which fail AFTER treatment
	s.treated = &aggregate_sum(s.f_id, (*s._t) :== timeTreat :& (*s.treat):==1,.,"")
	
	s.group = _factor(*s.treated)

	
}

`PV' computeCIFs(`SDS' s,
				 `RS' timeTreat)
{

	`RV' laterTreated, index_laterTreated, lastIndex, cs
	`RV' weights
	`SS' wtype
	`PV' results
	
	
	lastIndex = aggregate_last(s.f_id,1::rows(*s.id),.,"")
	// find laterTreated , censor them at time of start of their treatment
	laterTreated = aggregate_sum(s.f_id, (*s._t):*( *s._t:>timeTreat :& *s.trans:==1),.,"")
	t = (*s._t)[lastIndex]
	failure = (*s.failure)[lastIndex] 
	cs = (*s._cs)[lastIndex]
	index_laterTreated = selectindex(laterTreated:>0)
	
	nLaterTreated = rows(index_laterTreated)
	failure[index_laterTreated] = J(nLaterTreated,1,0)
	t[index_laterTreated] = laterTreated[index_laterTreated]
	cs[index_laterTreated] = J(nLaterTreated,1,0)
	
	`cFs' f_time , f_treat, f
	s.t  = _factor(t)
// 	s.group = _factor(treat)
	s.f = join_factors(s.t , s.group)
	s.f.panelsetup()
	
	weights = . ; wtype = ""
	
	s.n_failed   = aggregate_sum(s.f,s.f.sort(failure),weights,wtype)
	s.n_censored = aggregate_sum(s.f,s.f.sort(!failure),weights,wtype)
	s.n_cs       = aggregate_sum(s.f,s.f.sort(cs),weights,wtype)
	s.counts     = wtype !="" ? aggregate_count(s.f,s.f.sort(failure),weights,wtype) : s.f.counts
	
	data = s.n_failed,s.n_censored, s.n_cs , s.f.keys,s.counts	
	results = J(2,1,NULL)
	
	printf("Control group\n")
	results[1] = &m_cif2( select(data,data[,cols(data)-1]:==0)) // controls
	printf("Treatment group\n")
	results[2] = &m_cif2( select(data,data[,cols(data)-1]:==1)) // treated
	
	return(results)
	
}

struct outputWeights {
	
	`RC' treat, weights
	
	
	
}

void weights(`SDS' s,
             `RV' timesToTreatment)
{
	
	`RC' treat, indexTimeTreated, weights, touse
	`RS' i, nTreatments
	`RM' X
	`RC' res
	
	
	printf("weigths for the whole sample \n")
	weights = J(rows(*s.p_X),1,.) 
	
	
	k = length(timesToTreatment)
	for (i = 1 ; i <= k ; i++)
	{
		s._t
		 printf("time to treatment = %2.0f\n",timesToTreatment[i])
		 touse = *s._t :== timesToTreatment[i]
		 treat = select(*s.treat:==1,touse)
		 X = select(*s.p_X, touse)
		 indexTimeTreated = selectindex(touse)
		 res = logitreg(treat,X)
		 weights[indexTimeTreated] = treat:*1 :+ !treat:*res
	}
	
	
	(*s.id,*s._t,*s.failure,*s.treat,weights)[1::20,]
	
	
}

	
main()
// 	(data[selectindex(treat:>0),])[1..10,]
	
	



end

br id _t _d trans inProg if _st
  
