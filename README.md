[Home](INDEX) | [Why](WHY) | [What](WHAT) | [Guide](GUIDE)


<img align=right src="https://avatars6.githubusercontent.com/u/30064709?v=4&s=200">



There has been [much recent work applying data miners to software engineering](https://goo.gl/NAs3Nu). But what about the
other way around? What software engineering principles should be apply to data miners? After decades
of use of data miners, what services should we demand from our data miners, and how do we build those services?

LURE is a workbench for  exploring SE for data mining.
The premise of LURE is that data miners are _not_ black boxes that we should buy, then uncritically use "as-is",
without modification.
Rather,
data miners are just software and software contains 100s of design choices that effects what is learned:

- Some of those choices may not be appropriate for your specific needs. 
- Also, some of those choices
might actually be sub-optimum for your domain.
- Further, if you actually understand the internals of a data miner, you can mix and match what data miners
do in order to provide useful and innovative solutions to your data mining tasks.

So LURE is a set of minimal data mining tools designed with the goal of letting their students "roll their sleeves up"
to muck around inside data miners. The code is written in LUA since that makes it very portable, small footprint,
succinct, and hence easily modifiable (and for students who not know how to write LUA code,
I can use LURE as a kind of assignment specification; e.g. write this code in your favorite language).


### Status

LURE is about 
about one-third
built and about one-tenth tested. But its good to have dreams since 
["a man's (sic) reach should exceed his grasp, Or what's a heaven for?"](https://www.poetryfoundation.org/poems/43745/andrea-del-sarto).

### Coding Style

If you are reading my code, it might save some time if you [know my Lua writing style](STYLE.md).


### Learning Lure

- website: [https://lualure.github.io/info/](https://lualure.github.io/info/)
- [news](https://twitter.com/lua_lured)
- [discuss](https://groups.google.com/forum/#!forum/lualure)
- [issues](https://github.com/lualure/src/issues) 

### Learning Lua

Some great on-line resources:

- Quick start http://tylerneylon.com/a/learn-lua/
- [Read the book](https://www.lua.org/pil/).
    - The 4th edition in [on Amazon](https://goo.gl/D4dwGi).
    - The 2nd edition (which is still pretty good) is available [on-line](https://goo.gl/jgwXVZ).


## Legal

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
