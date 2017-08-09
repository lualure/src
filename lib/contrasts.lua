-- ## Learning Contrast Sets
-- 
-- _tim@menzies.us_   
-- _August'17_   
--
-- This code is a post-processor to the `sdtree`
-- decision-tree learner (and assumes that all
-- attributes are `sym`s or discretized `num`s.
--
-- It gets called like this:
--
--     local CON=require "contrasts" -- this package
--     local TREES=require "trees"   -- returns some trees
--     local TREE=require "sdtree"   -- the decision tree learner
--     -- lets go
--     local x=TREES.auto() -- a sample tree
--     TREE.show(x)         -- show the tree
--     b=CON.branches(x)
--     CON.plans(b)
--     CON.monitors(b)
--
-- Contrasts are computed
-- between the branches to all nodes in a tree. 
-- (and the contrast is the set delta between the
-- attribute values seen the branches leading
-- to `branch2` from `branch1`.
--
-- This code ignores _dull_ deltas; i.e.
--
-- - _RULE1_: the median value of `branch2` is not `better` than `branch1` (where `better`
--   is a customizable predicate, see below).
-- - _RULE2_: The distribution of the target variable is statistically the same in both branches;
-- - _RULE3_: The size of the delta between the branches is larger than zero.
--
-- These three rules are implemented in the `contrasts` function, show below.
--
-- Constrast sets can either be _plans_ or _monitors_. 
--
-- - In the former, we seek changes that drive us from a lesser `branch1` to a better `branch2`. 
-- - In the latter, we seek things to avoid. These are changes which, if they happen,  would drive us from a better `branch1` to a worse `branch2`. 
--
-- Hence we can create plans or monitors as follows:
--
--     local function more(x,y) return x > y end
--     local function less(x,y) return x < y end
--
--     -- the above controls what  constrast are selected
--
--     local function plans(branches)    
--       return contrasts(branches, more) end
--     local function monitors(branches) 
--       return contrasts(branches, less) end

require "show"
local THE=require "config"
local TREE=require "sdtree"
local TREES=require "trees"
local LST=require "lists"
local NUM=require "num"
-----------------------------------------------------
-- Feature extractor from the brnaches.
-- Collects all the `attr`, `val` pairs.

local function has(branch)
  local out = {}
  for i=1,#branch do
    local step = branch[i]
    out[#out+1] = {attr=step.attr, val=step.val} end 
  return out end

local function have(branches)
  for _,branch in pairs(branches) do
    branch.has = has(branch) end 
  return branches end
-----------------------------------------------------
-- Generator for the branches. Walk down the tree and,
-- for each node, add the branch `b` to that node to `out`.

local function branches1(tr,out,b)
  if tr.attr then
    b[#b+1] = {attr=tr.attr,val=tr.val,_stats=tr.stats} end
  if #b > 0 then out[#out+1] = b   end
  for _,kid in pairs(tr._kids) do
      branches1(kid,out,LST.copy(b)) end  
  return out end

local function branches(tr)
  return have(branches1(tr,{},{})) end
-----------------------------------------------------
-- Compute the set delta between two branches.

local function member2(twin0,twins) 
  for _,twin1 in pairs(twins) do
    if twin0.attr == twin1.attr and
       twin0.val == twin1.val then
       return true end end
  return false end

local function delta(t1, t2) 
  local out={}
  for _,twin in pairs(t1) do
    if not member2(twin,t2) then
      out[#out+1] = {twin.attr, twin.val} end end
  return out end
------------------------------------------------------
-- The worker. This code returns at most two
-- branches per node: one showing the branch to maximum
-- improvement; and another showing the branch with mininum delta.

local function contrasts(branches, better)
  for i,branch1 in pairs(branches) do
    local out={}
    for j,branch2 in pairs(branches) do
      if i ~= j then
        local num1=LST.last(branch1)._stats
        local num2=LST.last(branch2)._stats
        if better(num2.mu, num1.mu)  then -- RULE1
          if not NUM.same(num1,num2) then -- RULE2
            local inc = delta(branch2.has,branch1.has)
            if #inc > 0 then -- RULE3
              out[#out+1] = {i=i,j=j,ninc=#inc,muinc=num2.mu - num1.mu,
                             inc=inc, branch1=branch1.has,mu1=num1.mu, 
                             branch2=branch2.has,mu2=num2.mu}
               end end end end end 
    print("")
    table.sort(out, function (x,y) return x.muinc > y.muinc end)
    print(i,"max mu  ",out[1])
    table.sort(out, function (x,y) return x.ninc < y.ninc end)
    print(i,"min inc ",out[1])
    end end

-----------------------------------------------------
-- Plans are things we want to do. Monitors are things
-- we want to avoid.

-- More specfically, plans are to branches with `more` value. 
local function more(x,y) return x > y end

-- And monitors  are to branches with `less` value.
local function less(x,y) return x < y end

-- Main driver
local function plans(branches)    return contrasts(branches, more) end
local function monitors(branches) return contrasts(branches, less) end

--------------------------------------------------------
-- External interface
return {monitors=monitors, plans=plans,branches=branches}

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
