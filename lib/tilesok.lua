require "show"
local O=require "tests"	
local R=require "random"
local SAMP=require "sample"
local TILES=require "tiles"
local LST=require "lists"

local function _t1()
  R.seed(1)
  local out3={}
  local out2={}
  local out1={}
  for i=1,10000 do
    out1[i] = R.r()^2 
    out2[i] = 3*R.r()^0.5 
    out3[i] = R.r()^0.5 end
  LST.maprint(TILES.shows{out1,out2,out3})
end

O.k{_t1}
