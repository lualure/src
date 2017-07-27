-- # sampleok : unit tests for sample

require "show"
local o=require "tests"	
local r=require "random"
local s=require "sample"
local str=require "str"
local tiles=require "tiles"

local function _test1()
  local some=s.create(64)
  print(some.most)
  for _=1,10000 do
    s.update(some,_) end
  table.sort(some._all)
  print(some._all) 
end

local function _cliffs()
  local n1=1
  local fmt = "%5s\t%5s\t%20s %20s\n"
  str.say(fmt, "n","same?","one","two")
  str.say(fmt, "-----","-----","-----","-----")
  while n1 < 1.5 do
    local i,j = s.create(), s.create()
    for _=1,100 do
      local val = r.r()^0.5
      s.update(i, val)
      s.update(j, val*n1) 
    end
    str.say("%5.3f\t%5s\t%20s\t%20s\n",
            n1,s.cliffsDelta(i,j), 
            tostring(tiles.tiles(i._all,0.25)), 
            tostring(tiles.tiles(j._all,0.25)))
    n1 = n1 *1.01
  end end 

local function _bootstrap()
  local n1=1
  local fmt = "%5s\t%5s\t%20s %20s\n"
  str.say(fmt, "n","same?","one","two")
  str.say(fmt, "-----","-----","-----","-----")
  while n1 < 1.5 do
    local i,j = {}, {}
    for _=1,128 do
      local x = r.r()
      local val = x^1
      i[#i+1] = val
      j[#j+1] = val*n1 
    end
    str.say("%5.3f\t%5s\t%20s\t%20s\n",
            n1,s.same(i,j), 
            tostring(str.fmts("%5.3f",tiles.tiles(i,10,2))), 
            tostring(str.fmts("%5.3f",tiles.tiles(j,10,2))))
    if true then return true end
    n1 = n1 *1.01
  end end 

r.seed(1)
--_test1()
--_cliffs()
_bootstrap()
