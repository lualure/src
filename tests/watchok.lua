-- # watchok : unit tests for watch


------------------------------------------------------

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local x=require "watch"
 
local function _test1()
    w=x.create(50)
    for i=1,2000 do
      x.update(w, r.r()^2) end
end

r.seed(1)
o.k{_test1}
