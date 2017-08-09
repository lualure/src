-- ## Random number generator
-- 
-- _tim@menzies.us_    
-- _August, 2017_ 
--
-- Lua's `math.random()` is an interface to the C rand() function
-- provided by the OS libc. This implementation varies by platform
-- so the numbers it generates also varies from platform to
-- platform
-- 
-- Can't have that: tests won't port across platforms.
-- 
-- The following library is recommended as a
-- replacement for the ANSI C rand() and srand()
-- functions, particularly in simulation applications
-- where the statistical 'goodness' of the random
-- number generator is important. 
-- 
-- The generator used in this library is a so-called
-- 'Lehmer random number generator' which returns a
-- pseudo-random number uniformly distributed 0.0 and
-- 1.0. The period is (m - 1) where m = 2,147,483,647
-- and the smallest and largest possible values are (1
-- / m) and 1 - (1 / m) respectively. For more details
-- see:
-- 
-- - "Random Number Generators: Good Ones Are Hard To Find"
--    Steve Park and Keith Miller
--    Communications of the ACM, October 1988
-- 
-- Also, the raw random number generator is wrapped in a
-- 97 table to increase randomness.
--
-- Typical usage:
--
--      R=require "random" 
--      R.seed(1)
--      print(R.r())
--
---------------------------------------------------
-- Magic numbers
local seed0       = 10013
local seed        = seed0
local multipler   = 16807.0
local modulus     = 2147483647.0
local randomtable = nil

--------------------------------------------------
-- New seed is calulated from the old seed.
-- New random number is calculated from the new seed.
-- Cycle= 2,147,483,646 numbers

local function park_miller_randomizer()
  seed = (multipler * seed) % modulus
  return seed / modulus end 
--------------------------------------------------
-- Set the random number seed

local function rseed(n)
  if n then seed = n else seed = seed0 end
  randomtable = nil end
--------------------------------------------------
-- Set the random number seed using Lua stuff
-- (note: will generate different numbers on
-- different platforms.)
--
local function system()
  return rseed(math.random()*modulus) end
--------------------------------------------------
-- Main driver

local function another (       x,i)
  if randomtable == nil then
    randomtable = {}
    for i = 1, 97 do
      randomtable[i] = park_miller_randomizer() end end
  x = park_miller_randomizer()
  i = 1 + math.floor(97*x)
  x, randomtable[i] = randomtable[i], x
  return x end 
--------------------------------------------------
-- Public interface

return {seed=rseed, system=system,r=another}
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
