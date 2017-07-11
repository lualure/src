local o= require "tests"
local function _one(     k) 
  k=1
  print(2)
  assert(1==2,"impossible")
end
b=2
o.k{_one}
