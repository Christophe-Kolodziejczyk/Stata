/************************************************************
Filename            : BuildTrustReg.do
Author              : Christophe Kolodziejczyk
Date of creation    : 01-08-2017
Modified            : 03-03-2018
03-03-2018: inserted header
Purpose             : Build Trust Region library ltrustreg.mlib

Input               :
Output              :



*************************************************************/


// global root E:\ProjektDB\KORA\Workdata\704752\stcrmix
global pado $root\ado
// include "$root\CRSetUp.do"
// di "$pado"

sysdir set PERSONAL $pado\
cap erase $pado\ltrustreg.mlib
cap erase $pado\lib_CR.mlib

clear *
clear mata

cd $root // \trust

clear mata
mata: mata set matalnum on

do trustReg_StructDef.do
do trustReg__Extra.do
do trustReg__Caller.do
do trustReg__dfp.do

do classTrustReg.do
do trustReg__pouet.do
do trustReg__Init.do
do trustReg__SolveSubProb.do
do trustReg__trustProbV3.do
do trustReg__updateHessian.do
do trustReg__printCurrentState.do
do trustReg__computeTauV2.do
do trustReg__newtonStepV2.do
do trustReg__trustOptimizeV2.do
do trustReg__trustLoopOptimize.do
do trustReg__initGradHessian.do
do trustReg__passingToCaller.do
do trustReg__initCaller.do

do trustReg__displayResults.do
do trustReg__computeEigenvect.do
mata: 
S = J(1,1,trustReg())
// S.trustInit()
S.pouet()
// S.solveSubProb()
end

// exit
mata:
mata mlib create ltrustreg , replace dir(PERSONAL) size(1024)
mata mlib add ltrustreg *() , dir(PERSONAL) // complete
mata mlib index
mata describe using ltrustreg
mata mlib query
end
clear mata
mata: 
mata describe using ltrustreg
// mata describe trustReg()
S = J(1,1,trustReg())
mata describe trustReg()
// S.trustInit()
S.pouet()
// S.m_f
end
