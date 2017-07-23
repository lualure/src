-- # sdtreeok : unit tests for sdtree

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local tbl=require "tbl"
local tree=require "sdtree"
local lst=require "lists"
local row=require "row"
 
local function _test0(f,y)
  y = y or "goal1"
  f = f or "/data/auto.csv"
  print(f)
  local t1=  tbl.create( the.here .. f)
  print(f, #t1.rows)
  tbl["dom"](t1)
  --end
  local t2 = tbl.discretize(t1,y)
  for _,head in pairs(t2.x.cols) do
   if head.bins then
   print(#head.bins,head.txt) end end
  --lst.maprint(tree.splits(t2, tbl.dom(t2)))
  --print("BINS1 ", t2.all.cols[2].bins)
  local tr=tree.grow(t2,y)
  -- print("GROW ", t2.bins)
  tree.show(tr)
end

local function _test1(f) _test0(f) end
local function _test2() _test0("/data/xomo_all_short.csv") end
local function _test3() _test0("/data/POM3A_short.csv") end

r.seed(1)
_test1()
