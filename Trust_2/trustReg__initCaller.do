mata:
void trustReg::initCaller()
{

		if (extra.nExtraArgs>5)
		{
				_error(3001,"Number of extra arguments greater than 5")
		
		}
		if (extra.nExtraArgs==0) caller  = callf_setup(evaluator,extra.nExtraArgs) // ,a1,a2,a3,a4,a5) 
		else if (extra.nExtraArgs==1) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1) 
		else if (extra.nExtraArgs==2) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1,extra.a2) 
		else if (extra.nExtraArgs==3) caller  = callf_setup(evaluator,extra.nExtraArgs,extra.a1,extra.a2,extra.a3) 

		

}
end
