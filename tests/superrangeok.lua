-- # superrangesok : unit tests for superranges

require "show"
local the=require "config"
local o=require "tests"	
local r=require "random"
local range=require "range"
local super=require "superrange"
local num=require "num"
----------------------------------------------
local function x(z) return z[1] end
local function y(z) return z[#z] end
local function klass(z) 
  if z < 0.2 then return 0.2 + 2*r.r()/100 end
  if z < 0.6 then return 0.6 + 2*r.r()/100 end
  return                 0.9 + 2*r.r()/100 end
----------------------------------------------
local function _test1()
  local lst,n={},num.create()
  for _=1,10^5 do
    local w=r.r()^0.5
    num.update(n,klass(w))
    lst[#lst+1] = {w, klass(w)} end
  for j,one in pairs(range(lst,x)) do
    print("x",j,one) end
  for j,one in pairs(super(lst,x,y)) do
    print("super",j,one) end
end
----------------------------------------------
r.seed(1)
o.k{_test1}
