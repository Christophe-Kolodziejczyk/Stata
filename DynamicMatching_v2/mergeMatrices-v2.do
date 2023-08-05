include $root\header.do
local TM transmorphic matrix
cap mata: mata drop marray()
cap mata:mata drop merge()
mata:
transmorphic matrix marray(transmorphic matrix A,
                           transmorphic matrix B)
{
	transmorphic matrix C
	transmorphic matrix values, indexA, indexB
	
	real scalar i , j , k, n, m, ca, cb , p 
	
	values = uniqrows(A\B)
// 	values
	

	m = rows(A); n = rows(B)
	
	i = j = k = 1
	 
	indexA = J(rows(A),1,.)
	indexB = J(rows(B),1,.)
	
// 	"loop"
	while (i <= m & j <= n ) {

		if (A[i] < B[j])
		{
			
// 			"case 1"
			indexA[i++] = k++
		}
		else if (A[i] == B[j]) 
		{
// 			"case 2"
			indexA[i++] = k
			indexB[j++] = k++
		}
		else 
		{
// 			"case 3"
			indexB[j++] = k++	
		}
		
		
	}

// 	i,j,k
	
	if ( i <= m )
	{
		for (p = i ; p <= m ; p++) indexA[p] = k++
	}
	else 
	{
		for (p = j ; p <= n ; p++) indexB[p] = k++
	}
// 	indexA
// 	indexB
	
	return( (&indexA,&indexB, &(k-1)) )
	
}

transmorphic matrix merge(`TM' A,
                          `TM' B)
{
	`TM' index, C
	index = marray(A[,1],B[,1])
	
	C =J(*index[3],cols(A)+cols(B) - 1, .)
	
	/*
	*index[1]
	*index[2]
	*index[3]
	*/
	C[*index[1],1..cols(A)] = A
	C[*index[2],1] = B[,1]
	C[*index[2],cols(A) + 1 .. cols(A) + cols(B) -1] = B[,2..cols(B)]
	

	return(C)
	
	
}
end


mata:

a = (1,2,3)'
b = (1,3,4)'

marray(a,b)

a = (1,1\2,1\3,1)
// a = (1,2,3)'
b = (1,2\3,2\4,2)
a
b
merge(a,b)




end