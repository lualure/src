-- # superrangesok : unit tests for superranges

require "show"
local the=require "config"
local O=require "tests"	
local R=require "random"
local RANGE=require "range"
local SUPER=require "superrange"
local NUM=require "num"
----------------------------------------------
local function x(z) return z[1] end
local function y(z) return z[#z] end
local function klass(z) 
  if z < 0.2 then return 0.2 + 2*R.r()/100 end
  if z < 0.6 then return 0.6 + 2*R.r()/100 end
  return                 0.9 + 2*R.r()/100 end
----------------------------------------------
local function _test1()
  local t,n={},NUM.create()
  for _=1,50  do
    local w=R.r()
    NUM.update(n,klass(w))
    t[#t+1] = {w, klass(w)} end
  print("\nWe have many unsupervised ranges.")
  for j,one in pairs(RANGE(t,x)) do
    print("x",j,one) end
  print("\nWe have fewer supervised ranges.")
  for j,one in pairs(SUPER(t,x,y)) do
    print("super",j,one) end
end
----------------------------------------------
R.seed(1)
O.k{_test1}
