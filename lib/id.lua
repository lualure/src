-- # id
-- Return an id number that has never been seen before.
--
-- Usage:
--
--     id=require "id"
--     print(id.new())
--

local id=0
local function new() id=id+1; return id end
return {new=new}
