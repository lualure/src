-- # chopok : unit tests for chop

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local range=require "range"
 
local function _test1()
  local tmp={}
  for x=1,10^6 do
    tmp[#tmp+1] = r.r()^0.5 end
  for i,k in pairs(range(tmp)) do
    print(i,k) end
end

r.seed(2)
o.k{_test1}
