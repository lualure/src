-- ## csv : utilities

-- Map a function mapped over comma-seperated data. 
-- pruning comments away and dead space.  For example,
-- here's a simple `print` for each row:
--
--     local csv=require "csv"
--     csv("../data/weather/csv",print)
--
-- Data is assumed to start with an initial row list column
-- names. If a column name includes "?", then don't read it.
-- If a row ends with a comma, join it to the next line.
--
local the      = require "config"
local notsep   = "([^" .. the.sep .. "]+)" -- not cell seperator
local dull     = "['\"\t\n\r]*"  -- white space, quotes
local padding  = "%s*(.-)%s*"    -- space around words
local comments = "#.*"           -- comments
--------------------------------------------------------
-- If we are reading from a string that ends in any of
-- these extensions, assume the string is a file name.
local files    = {txt=true, csv=true}
--------------------------------------------------------
-- If lines end with a comma, join it to the next line.
local function incomplete(txt) -- must join line to next
  return string.sub(txt,-1) == the.sep  end
-------------------------------------------------------
-- If a column name includes "?", skip that column.
local function ignored(txt) -- ignore this column
  return string.find(txt,the.ignore) == nil end
-------------------------------------------------------
-- Reads, from row1, what columns are to be ignored
-- (if any). Skipped those ignored columns for all rows.
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
-- Kills wihte space, irrelevant characters, comments.
-- Pass that row to the calling function `wme.fn`. 
local function withOneLine(txt,wme)   
  txt= txt:gsub(padding,"%1")
          :gsub(dull,"")
          :gsub(comments,"") 
  if #txt > 0 then 
    wme.fn( cellsWeAreNotIgnoring(txt,wme) ) end end
-------------------------------------------------------
-- look at the `src` and it if ends in a `files` name,
-- then read it as a file. Else, read from jat string.
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
-- Main loop. Function `fn` is called for each row
--  (and that row is sent to that function as a list of
--  cell values).
return function (src,fn)
  withEachLine(src, {fn=fn, first=true, use={}}) end
