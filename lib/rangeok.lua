-- # chopok : unit tests for chop

local O=require "tests"	
local R=require "random"
local RANGE=require "range"
local TILE=require "tiles"
local LST=require "lists"
local STR=require "str"
 
local function _test1()
  defaults()
  the.chop.cohen=0.5
  the.chop.m=0.7
  R.seed(1)
  local tmp={}
  for x=1,1000 do
    tmp[#tmp+1] = R.r()^2 end
  TILE.print{tmp}
  print("\nranges: ")
  STR.say("%5s\t%5s\t%5s\t%5s\n","#","n","lo","hi")
  STR.say("%5s\t%5s\t%5s\t%5s\n","-----","-----","-----","-----")
  for i,k in pairs(RANGE(tmp)) do
    STR.say("%5s\t%5s\t%5.3f\t%5.3f\n",i,k.n,k.lo,k.hi) end end

O.k{_test1}
