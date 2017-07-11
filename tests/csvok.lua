--[[

# csvok : unit tests for csv

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

------------------------------------------------------

--]]

require "show"
local o    = require "tests"	
local csv  = require "csv"

local xx=[[outlook,
$temp,
?humidity,
windy,!play #asdas sfsd
sunny,85,85,FALSE,no
sunny,80,90,TRUE,
 no
overcast,83,86,FALSE,yes
rainy,70,96,FALSE,yes
rainy,68,80,FALSE,yes


rainy,65,70,TRUE,no
overcast,64,65,TRUE,yes
sunny,72,95,FALSE,no #adsas
sunny,69,70,FALSE,yes
rainy,75,80,FALSE,yes
sunny,75,70,TRUE,yes

overcast,72,90,TRUE,yes
overcast,81,75,FALSE,yes
rainy,71,
91, TRUE ,no]]

local function _test1()
   csv(xx,print)
   print("")
   csv("data/weather.csv",print)
end

o.k{_test1}
