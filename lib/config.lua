-- ## Global settings
--
-- _tim@menzies.us_    
-- _August, 2017_  
--
-- Used by many files

function defaults() return {
  ignore= "?",
  sep=    ",",
  here=   os.getenv("Lure"),
  sample= { b=200,
            most=512,
            epsilon=1.01,
            fmtstr="%20s",
            fmtnum="%5.3f",
            cliffsDelta=0.147 -- small,medium,large=0.147,0.33,0.474
            },
  tree=   { ish=1.00,
            min=2, 
            maxDepth=10},
  tbl=    { k=5 },
  chop=   { m=0.5,
            cohen=0.2},
  num=    { conf=95,
            small=0.38, -- small,medium = 0.38,1
            first=3, 
            last=96,
            criticals = { -- Critical values for ttest
              [95] = {    -- We will extrapolate any values not seen here.
                      [ 3]=3.182,[ 6]=2.447,[12]=2.179,
                      [24]=2.064,[48]=2.011,[96]=1.985},
              [99] = {[ 3]=5.841,[ 6]=3.707,[12]=3.055,
                      [24]=2.797,[48]=2.682,[96]=2.625}}}
          } end

the= defaults()
return the

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
