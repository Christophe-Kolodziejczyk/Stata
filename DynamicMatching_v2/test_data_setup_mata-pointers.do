mata:

	timeTreat = 1
	cs_code = 2
	
	rawdata = st_data(.,"id _t _d trans","_st")
	id   = &rawdata[,1]
	_t   = &rawdata[,2]
	_d   = &rawdata[,3]
	trans = &rawdata[,4]
	_cs = &( *trans :== cs_code) 
	
	selIndex = 1..10
	
	rawdata[selIndex,]
	(*id)[selIndex,]
	
	rawdata=select(rawdata,*trans:==1)
	rawdata[selIndex,]
	(*id)[selIndex,]
	
	
	
	
end
exit
	
	id = st_data(.,"id","_st")
	_t = st_data(.,"_t","_st")
	_d = st_data(.,"_d","_st")
	trans = st_data(.,"trans","_st")
	_cs = trans:==cs_code
	
	f_id = _factor(id)
	f_id.panelsetup()
	
	lastIndex = aggregate_last(f_id,1::rows(id),.,"")
	
	lastIndex[1..5,]
	data= id,_t,_d,trans,_cs
	
	data[1..lastIndex[1],]
	(data[lastIndex,])[1,]
	
	// select observations which fail AFTER treatment
	treat = aggregate_sum(f_id,_t :== timeTreat :& trans:==1,.,"")
	laterTreated = aggregate_sum(f_id, _t:*(_t:> timeTreat :& trans :==1),.,"")
	
	(treat,laterTreated,data[lastIndex,.])[1..33,]
	

	t = _t[lastIndex]
	failure = _d[lastIndex] 
	cs = _cs[lastIndex]
	
	index_laterTreated = selectindex(lateTreated)
	
	nLaterTreated = rows(index_laterTreated)
	failure[index_laterTreated] = J(nLaterTreated,1,0)
	t[index_laterTreated] = laterTreated
	
	f_time  = _factor(_t[lastIndex])
	f_treat = _factor(treat)
	f = join_factors(f_time, f_treat)
	
	weights = . ; wtype = ""
	
	
	
	
	n_failed   = aggregate_sum(f,(f).sort(failure),weights,wtype)
	n_censored = aggregate_sum(f,(f).sort(!failure),weights,wtype)
	n_cs       = aggregate_sum(f,f.sort(cs),weights,wtype)
	counts     = wtype !="" ? aggregate_count(f,f.sort(failure),weights,wtype) : (f).counts
	
	data = n_failed,n_censored,n_cs ,f.keys,counts
	
	data[1..10,]
	
	m_cif2( select(data,data[,cols(data)-1]:==0))
	m_cif2( select(data,data[,cols(data)-1]:==1))
// 	(data[selectindex(treat:>0),])[1..10,]
	
	



end

br id _t _d trans inProg if _st
  
