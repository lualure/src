-- ## Return some trees
-- 
-- _tim@menzies.us_   
-- _August'17_   
--
-- This code is a convenience function to return trees from data files known to ship with LUA.

require "show"
local THE=require "config"
local TBL=require "tbl"
local TREE=require "sdtree"

-- Main driver. Reads, discretize a table then generates a decision tree.

local function create(f,y)
  y = y or "goal1"
  f = f or "/data/auto.csv"
  f = THE.here .. f
  return TREE.grow(
           TBL.discretize( TBL.create(f),y), 
                           y) end
-- Sample data
local function auto(y)      
   return create("/data/auto.csv",y or "dom") end
local function pom3a(y)     
  return create("/data/POM3A_short.csv",y or "dom") end
local function xomo(y)      
  return create( "/data/xomo_all_short.csv",y or "dom") end

-- Sample data (with different goals)
local function autogoal1()  return auto("goal1") end
local function pom3agoal1() return pom3a("goal1") end
local function xomogoal1(y) return xomo("goal1") end

-- External interface
return {auto=auto, pom3a=pom3a, xomo=xomo, autogoal1=autogoal1,
        pom3agoal1=pom3agoal1, xomogoal1=xomogoal1}

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
