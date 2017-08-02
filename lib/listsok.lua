-- # listsok : unit tests for lists

require "show"
local THE=require "config"
local O=require "tests"	
local R=require "random"
local LST=require "lists"
 
local function _test1()
 assert(LST.shuffle{1,2,3,4,5} ~= 3)
 assert(LST.member(10,{10,20,30}))
 assert(LST.first{10,20,30} == 10)
 assert(LST.last{10,20,30} == 30)
end

local function _mapping()
  local t1={1,2,3,4}
  local function visit(w,x) 
            w.sum = w.sum + x
            w.n = w.n+1 end
  local w= LST.map2({10,20,30},
                    {sum=0,n=0},
                    visit)
 assert(w.sum== 60)
 assert(w.n== 3)
end

local function _copy()
  local t1={1,2,3,{4,5,6}}
  local t2=LST.copy(t1)
  assert(LST.last(LST.last(t1)) == LST.last(LST.last(t2)))
  t1[4][3]=7
  assert(t1[4][3] == 7)
  assert(t2[4][3] ~= 7)
  local t3=LST.shallowCopy(t1)
  t1[4][3]=8
  assert(t1[4][3] == 8)
  assert(t3[4][3] == 8)
end

local function _bsearch()
  local a={}
  for i=1,100 do
    a[i]=i^0.5 end
  assert(LST.bsearch(a,5)==25) end

R.seed()
O.k{_test1,_mapping,_copy,_bsearch}
