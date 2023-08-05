global pado $root\ado
sysdir set PERSONAL $pado
mata: mata mlib index

global bfgs $root // \BFGS



clear mata

include $bfgs\rosenbrock.do
include $bfgs\classBFGS.do
include $bfgs\cBFGS__initCaller.do
include $bfgs\cBFGS__Wolfe.do

include $bfgs\cBFGS__Interpol.do
// include $bfgs\cBFGS__linearSearch.do
// include $bfgs\cBFGS__linearSearchV2.do
include $bfgs\cBFGS__linearSearchV3.do
// include $bfgs\cBFGS__zoom.do
// include $bfgs\cBFGS__zoomV2.do
include $bfgs\cBFGS__zoomV3.do
// include $bfgs\cBFGS__cubicInterpol2.do
include $bfgs\cBFGS__cubicInterpol2V2.do

include $bfgs\cBFGS__updateInvHessian.do
include $bfgs\cBFGS__mainLoop.do
include $bfgs\cBFGS__BfgsOptimize.do
include $bfgs\cBFGS__BfgsInit.do
include $bfgs\cBFGS__BfgsInit_arguments.do
include $bfgs\cBFGS__BfgsInitWhich.do
include $bfgs\caller.do
mata: mata mlib create lbfgs     , dir($pado) replace
mata: mata mlib add    lbfgs *() , dir($pado) 
mata: mata mlib index


exit


clear mata
mata:
bfgs = cBFGS()
bfgs.BfgsInit((-1.5,-4)',&rosenbrock())
bfgs.BfgsOptimize()
// bfgs.mainLoop()


end
