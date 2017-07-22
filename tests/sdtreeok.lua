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
  local function dom(t,r) 
      return row.dominate(r,t)
  end
  print(f)
  local t1=  tbl.create( the.here .. f)
  for _,r in pairs(t1.rows) do
    print(r.cells[2],  dom(t1,r))
  end
  local t2 = tbl.discretize(t1,dom)
  print(t2) -- XXX check sits on col2 are righ
  lst.maprint(tree.splits(t2, dom)[1])
  --print("BINS1 ", t2.all.cols[2].bins)
  --local tr=tree.grow(t2,dom) 
  -- print("GROW ", t2.bins)
  --tree.show(tr)
end
local function _test1(f) _test0(f) end
local function _test2() _test0("/data/xomo_all_short.csv") end
local function _test3() _test0("/data/POM3A_short.csv") end

r.seed(1)
_test1()
