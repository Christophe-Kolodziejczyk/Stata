cap mata: mata drop merge()
mata:
transmorphic matrix merge(transmorphic matrix A,
                          transmorphic matrix B)
{
	transmorphic matrix C
	transmorphic matrix values
	
	real scalar i , j , k, n, m, ca, cb , p 
	
	values = uniqrows(A[,1]\B[,1])
	values
	
	ca = cols(A); cb = cols(B)
	C = J(rows(values), ca + cb - 1 , .)
	
	m = rows(A); n = rows(B)
	
	i = j = k = 1
	
	A
	B 
	
	"loop"
	while (i < m & j < n ) {
		"index"
		i,j,k
		if (A[i,1] < B[j,1])
		{
			
			"case 1"
			A[i,],B[j,]
			C[k,1..ca] = A[i,] 
			i++
		}
		else if (A[i,1] == B[j,1]) 
		{
			"case 2"
			A[i,],B[j,2..cb]
			C[k,] = A[i,],B[j,2..cb]
			i++ ; j++
		}
		else 
		{
			"case 3"
			C[k,1] = B[j,1]
			ca+1..ca+cb-1
			B[j,2..cb]
			C[k,ca + 1 .. ca + cb -1] = B[j,2..cb]
			j++
			
		}
		k++
		
	}
	"finish"
	C
	
	i,m 
	j,n 
	k 
	
	if (i < m  )
	{
		for ( p = i ; p <=m ; p++)
		{
			
			C[k,1..ca] = A[p,1..ca]
		}
		
	}
	else
	{
		for ( p = i ; p <=m ; p++)
		{
			C[k,1] = B[p,1]
			C[k,ca + 1 .. ca + cb -1] = B[p,2..cb]
		}
		
	}
	
	C
	return(C)
	
}
end


mata:

a = (1,1\2,1\3,1)
b = (1,2\3,2)

merge(a,b)


end