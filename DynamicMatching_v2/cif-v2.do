cap mata: mata drop st_cif()
cap mata: mata drop m_cif()
cap mata: mata drop cif_sendToStata() 
mata:
pointer vector st_cif(string scalar causevar,
                real   scalar failcode,
				string scalar touse,
				string scalar by,
				string scalar weight,
				string scalar wtype)
{ 

		class Factor scalar F, Fby

		f = st_data(.,"_d",touse)
		t = st_data(.,"_t",touse)
		c = st_data(.,causevar,touse)
		w = weight != "" ? st_data(.,weight,touse) : .

		F = factor("_t",touse)
		if (by != "") 
		{
				
				Fby = factor(by,touse)
				F = factor("_t "+by,touse)
		}
		Nby = by !="" ? rows(Fby.keys) : 0
// 		Nby
		F.panelsetup()
		
		sum(w)
		wtype
		
		p_w = &(weight != "" ? F.sort(w) : .)
		sum_fail = aggregate_sum(F,F.sort(f):==1,*p_w,wtype)
		sum_cens = aggregate_sum(F,F.sort(f):==0,*p_w,wtype)
		sum_cs   = aggregate_sum(F,F.sort(c):==failcode,*p_w,wtype)
		counts   = wtype !="" ? aggregate_count(F,F.sort(f),*p_w,wtype) : F.counts 
			
			
		
		
		printf("# of subjects %12.0g \n",sum(F.counts))
		temp = sum_fail,sum_cens,sum_cs,F.keys,counts
		colsum(temp)
		
		k = cols(temp)
// 		Fby.keys
// 		N = wtype !="" ? 
		N = sum(counts)  // : sum(F.counts)
		nr = rows(F.counts)
		
		
		if (Nby > 0 ) {
				_sort(temp,(k-2,k-1))
				data = J(1,Nby,NULL)
				for ( i = 1 ; i <= Nby ; i++) data[i] = &m_cif(select(temp,F.keys[,2]:==Fby.keys[i]))
						
		}
		else 
		{
				_sort(temp,k-1)
				data = &m_cif(temp) // , N, nr)
		}
		
		values = Nby > 0 ? Fby.keys : .
		cif_sendToStata(data,values)
		
		return(data)
}

real matrix m_cif(real matrix temp) 
{
		
// 		temp = F.keys,F.counts,sum_fail,sum_cens,sum_cs
// temp[1..10,]
// N,nr
// temp[1::20,]
		printf("Computing incidence function \n")
		N = sum(temp[,cols(temp)])
		printf("Number of subjects:%12.0g\n",N)
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
		/*
		for (i = 1 ; i <= nr ; i++)
		{
			S_cs[i,1] = (Nrisk - Ncs[i,1])/Nrisk
			S[i,1]    = (Nrisk - Nf[i,1])/Nrisk
			NR[i,1]   = Nrisk
			Nrisk     = Nrisk - Nc[i,1] - Nf[i,1]
			
		}
		*/

		S = exp(runningsum(ln(S[,1])))
		S_cs = exp(runningsum(ln(S_cs[,1])))
		Stm1 = 1\S[1..rows(S)-1]
		fails = Ncs:/NR
		I = runningsum(Stm1:*fails)
// 		printf("ok\n")
// 		Ij_Ialpha = I - runningsum(I)
		 
		// Variance of I
		printf("Computing variance of incidence function \n")
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
		
// 		printf("ok\n")
		data = Ncs,1:-S_cs,I,temp[,4],CIF_lo,CIF_up,sqrt(var) // uniqrows((S,temp[,1]))
		
		
// 		mata:  mm_plot(data[,2..4],"line") // ,"ylabel(0(0.02)0.06)")

		return(data)
}

void cif_sendToStata(pointer vector data, 
                     real    vector values)
{
		
		real scalar k , i
		real vector ind
		string vector varl
		k = length(data)
		varl = "cif_km","cif","t","cif_lo","cif_up","cif_se"
		
		st_local("levels",invtokens(strofreal(values')))
		ind  = 2..7
		
		for (i = 1 ; i <= k ; i++)
		{
				string scalar val
				string vector varn
				real vector indr
				
				val  = values ==. ? ""   : strofreal(values[i])
				varn = values ==. ? varl : varl:+"_" :+ val
				
				
				stata("cap drop "+invtokens(varn))
				st_global("var_"+val,invtokens(varn))
				(void) st_addvar("double",varn)
				
				
				indr = (1,rows(*data[i]))
				st_store(indr,varn,(*data[i])[,ind])
		}
		
}


end
