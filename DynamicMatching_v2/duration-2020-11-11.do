include "$root\header.do"

clear mata
mata:
struct duration {
	
	`cFs' f, t, group, ftimeTreat
	`RC' n_failed, n_censored, n_cs, counts, maxTimeTreat
	
	`SS' xvar, hazvar, wtype
	
	`PS' _t, failure, censored, cause, by, p_haz, p_w, p_X, treated
	
	`RS' failcode
	
	
	
}

void count(`SDS' s)
{
	`PS' p_w
	`SS' wtype 
	`RM' temp, counts
	`RV' weights
	
	
	
	(s.f).panelsetup()
	weights = (*s.p_w != . ? s.f.sort(*s.p_w) : .)  


	s.n_failed = aggregate_sum(s.f,(s.f).sort(*s.failure):==1,weights,s.wtype)
	s.n_censored = aggregate_sum(s.f,(s.f).sort(*s.failure):==0,weights,s.wtype)
	s.n_cs   = aggregate_sum(s.f,(s.f).sort(*s.cause):==s.failcode,weights,s.wtype)
	s.counts   = s.wtype !="" ? aggregate_count((s.f),s.f.sort(*s.failure),weights,s.wtype) : (s.f).counts 
		
	printf("# of subjects = {res}%12.0g {text}\n",sum((s.f).counts))
	
	
// 	return(temp)
	
}

real matrix m_cif(`SDS' s) 
{
		`RC' S, S_cs, Stm1, fails, I
		`RC' var1, var2, var3
		
		
		printf("{text}Computing incidence function \n")
		N = sum(s.counts)
		printf("{text}Number of subjects: {res}%12.0g{text}\n",N)
		nr = rows(s.counts)
		S = S_cs = NR = J(nr,1,.)
		Nrisk = N
// 		Nc = temp[,2] 
// 		Nf = temp[,1] 
// 		Ncs = temp[,3]
		Nlost = 0\runningsum(s.n_censored+s.n_failed)
		NR = N:-Nlost[1..rows(Nlost)-1]
		S_cs = (NR:-s.n_cs):/NR
		S    = (NR:-s.n_failed):/NR

		S = exp(runningsum(ln(S[,1])))
		S_cs = exp(runningsum(ln(S_cs[,1])))
		Stm1 = 1\S[1..rows(S)-1]
		fails = s.n_cs:/NR
		I = runningsum(Stm1:*fails)

		// Variance of I
		printf("{text}Computing variance of incidence function \n")
		nr = rows(I)
		var1 = var3 = J(nr,1,.)
		a = s.n_cs:/(NR:*(NR:-s.n_cs))
		b = s.n_cs:/(NR:^2)
		var2 = runningsum(S_cs:*(b):*Stm1:^2)

		`RS' i, alpha, c_a
		`RC' ind, c, CIF_up, CIF_lo, se, num
		`RM' data
		
		for (i = 1 ; i <= nr ; i++ )
		{
				ind = 1::i
				c = I[i]:-I[ind] 
				var1[i] = sum( (c:^2):*a[ind] )  
				var3[i] = sum( c:*Stm1[ind]:*b[ind] )

		}
		
		var = var1 + var2 - 2*var3
		
		alpha = 0.05
		c_a = invnormal(1-alpha/2)
		se = sqrt(var)
		num = I :*ln(I)
		CIF_lo =  I:^exp(-c_a*se:/num)
		CIF_up =  I:^exp(c_a*se:/num)
		
// 		"ok"
		size(S_cs)
		size(CIF_up)
		size(s.f.keys)
		data = s.n_cs,1:-S_cs,I,CIF_lo,CIF_up,se,(s.f.keys) // uniqrows((S,temp[,1]))
		
		
// 		mata:  mm_plot(data[,2..4],"line") // ,"ylabel(0(0.02)0.06)")

		return(data)
}

void size(transmorphic matrix X,|string scalar text)
{
	if (args()==2) printf("{text}%s\n",text)
	
	printf("{text}# of rows {res}%9.0g{text}, # of columns {res}%9.0g{text}\n",rows(X),cols(X))
	
}

real matrix m_cif2(real matrix temp) 
{
		
		`RC' S, S_cs, Stm1, fails, I
		`RC' var1, var2, var3
		`RS' i, alpha, c_a
		`RC' ind, c, CIF_up, CIF_lo, se, num
		`RM' data, testFail
		
		testFail = colsum(temp)
		
		temp[1..5,]
// 		mm_matlist(testFail)
		
		printf("{text}Number of failures = {res}%9.0g{text}, Number of failures with main cause = {res}%9.0g{text}\n",testFail[1],testFail[3])
		printf("{text}Number of censored spells = {res}%9.0g{text}\n",testFail[2])
		if (testFail[,1]==0|testFail[,3]==0)
		{
				printf("No failures\n")
				return(.)
		}
	    
	 
		printf("{text}Computing incidence function \n")
		N = sum(temp[,cols(temp)])
		printf("{text}Number of subjects = {res}%12.0g{text}\n",N)
		nr = rows(temp)
		S = S_cs = NR = J(nr,1,.)
		Nrisk = N
		Nc = temp[,2] 
		Nf = temp[,1] 
		Ncs = temp[,3]
		Nlost = 0\runningsum(Nc+Nf)
		NR = N:-Nlost[1.. rows(Nlost)-1]
		S_cs = (NR:-Ncs):/NR
		S    = (NR:-Nf):/NR

// 		size(S,"S")
		S = exp(runningsum(ln(S[,1])))
		S_cs = exp(runningsum(ln(S_cs[,1])))
		Stm1 = 1\S[1..rows(S)-1]
		fails = Ncs:/NR
		I = runningsum(Stm1:*fails)

		 
		// Variance of I
		printf("{text}Computing variance of incidence function \n")
		nr = rows(I)
		var1 = var3 = J(nr,1,.)
		a = Ncs:/(NR:*(NR:-Ncs))
		b = Ncs:/(NR:^2)
		var2 = runningsum(S_cs:*(b):*Stm1:^2)

// 		rI = runningsum(I)
// 		c  = (1::nr):*I-rI
		for (i = 1 ; i <= nr ; i++ )
		{
				ind = 1::i
				c = I[i]:-I[ind] 
				var1[i] = sum( (c:^2):*a[ind] )  
				var3[i] = sum( c:*Stm1[ind]:*b[ind] )

		}
		
		var = var1 + var2 - 2*var3
		
		alpha = 0.05
		c_a = invnormal(1-alpha/2)
		se = sqrt(var)
		num = I :*ln(I)
		CIF_lo =  I:^exp(-c_a*se:/num)
		CIF_up =  I:^exp(c_a*se:/num)
		
		data = Ncs,1:-S_cs,I,CIF_lo,CIF_up,se,temp[,4] // uniqrows((S,temp[,1]))
		
		return(data)
}

void _lagMissing(`RM' A)
{
	`RS' r,c, i ,j
	r = rows(A) ; c= cols(A)
	
	for (j = 1; j <= c ; j++)
	{
		
		for (i = 2; i <= r ; i++)
		{
			if (missing(A[i,j])) A[i,j] = A[i-1,j]
		}
		
	}
	
	
}

void bias(`SDS' s)
{
	`RM' means, sd, data
	`RC' i , k 
	`RV' weights
	
	k = cols(*s.p_X)
	
	s.group.panelsetup()
	data = (s.group).sort(*s.p_X)
	
	means = sd = J(s.group.num_levels,k,.)
	
// 	if (*s.p_w !=.) 
	weights = (*s.p_w != . ? s.group.sort(*s.p_w) : .)  
	
	//renormalize the weights
	if (*s.p_w != .)
	{
		
		`RM' sumWeights
		
		sumWeights = aggregate_sum(s.group,weights,.,"")
// 		s.group.keys,s.group.counts,sumWeights  
		printf("{text}Sum of weights treatment group ={res} %9.2f {text} \n",sumWeights[2])
		printf("{text}Sum of weights control   group ={res} %9.2f {text} \n",sumWeights[1])
	}
	
	for ( i = 1 ; i <= k ; i++)
	{
		means[,i] = aggregate_mean(s.group,data[,i],weights,s.wtype)
		sd[,i]    = aggregate_sd(s.group,data[,i],.,"") // aggregate_sd(s.group,data[,i],*s.p_w,s.wtype)
		
	}
	
// 	s.group.keys,s.group.counts,means,sd
	
	`RV' m1, m0, sd1, sd0, dif, bias
	
	m1 = select(means,s.group.keys:==1)
	m0 = select(means,s.group.keys:==0)
	sd1 = select(sd  , s.group.keys:==1)
	sd0 = select(sd  , s.group.keys:==0)
	dif = (m1 - m0)
	bias = 100*dif:/sqrt(0.5*(sd1:+sd0))
	
	printf("\n{text}Standardized differences\n")
	mm_matlist((m1\m0\dif\bias)',"%12.3f", 3,s.xvar,("means treated","means controls","Dif.","Bias"))
	printf("{text}N treated = {res}%12.0g {text}, N controls = {res}%12.0g \n",s.group.counts[2],s.group.counts[1])
	
}



end