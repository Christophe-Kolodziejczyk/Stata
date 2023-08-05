mata:
real scalar isEmpty(transmorphic matrix a) 
{
		real scalar d
		d = (rows(a)==0|cols(a)==0)

		return( d )
}
void initExtraArgs(struct extraArgs scalar extra)
{
		extra.a1 = J(0,0,.)
		extra.a2 = J(0,0,.)
		extra.a3 = J(0,0,.)
}

void countExtraArgs(struct extraArgs scalar extra)
{
	
		extra.nExtraArgs = 0
		if (isEmpty(extra.a1)==0) extra.nExtraArgs = extra.nExtraArgs + 1
		if (isEmpty(extra.a2)==0) extra.nExtraArgs = extra.nExtraArgs + 1
		if (isEmpty(extra.a3)==0) extra.nExtraArgs = extra.nExtraArgs + 1
}
end
