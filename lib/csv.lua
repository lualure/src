-- ##  Utilities for reading CSV files

-- _tim@menzies.us_
-- _August'17_

-- Map a function mapped over comma-seperated data. 
-- pruning comments away and dead space.  For example,
-- here's a simple `print` for each row:
--
--     local csv=require "csv"
--     csv(os.getenv("DataDir") .. "/data/weather.csv",print)
--
-- Data is assumed to start with an initial row list column
-- names. If a column name includes "?", then don't read it.
-- If a row ends with a comma, join it to the next line.
--
-- This code is called using `csv(source, function)`.
--
-- - If `source` is a string ending with `txt` or `csv`,
-- it assumed this string names a files from which we should
-- read the data. 
-- - Otherwise, we assume that `source`
-- is a string containing the data.
--
-- TODO: the following passes each found row to a function `fn`.
-- A cooler approach would be remove the need for pass round `fn`
-- and make all this an iterator. BUT, iterators in Lua and
-- nuanced more complex than other languages (like Python). So
-- here, we take the easy path (i.e. pass the function).
--
local the      = require "config"
local notsep   = "([^" .. the.sep .. "]+)" -- not cell seperator
local dull     = "['\"\t\n\r]*"  -- white space, quotes
local padding  = "%s*(.-)%s*"    -- space around words
local comments = "#.*"           -- comments
--------------------------------------------------------
-- ### Control functions

-- If we are reading from a string that ends in any of
-- these extensions, assume the string is a file name.
local files    = {txt=true, csv=true}

-- If lines end with a comma, join it to the next line.
local function incomplete(txt) -- must join line to next
  return string.sub(txt,-1) == the.sep  end

-- If a column name includes "?", skip that column.
local function ignored(txt) -- ignore this column
  return string.find(txt,the.ignore) == nil end
-------------------------------------------------------
-- ### Column filtering
--
-- Reads, from `row1`, what columns are to be ignored
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
-- ### Row filtering

-- Pass that row to the calling function `wme.fn`. 
local function withOneLine(txt,wme)   
  txt= txt:gsub(padding,"%1")
          :gsub(dull,"")
          :gsub(comments,"") 
  if #txt > 0 then 
    wme.fn( cellsWeAreNotIgnoring(txt,wme) ) end end
-------------------------------------------------------
-- ### Iterator for each line.
--
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
  if files[string.sub(src,-3,-1)] then
    io.input(src) 
    for line in io.lines() do 
      line1(line) end
  else 
    for line in src:gmatch("[^\r\n]+") do
      line1(line) end end end
-------------------------------------------------------
-- ### External Interface
--
-- Main loop. Function `fn` is called for each row
--  (and that row is sent to that function as a list of
--  cell values).
return function (src,fn)
  withEachLine(src, {fn=fn, first=true, use={}}) end


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
