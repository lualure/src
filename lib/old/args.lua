-- ## Args : argument handling
-- 
-- _tim@menzies.us_ 
-- _August'18_ 
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
--------------------------------------------------------
--
-- ## Legal
--
-- <img align=right width=150 src="https://www.xn--ppensourced-qfb.com/media/reviews/photos/original/e2/b9/b3/22-bsd-3-clause-new-or-revised-modified-license-60-1424101605.png">
-- LURE, Copyright (c) 2017, Tim Menzies
-- All rights reserved, BSD 3-Clause License
--
-- Redistribution and use in source and binary forms, with
-- or without modification, are permitted provided that
-- the following conditions are met:
--
-- - Redistributions of source code must retain the above
--   copyright notice, this list of conditions and the
--   following disclaimer.
-- - Redistributions in binary form must reproduce the
--   above copyright notice, this list of conditions and the
--   following disclaimer in the documentation and/or other
--   materials provided with the distribution.
-- - Neither the name of the copyright holder nor the names
--   of its contributors may be used to endorse or promote
--   products derived from this software without specific
--   prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
-- CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
-- THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
-- USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
-- IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
