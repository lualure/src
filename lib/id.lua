local id=0
local function new() id=id+1; return id end
return {new=new}
