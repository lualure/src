-- # bpook : unit tests for bpo


------------------------------------------------------

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local bpo=require "bpo"
local tbl=require "tbl"
local tree=require "sdtree"
 
local function _test0(f)
  f = f or "/data/auto.csv"
  local t1=   tbl.create( the.here .. f)
  --local t2=tbl.discretize(t1)  
  --print("BINS1 ", t2.bins)
  --local tr=tree.grow(t2)
  --print("GROW ",tr)
  --tree.show(tr)
  bpo(t1)
end

local function _test1() _test0() end
local function _test2() _test0("/data/xomo_all_short.csv") end
local function _test3() _test0("/data/POM3A_short.csv") end

r.seed(1)
_test3()
