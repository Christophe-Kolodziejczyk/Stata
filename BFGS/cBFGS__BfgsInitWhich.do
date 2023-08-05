mata:
void cBFGS::BfgsInitWhich(string scalar which)
{
		which = strtrim(strlower(which))
		which 
		if ( which != "min" & which != "max") _error(3001,"Error in initiating problem: which is min or max!")
		m_which = which
		m_negate = m_which == "max"

}
end
