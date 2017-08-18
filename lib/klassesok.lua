local TBL = require "tbl"
local KLASSES = require "klasses"
local O = require "tests"

local function _test1(f)
  f = f or "/data/weather.csv"
  local out=KLASSES.create(the.here .. f)
  for k,v in pairs(out.klass) do
    print("\n----| ".. k .. " |-------------------------------")
    TBL.show(v) end
end

local function _test2(f)
  f = f or "/data/weather.csv"
  KLASSES.create(the.here .. f, KLASSES.incNB)
end

_test1("/data/weather.csv")
_test1("/data/diabetes.csv")
_test1("/data/soybean.csv")
--_test2("/data/diabetes.csv")

