global root E:\ProjektDB\KORA\Workdata\704752\stcrmix
global pado $root\ado
// include "$root\CRSetUp.do"
// di "$pado"

sysdir set PERSONAL $pado\
adopath ++ $pado

clear mata
mata:
class prout {

		real scalar m_x 
		void pouet()
		void new()

}

void prout::new()
{
		m_x = 0
}
void prout::pouet()
{
		"pouet pouet"
}
end

local libname lprout
mata:
mata mlib create `libname' , replace dir(PERSONAL)
mata mlib add `libname' *() , dir(PERSONAL) complete
mata mlib index
mata describe using `libname'
end

clear mata
mata:
S = prout()
S.pouet()


end
erase $pado\\`libname'.mlib
