global DM R:\__econometrie\stata\DynamicMatching
global root $DM

include $root\header.do

global do do
mata: mata set matastrict off 
$do $DM\duration-2020-11-22.do
$do $DM\mergeMatrices-v2.do