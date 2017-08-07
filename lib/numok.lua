require "show"
local O=require "tests"
local R=require "random"
local NUM=require "num"
local STR=require "str"

---------------------------------------------------
-- Strange tales of verification. Here,
-- the decision abdout "same?" flips at the same
-- level of difference between two samples (n=1.143)
-- since the effect size is ruling the roost.

local function _sd1()
  local  i = NUM.create()
  for _,x in pairs{9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4} do
    NUM.update(i,x) end
  local sd = math.floor(1000*i.sd)/1000
  assert(i.mu == 7)
  assert(sd   == 3.06) end

local function _sd2()
  local  i,addi=NUM.watch()
  for _,x in pairs{9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4} do
    addi(x) end
  local sd = math.floor(1000*i.sd)/1000
  assert(i.mu == 7)
  assert(sd   == 3.06) end

local function _sd3()
  local  i = NUM.updates{9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4} 
  local sd = math.floor(1000*i.sd)/1000
  assert(i.mu == 7)
  assert(sd   == 3.06) end

local function _ttest()
  local fmt = "%4s\t%5s\t%5s\t%5s\t%5s\t%5s %5s %5s %5s\n"
  for _,conf in pairs{95,99} do
    print("")
    R.seed(1)
    defaults()
    the.num.conf = conf
    STR.say(fmt, "conf","n","fx?","sig?", "same?","mu1","sd1","mu2","sd2")
    STR.say(fmt, "----","-----","-----","-----","-----","-----",
                 "-----","-----","-----")
    local n1=1
    while n1 < 1.2 do
      local i,j = NUM.create(), NUM.create()
      local function yn(f,i,j) return NUM[f](i,j) and "y" or "." end
      for _=1,100 do
        local val = R.r()^0.5
        NUM.update(i, val)
        NUM.update(j, val*n1) 
      end
      STR.say("%4s\t%5.3f\t%5s\t%5s\t%5s\t%5.3f %5.3f %5.3f %5.3f\n",
             the.num.conf,n1,yn("hedges",i,j),
             yn("ttest",i,j),yn("same",i,j), i.mu,i.sd,j.mu,j.sd) 
      n1 = n1 *1.01
end end end 

R.seed(1)
O.k{_sd1,_sd2,_sd3,_ttest}
_sd2()
