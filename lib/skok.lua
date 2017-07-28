#!/usr/bin/env lua
    
-- # testing sk

require "show"
local R=require "random"
local SK=require "sk"
local SAM=require "sample"

local function _sk1()
  x1=SAM.updates{0.34, 0.49, 0.51, 0.6}
  x2=SAM.updates{6,  7,  8,  9}
  x1.txt="x1"
  x2.txt="x2"
  SAM.rank({x1,x2},1.01,SAM.same) end

_sk1()
