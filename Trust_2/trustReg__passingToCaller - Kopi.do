mata:
void trustReg::passingToCaller(todo,p,f,grad,B)
{
		
// 		printf("# of extra arguments = %g\n",extra.nExtraArgs)

		callf(caller,todo,p,f,grad,B)
		
		f = sum(f,1)
		grad = colsum(grad,1)
// 		if (extra.nExtraArgs==0) callf(caller,todo,p,f,grad,B)
// 		else if (extra.nExtraArgs==1) callf(caller,todo,f,grad,B)
// 		else if (extra.nExtraArgs==2) callf(caller,todo,p,extra.a1,extra.a2,f,grad,B)
// 		else if (extra.nExtraArgs==3) callf(caller,todo,p,extra.a1,extra.a2,extra.a3,f,grad,B)
}

end
