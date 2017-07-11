-- # csv : utilities

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
