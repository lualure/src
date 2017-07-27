-- # mymathok : unit tests for mymath


------------------------------------------------------

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local x=require "mymath"
 
local function _test1()
        	assert(true)
end

r.seed(1)
o.k{_test1}
