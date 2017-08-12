local KLASSES = require "klasses"
local O = require "tests"

local function _test1(f)
  f = f or "/data/weather.csv"
  local out=KLASSES.create(the.here .. f)
  for k,v in pairs(out.klass) do
    print("\n",k,"\n",v) end
end

_test1()
