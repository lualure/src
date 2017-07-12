-- # listsok : unit tests for lists

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local lst=require "lists"
 
local function _test1()
 assert(lst.shuffle{1,2,3,4,5} ~= 3)
 assert(lst.member(10,{10,20,30}))
 assert(lst.first{10,20,30} == 10)
 assert(lst.last{10,20,30} == 30)
end

local function _mapping()
  local t1={1,2,3,4}
  local function visit(w,x) 
            w.sum = w.sum + x
            w.n = w.n+1 end
  local w= lst.map2({10,20,30},
                    {sum=0,n=0},
                    visit)
 assert(w.sum== 60)
 assert(w.n== 3)
end

local function _copy()
  local t1={1,2,3,{4,5,6}}
  local t2=lst.copy(t1)
  assert(lst.last(lst.last(t1)) == lst.last(lst.last(t2)))
  t1[4][3]=7
  assert(t1[4][3] == 7)
  assert(t2[4][3] ~= 7)
  local t3=lst.shallowCopy(t1)
  t1[4][3]=8
  assert(t1[4][3] == 8)
  assert(t3[4][3] == 8)
end

r.seed()
o.k{_test1,_mapping,_copy}
