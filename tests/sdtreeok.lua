-- # sdtreeok : unit tests for sdtree

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local tbl=require "tbl"
local tree=require "sdtree"
local lst=require "lists"
 
local function _test1()
  local t= tree(tbl.discretize(
           tbl.create(
             the.here .. "/data/weather2.csv")))
  for j, one in pairs(t) do
    print(j,{pos=one.pos,sd=one._score,n=one.n}) end
end

r.seed(1)
o.k{_test1}
