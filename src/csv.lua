--[[

# csv : utilities

DARE, Copyright (c) 2017, Tim Menzies
All rights reserved, BSD 3-Clause License

Redistribution and use in source and binary forms, with
or without modification, are permitted provided that
the following conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the 
  following disclaimer.

* Redistributions in binary form must reproduce the
  above copyright notice, this list of conditions and the 
  following disclaimer in the documentation and/or other 
  materials provided with the distribution.

* Neither the name of the copyright holder nor the names 
  of its contributors may be used to endorse or promote 
  products derived from this software without specific 
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

--]]
-------------------------------------------------------
local the      = require "config"
local notsep   = "([^" .. the.sep .. "]+)" -- not cell seperator
local dull     = "['\"\t\n\r]*"  -- white space, quotes
local padding  = "%s*(.-)%s*"    -- space around words
local comments = "#.*"           -- comments
local files    = {txt=true, csv=true}
--------------------------------------------------------
local function incomplete(txt) -- must join line to next
  return string.sub(txt,-1) == the.sep  end
-------------------------------------------------------
local function ignored(txt) -- ignore this column
  return string.find(txt,the.ignore) == nil end
-------------------------------------------------------
local function cellsWeAreNotIgnoring(txt,wme) 
  local out,col = {},0
  for word in string.gmatch(txt,notsep) do
    col = col + 1
    if wme.first    then 
      wme.use[col] = ignored(word) end
    if wme.use[col] then 
      out[#out+1]  = tonumber(word) or word end end
  return out end
-------------------------------------------------------
local function withOneLine(txt,wme)
  txt= txt:gsub(padding,"%1")
          :gsub(dull,"")
          :gsub(comments,"") 
  if #txt > 0 then 
    wme.fn( cellsWeAreNotIgnoring(txt,wme) ) end end
-------------------------------------------------------
local function withEachLine(src,wme)
  local cache={}
  local function line1(line)
    cache[#cache+1] = line
    if not incomplete(line) then
       cache= withOneLine(table.concat(cache), wme) 
       cache= {}
       wme.first=false end end
  -------------------------------------
  if files[string.sub(src,-3,-1)] then
    io.input(src) 
    for line in io.lines() do 
      line1(line) end
  else 
    for line in src:gmatch("[^\r\n]+") do
      line1(line) end end end
-------------------------------------------------------
return function (src,fn)
  withEachLine(src, {fn=fn, first=true, use={}}) end
