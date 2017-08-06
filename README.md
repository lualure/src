# LURE: SE for  Data Mining

<img align=right src="https://avatars6.githubusercontent.com/u/30064709?v=4&s=200">
## What is LURE?

Don't think of LURE as a conclusion, as a finished work.
Instead think of it is as bait-- a temptation to make you
reflecting on what (and how) services should be added to data mining software.

## Why LURE?

There has ben much recent work applying data miners to software engineering. But what about the
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
to muck around inside data miners. The code is written in LUA since that makes it very protale, small footprint,
succinct, and hence easily modifable (and for students who not know how to write LUA code,
I can use LURE as a kind of assignment specification; e.g. write this code in your favorite language).

## Status

LURE is about 
about one-third
built and about one-tenth tested. But its good to have dreams since 
["a man's (sic) reach should exceed his grasp, Or what's a heaven for?"](https://www.poetryfoundation.org/poems/43745/andrea-del-sarto).

The goal of this code is to offer _baseline_ implementations of the following operators. 

|Operator | What| Why|
|------:|:--------|:--------|
|_Comprehensible_ :|  Something we can read, argue with | Essential for communities critiquing ideas. If the only person reading a model is a carbureter, then we can expect little push back. But if your models are about policies that humans have to implement, then I take it as axiomatic that humans will want to read and critique the models.|
|_Fast_ :|  Not a CPU hog | Reproducing  and improving an old ideas means that you can reproduce that old result. Also, certifying that new ideas often means multiple runs overy many sub-samples of the data. Such  reproducability and certification is impractical when such repreduction is impractically slow|
|_Light_ :| Small memory footprint |Again, reproducing an old data mining experiment or certifying a new result means that the resources required for reproduction are not exobertant. |
|_Goal-aware_ :| Different goals means different models. AND multiple goals = no problem!|This is important since most data miners build models that optimizer for a single goal (e.g. minimize error or least-square error) yet business users often wnat their data miners to achieve many goals. |
|_Humble_ :|  Can publish succinct certification envelope (so we know when not to trust)| Delivered data mined models should be able to recognize when new data is out-of-scope of anything they've seen before. This means, at runtime, having access to the data used to build that model. Note that phrase _succinct_ here: certification envelopes cannot include all the data relating to a model, otherwise every hard drive in the world will soon fill up.  |
|_Privacy-aware_ :|  Can hide an individual's data|This is essential when sharing a certification envelope | 
|_Shareable_ :|  Knows how to transfer models, data, between contexts. | Such transfer usually requires some transformation of the soruce data to the target data.|
|_Context-aware_ :|  Knows that local parts of data generate different models. | While general principles are good, so too is how to handle particular contexts. For example, in general, exercise is good for maintaining healthy. However, in the particular context of  patients who have jsut had cardiac surgery, then that general principle has to be carefully tailored to particular patients. | ideas need to be updated. |
|_Self-tuning_ :|  And can do it quickly| Many experiments show that we can't just use data miners off-the-shelf.  Rather, if their control parameters are tuned, then we can get much better data mining results.|
|_Anomaly-aware_ :|  Can detect when new inputs differ from old training data| This is the trigger for when old
|_Incremental_ :|  Can update old models with new data| Anomaly detectors tell us something has to change.  Incremental learners tell us what to change.| 

Note that I describe these as _baselines_.  LURE currently implements
some of the above (and more each week)-- but you should be critical of the technical
choices I made in that implmenetation. What simplifications did I
make? What better technologies should I use? What did I overlook?
If you think you can handle the above in (e.g.)
[TensorFlow](https://www.tensorflow.org/)
  or [Torch](http://torch.ch/), I would
lean forward and say "yes? really? show me how".

## Install

### Using LuaRocks

Coming soon.

### Using Github

Check out the repo, then create an environment
variable `Lure` to hold the repo's localtion.

    git clone http://github.com/lualure/src src
    Lure=$PWD/src 

Add the following function to your $HOME/.bashrc.

    lure() { 
      f=$(basename $1 .lua).lua
      shift
      if [ -f "$Lure/lib/$f" ]; then
        LUA_PATH="$Lure/lib/?.lua;;" $(which luajit) $Lure/lib/$f "$*"
        return 0
      fi
      echo "not found $f"
    }

Make sure your source this code; e.g. logout then log
back in or (much faster):

    . ~/.bashrc

## Test

Change directories to some other part of your computer (away from the source code). Then
try to run any code from lure. e.g.

    $ lure listsok
    # test:	1
    0.000167 secs
    # test:	2
    1.1e-05 secs
    # test:	3
    3.9999999999997e-06 secs
    # test:	4
    4e-05 secs
    :pass 4 :fail 0 :percentPass 100%
    -- Global: the
    -- Global: defaults

The above code is reporting that none of the `listsok` tests can file fault with the `lists`
functions (hence `:fail 0`). It also shows that those tests run fast (in tenths of milliseconds)
and that this code suffers from only two globals `the` and `defaults` (and these two are meant to
be the only defaults known to  the system-- see the notes on coding style, below).

## Coding Style

If you are rading my code, it might save some time if you [know my Lua writing style](STYLE.md).


## Learning Lure

- website: [https://lualure.github.io/info/](https://lualure.github.io/info/)
- [news](https://twitter.com/lua_lured)
- [discuss](https://groups.google.com/forum/#!forum/lualure)
- [issues](https://github.com/lualure/src/issues) 

## Learning Lua

Some great on-line resources:

- Quick start http://tylerneylon.com/a/learn-lua/
- [Read the book](https://www.lua.org/pil/).
    - The 4th edition in [on Amazon](https://www.amazon.com/Programming-Lua-Fourth-Roberto-Ierusalimschy/dp/8590379868/ref=pd_lpo_sbs_14_t_0?_encoding=UTF8&psc=1&refRID=MFJR3QK7P99NY833BJYN).
    - The 2nd edition (which is still pretty good) is available [on-line](http://index-of.es/Programming/Lua/Programming%20in%20Lua.pdf).

