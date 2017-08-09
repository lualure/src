-- # sampleok : unit tests for sample

require "show"
local O=require "tests"	
local R=require "random"
local SAMP=require "sample"
local STR=require "str"
local TILES=require "tiles"

local say=STR.say

local function _test1()
  local some=SAMP.create(64)
  print(some.most)
  for _=1,10000 do
    SAMP.update(some,_) end
  table.sort(some._all)
  print(some._all) 
end

local function _silly() 
  local n=8
  while n< 2500 do
    print("")
    n = n*2
    local one,two,three,four = {},{},SAMP.create(n),SAMP.create(n)
    for i=1,10000 do
      local v1,v2 = R.r(), R.r()
      one[#one+1] = v1
      two[#two+1] = v2 
      SAMP.update(three,v1)
      SAMP.update(four,v2)
    end
    local t1 = TILES.tiles(one,10,2)
    local t2 = TILES.tiles(two,10,2)
    local t3 = TILES.tiles(three._all,10,2)
    local t4 = TILES.tiles(four._all,10,2)
    local err1,err2=0,0
    local sum1,sum2=0,0
    for i=1,#t2 do
      err1=100*(t1[i] - t2[i])
      err2=100*(t3[i] - t4[i]) 
      sum1 = sum1+ err1
      sum2 = sum2+ err2
      io.write(string.format("%4s %2s %6.3f %6.3f\n",n,i, err1,err2))
    end
    io.write(string.format("mean %2s %6.3f %6.3f\n"," ", sum1/#t2,sum2/#t2))

  end
end

local function _cliffs()
  defaults()
  local n1=1
  local fmt = "%5s\t%5s\t%10s\t%10s\n"
  say(fmt, "n","same?","one","two")
  say(fmt, "-----","----","-----------------","-----------------")
  while n1 < 1.5 do
    local i,j = SAMP.create(), SAMP.create()
    for _=1,100 do
      local val = R.r()^0.5
      SAMP.update(i, val)
      SAMP.update(j, val*n1) 
    end
    print(math.floor(n1*1000)/1000,SAMP.cliffsDelta(i._all,j._all),
          STR.fmts("%5.3f",TILES.tiles(i._all,4,1)),
          STR.fmts("%5.3f",TILES.tiles(j._all,4,1)))
    n1 = n1 *1.02
  end end 

local function _bootstrap()
  local n1=1
  local fmt = "%5s\t%5s\t%20s %20s\n"
  say(fmt, "n","same?","one","two")
  say(fmt, "-----","-----","-----","-----")
  while n1 < 1.5 do
    local i,j = {}, {}
    for _=1,128 do
      local x = R.r()
      local val = x^1
      i[#i+1] = val
      j[#j+1] = val*n1 
    end
    say("%5.3f\t%5s\t%20s\t%20s\n",
            n1,SAMP.same(i,j), 
            tostring(STR.fmts("%5.3f",TILES.tiles(i,10,2))), 
            tostring(STR.fmts("%5.3f",TILES.tiles(j,10,2))))
    n1 = n1 *1.02
  end end 

R.seed(1)
O.k{_test1, _cliffs, _bootstrap, _silly}
