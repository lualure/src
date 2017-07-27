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
  print(f)
  for j=1,1 do
    local t1=   tbl.create( the.here .. f)
    local function run1() bpo(t1) end
  --local t2=tbl.discretize(t1)  
  --print("BINS1 ", t2.bins)
  --local tr=tree.grow(t2)
  --print("GROW ",tr)
  --tree.show(tr)
    pcall(run1)
  end
end

local function _test1() _test0() end
local function _test2() _test0("/data/xomo_all_short.csv") end
local function _test3() _test0("/data/POM3A_short.csv") end
local function _test4() _test0("/data/xomo_all.csv") end

r.seed(1)
-- _test4()
_test1()
--_test2()
--_test3()
