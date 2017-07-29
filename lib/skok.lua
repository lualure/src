#!/usr/bin/env lua
    
-- # testing sk

require "show"
local O=require "tests"
local R=require "random"
local SK=require "sk"
local SAM=require "sample"

local function _sk1()
  local x1=SAM.updates{0.34, 0.49, 0.51, 0.6}
  local x2=SAM.updates{6,  7,  8,  9}
  x1.txt="x1"
  x2.txt="x2"
  SAM.rank({x1,x2},1.01) end

local function _sk2()
  local x1=SAM.updates{0.1, 0.2, 0.3, 0.4}
  local x2=SAM.updates{0.1, 0.2, 0.3, 0.4}
  local x3=SAM.updates{6,  7,  8,  9}
  x1.txt="x1"
  x2.txt="x2"
  x3.txt="x3"
  SAM.rank({x1,x2,x3},1.01) end

local function _sk3()
  local x1=SAM.updates{0.34, 0.49, 0.51, 0.6}
  local x2=SAM.updates{0.6, 0.7, 0.8, 0.9}
  local x3=SAM.updates{0.15,  0.25,  0.4,  0.35}
  local x4=SAM.updates{0.6,  0.7,  0.8,  0.9}
  local x5=SAM.updates{0.1,  0.2,  0.3,  0.4}
  x1.txt="x1"
  x2.txt="x2"
  x3.txt="x3"
  x4.txt="x4"
  x5.txt="x5"
  SAM.rank({x1,x2,x3,x4,x5},1.01) end

local function _sk4()
  local x1=SAM.updates{101,100,99,  101,99.5}
  local x2=SAM.updates{101,100,99,  101,100}
  local x3=SAM.updates{101,100,99.5,101,99}
  local x4=SAM.updates{101,100,99,  101,100}
  x1.txt="x1"
  x2.txt="x2"
  x3.txt="x3"
  x4.txt="x4"
  SAM.rank({x1,x2,x3,x4},1.01) end

local function _sk5()
  local x1=SAM.updates{11,11,11}
  local x2=SAM.updates{11,11,11}
  local x3=SAM.updates{11,11,11}
  x1.txt="x1"
  x2.txt="x2"
  x3.txt="x3"
  SAM.rank({x1,x2,x3},1.01) end

local function _sk6()
  local x1=SAM.updates{11,11,11}
  local x2=SAM.updates{11,11,11}
  local x3=SAM.updates{32,33,34,35}
  x1.txt="x1"
  x2.txt="x2"
  x3.txt="x3"
  SAM.rank({x1,x2,x3},1.01) end

local function _sk7()
  local x1,x2,x3,x4,x5,x6={},{},{},{},{},{}
  for i=1,10^6 do
    x1[#x1+1] = R.r()^0.5
    x2[#x2+1] = R.r()^2
    x3[#x3+1] = R.r()
    x4[#x4+1] = R.r()^0.4
    x5[#x5+1] = R.r()^2.2
    x6[#x6+1] = R.r()
  end
  x1 = SAM.updates(x1); x1.txt="x1"
  x2 = SAM.updates(x2); x2.txt="x2"
  x3 = SAM.updates(x3); x3.txt="x3"
  x4 = SAM.updates(x4); x4.txt="x4"
  x5 = SAM.updates(x5); x5.txt="x5"
  x6 = SAM.updates(x6); x6.txt="x6"
  SAM.rank({x1,x2,x3,x4,x5,x6},1.01) end

defaults()
the.sample.fmtnum="%6.2f"
O.k{_sk1,_sk2,_sk3,_sk4,_sk5,_sk6,_sk7}
