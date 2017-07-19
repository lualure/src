-- # sdtreeok : unit tests for sdtree

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local tbl=require "tbl"
local tree=require "sdtree"
local lst=require "lists"
local row=require "row"
 
local function _test0(f)
  f = f or "/data/auto.csv"
  local t1=   tbl.create( the.here .. f)
  local t2 = tbl.discretize(t1)
  print(t2.bins[1])
  local tmp= tree.splits(t2)
  for j, one in pairs(tmp) do
    print(j,{pos=one.pos,sd=one._score,n=one.n}) end
  local tr=tree.grow(t2) 
  tree.show(tr)
end
function _test1() _test0() end
function _test2() _test0("/data/xomo_all_short.csv") end
function _test3() _test0("/data/POM3A_short.csv") end

r.seed(1)
_test2()
