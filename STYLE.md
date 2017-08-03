## My Coding standards (for Lua)

tim@menzies.us  
August'17

---------------------------------------------------------
### Learning Lua

Some great on-line resources:

- Quick start http://tylerneylon.com/a/learn-lua/
- [Read the book](https://www.lua.org/pil/).
    - The 4th edition in [on Amazon](https://www.amazon.com/Programming-Lua-Fourth-Roberto-Ierusalimschy/dp/8590379868/ref=pd_lpo_sbs_14_t_0?_encoding=UTF8&psc=1&refRID=MFJR3QK7P99NY833BJYN).
    - The 2nd edition (which is still pretty good) is available [on-line](http://index-of.es/Programming/Lua/Programming%20in%20Lua.pdf).

----------------------------------------------------------
### Timm's Lua Coding style

If you are rading my code, it will save you time to know how I write my Lua.

#### Formatting

Indents = 2 spaces (no tabs).

Short variable names; e.g. not `self` but `i`.

Join all lines that are only  `end`. For example:

    local function map(t,f)
      if t then
        for i,v in pairs(t) do f(v) end end end

#### Test suites

The file `X.lua` may have demo code in `Xok.lua`.

- Use `random.lua` not the built-in random number generator since mine ins platform independent
  (same numbers, different platforms-- better for writing unit tests).

#### Documentation

Add documents to enable `locco`-style documentation

     ./locco.lua yourCode.lua -- generates docs/yourCode.html

Some rules:

- No file called `index.lua` (messes up my documentation system)
- Html written to lib/docs
- Your `.gitignore` should ignore `docs` folder.

Separate functions with lines:

     function love()
       talk()
       if laugh() then
         return smile() end end
     --------------------------
     function hate()
       fight()
       steal()
       return 1 end

#### Directories

All files in the same directory.

All data in "/data" underneath some path name mentioned on `os.getenv("Lure")`.`

#### Printing

All files use `require "show"` which changes the default version of `print` and `tostring`. Note
that to hide a field from being printed (e.g. since it is too long), make its first letter an underscore.


#### Encapsulation

Module-based polytheism

- Modules usually have `create` `update` `updates`
- Module names are UPPER CASE
- Most functions and variables are local
- Modules end by returning a table of functions

#### Temptations (to avoid)

No use of meta tables (that way, madness lies).

No OO tricks (so many ways to do it... I found that I never stop experimenting).

#### Configuration

Global configuration options stored in `config` and reset to defaults using `defaults()`
(which are stored in the global `the`). So
a standard experiment starts with

    require "show"
    local R=require "random"
    local O=require "tests"
    local XX=require "moduleURtesting"

    local function _test1()
      defaults() -- set the defaults
      the.this.that = 10 -- override a default
      do something with XX
      assert(something)
    end 

    local function _anotherTest()
      defaults() -- set the defaults
      the.this.that = 4321 -- override a default
      do something else with XXX
      assert(something)
    end 

    R.seed(1) -- set the random seed
    O.k{_test1,_anotherTest} -- counts assertion failures, continue even if 1 crashes


---------------------------------------------------------

## Legal

<img align=right width=150 src="https://goo.gl/tjtpbE">
LURE, Copyright (c) 2017, Tim Menzies   
All rights reserved, BSD 3-Clause License

Redistribution and use in source and binary forms, with
or without modification, are permitted provided that
the following conditions are met:

- Redistributions of source code must retain the above
  copyright notice, this list of conditions and the 
  following disclaimer.
- Redistributions in binary form must reproduce the
  above copyright notice, this list of conditions and the 
  following disclaimer in the documentation and/or other 
  materials provided with the distribution.
- Neither the name of the copyright holder nor the names 
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

