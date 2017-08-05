-- ## range : simple discretiation
--
-- _tim@menzies.us_    
-- _August, 2018_
-- 
-- Use this code to find "natural ranges"
-- in a list of numbers `t`. Such ranges
-- can be visualized of as a small number of
-- straight lines approximating a cumulative
-- distribution function.  
--
-- For example, 
-- consider a random number function 
-- `R` and 100 numbers drawn from `square(R)`.
-- The following code would propose breaks in that range at
-- (0,0), (36,0.14), (55,0.3), (67,0.47), (80,0.6),  (100,1) which looks like this:
--
-- ![](img/unsuper.png)
--
-- Note that a line drawn through our breaks is a good approximation
-- of the original curve. There are two benefits in using this approximation:
--
-- - We no longer need to use, or report, the entire curve. Instead, we
--   can just break up the reasoning into a few bins.
-- - Any subsequent supervised discritization need not reason about the
--   whole curve. Instead, that supervised discretizer needs only to
--   decide which of the breaks found by the unsupervised discretizer
--   need to be combined together.
--
-- ### Input
--
-- - `t` (mandatory) is a list of items.
-- - `f` (optinal) is a function that can extract numbes out of items in `t` (defaults
--   to returning the whole item).
--   This is very useful for generating ranges from, say,
--   the ages of a list of employess.
-- 
-- ### Output
--
-- Returns a list of `range`s, which is a structure
-- containing
--
-- - `.n` : the number of items form `t` that fall into this range;
-- - `._all` : a sample of the numbers in this range;
-- - `.hi`: the highest number in this range;
-- - `.lo`: the lowest number in this range;
-- ` `.span`: The span is `.hi - .lo`.
--
-- The numbers in the input list `t` are broken  such that
--
-- - no range contaons too few numbers (controlled by `the.chop.m`)
-- - each range is different to the next one by some `epsilon`
--   value (controlled by `the.chop.cohen`).
-- - the `span` of the range (`hi - lo`) is greater than
--   some `enough` valie (controlled by `the.chop.cohen`).
-- 
-- ### Example usage
--
--     RANGE=require "range"
--     R=require "random"
-- 
--     local tmp={}
--     for x=1,1000 do
--       tmp[#tmp+1] = R.r()^2 end
--     for i,r in pairs(RANGE(tmp)) do
--       print(i, r.n, r.lo, r.hi) end 
--
-- ### Configuration
--
-- - the.chop.cohen: `epsilon` = sdOfnums*cohen. If set larger, 
--   then the number of ranges
--   will decrease
-- - the.chop.m: `enough` = length(t)^m. If set larger, the number of ranges will decrease
-- - the.sample.most: controls how many samples are kept per range.
--   If set smaller, then ranges uses less memory.

require "show"
local the=require "config"
local NUM=require "num"
local SOME=require "sample"
----------------------------------
-- Initialize a range

local function create() return {
  _all= SOME.create(),
  n  = 0,
  hi = -2^63,
  lo =  2^63,
  span = 2^64} end
----------------------------------
-- Update range  _i_  with
-- some numuerc _x_ found from within
-- _one_. Note that, for effeciency sake, we only keep `SOME` numbers
-- (not all of them). 

local function update(i,one, x)
  if x ~= the.ignore then
    SOME.update(i._all, one)
    i.n = i.n + 1
    if x > i.hi then i.hi = x  end
    if x < i.lo then i.lo = x  end
    i.span = i.hi - i.lo
    return x end  end
----------------------------------
-- Update range manager _i_ with
-- a new range _i.now_. Push that
-- range onto the list of all ranges
-- _i.ranges_.

local function nextRange(i) 
  i.now  = create()
  i.ranges[#i.ranges+1] = i.now end
----------------------------------
-- Initialize the control parameters
-- for range generation

local function rangeManager(t, x)  
  local _ = { 
    x     = x,
    cohen = the.chop.cohen,
    m     = the.chop.m,
    size  = #t,
    ranges= {} -- list of all known ranges 
  }
  nextRange(_)
  _.num = NUM.updates(t, _.x)
  _.hi  = _.num.hi
  -- Any range holding less than _enough_ items is ignored.
  _.enough = _.size^_.m
  -- Any range whose span is  less than _epsilon_ is ignored.
  _.epsilon= _.num.sd * _.cohen
  return _ end
----------------------------------
-- Return a function that 
-- 
-- - Sorts a _t_ of
--   items according to the values found by
--   the function _x_.
-- - Then divides that sort into _ranges_
--   of size of at least _enough_ which
--   break the _t_ into items of at least
--   _epsilon_ in size.
return function (t, x,       last)
  x= x or function (z) return z end -- _x_ defaults to the identity
  table.sort(t, function (z1,z2) 
                    local one,two=x(z1),x(z2)
                    return one ~=the.ignore and 
                           two ~=the.ignore and 
                           one < two end )
  local i= rangeManager(t, x)
  for j,one in pairs(t) do
    local x1 = x(one)
    if x1 ~= the.ignore then
      update(i.now, one, x1)
      if j > 1 and
         x1 > last and
         i.now.n       > i.enough  and
         i.now.span    > i.epsilon and
         -- these last two tests stop the final range being too small
         i.num.n - j   > i.enough  and
         i.num.hi - x1 > i.epsilon 
      then nextRange(i) end 
      last = x1  end end
  return i.ranges end

---------------------------------------------------------
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
