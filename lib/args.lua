-- ## Args : argument handling
--
-- Override default settings for a function
-- or, when used at the global level, override
-- settings  with values from the command line `arg`s.
--
-- This function assumes that the list of legal flags
-- comes from the keys of the `settings` table.
--
-- Example usage (for global level). 
--    
--     if arg[1] == "--args" then
--       local args = require "args"
--       local settings = args({a=1,c=false,kkk=22},{"args"})
--       for j,setting in pairs(settings) do
--         print(j,setting) end end

--------------------------
-- Helper function
local function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false end
-------------------------------------------
-- Main
return function (settings,ignore, updates)
  updates = updates or arg
  -- Usually, read all the args.
  ignore = ignore or {}
  local i = 1
  while updates[i] ~= nil  do
    local flag = updates[i]
    local b4   = #flag
    flag = flag:gsub("^[-]+","")
    if not member(flag,ignore) then
      -- Complain if no old value to override
      if settings[flag] == nil then
        error("unknown flag '" .. flag .. "'")
      else
        -- If no arg to this flag, then set a boolean.
        if b4 - #flag == 2 then
          settings[flag] = true
        -- If there is an arg then....
        elseif b4 - #flag == 1 then
          local a1 = updates[i+1]
          local a2 = tonumber(a1)
          -- Set either a number of a string
          settings[flag] = a2  or a1
          i = i + 1 
    end end end
    i = i + 1
  end
  return settings end

