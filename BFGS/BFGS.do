global pado P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\statprog\stcrmix-pack-src-all\BFGS
// E:\ProjektDB\KORA\Workdata\704752\stcrmixPack\ado
sysdir set PERSONAL $pado
mata: mata mlib index

global root P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\statprog\stcrmix-pack-src-all\BFGS 
// E:\ProjektDB\KORA\Workdata\704752\stcrmixPack\BFGS



clear mata

include $root\rosenbrock.do
include $root\classBFGS.do
include $root\cBFGS__initCaller.do
include $root\cBFGS__Wolfe.do
include $root\cBFGS__zoom.do
// include $root\cBFGS__zoomV2.do
include $root\cBFGS__Interpol.do
include $root\cBFGS__linearSearch.do
// include $root\cBFGS__linearSearchV2.do
include $root\cBFGS__cubicInterpol2.do
// include $root\cBFGS__cubicInterpol2V2.do
include $root\cBFGS__updateInvHessian.do
include $root\cBFGS__mainLoop.do
include $root\cBFGS__BfgsOptimize.do
include $root\cBFGS__BfgsInit.do
include $root\cBFGS__BfgsInit_arguments.do
include $root\cBFGS__BfgsInitWhich.do
include $root\caller.do


mata: mata mlib create lbfgs     , dir($root) replace
mata: mata mlib add    lbfgs *() , dir($root) 
mata: mata mlib index


exit


clear mata
mata:
bfgs = cBFGS()
bfgs.BfgsInit((-1.5,-4)',&rosenbrock())
bfgs.BfgsOptimize()
// bfgs.mainLoop()


end
