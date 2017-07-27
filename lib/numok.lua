require "show"
local o=require "tests"
local r=require "random"
local num=require "num"
local str=require "str"

local function _test1()
  local n1=1
  local fmt = "%5s\t%5s\t%5s %5s %5s %5s\n"
  str.say(fmt, "n","same?","mu1","sd1","mu2","sd2")
  str.say(fmt, "-----","-----","-----","-----","-----","-----")
  while n1 < 10 do
    local i,j = num.create(), num.create()
    for _=1,100 do
      local val = r.r()^0.5
      num.update(i, val)
      num.update(j, val*n1) 
    end
    str.say("%5.3f\t%5s\t%5.3f %5.3f %5.3f %5.3f\n",
            n1,num.same(i,j), i.mu,i.sd,j.mu,j.sd)
    n1 = n1 *1.1
  end end 


r.seed(1)
_test1()
