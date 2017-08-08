-- # watchok : unit tests for watch


------------------------------------------------------

require "show"
local the=require "config"
	
local O   = require "tests"	
local R   = require "random"
local SPY = require "spy"
 
local function _test1()
  local i,addi=SPY.watch(100)
  for i=1,2000 do
    addi(R.r()) end
end

R.seed(1)
O.k{_test1}
