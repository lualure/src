# LURE

<img align=right src="https://avatars6.githubusercontent.com/u/30064709?v=4&s=200">

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
|_Comprehensible_ :|  Something we can read, argue with : Essential for communities critiquing ideas.|
|_Fast_ :|  Not a CPU hog | Reproducing  and improving an old ideas means that you can reproduce that old result. Also, certifying that new ideas often means multiple runs overy many sub-samples of the data. Such  reproducability and
certification is impractical when such repreduction is impractically slow|
|_Light_ :| Small memory footprint |Again, reproducing an old data mining experiment or certifying a new result
means that the resources required
for reproduction are not exobertant. |
|_Goal-aware_ :| Different goals means different models. AND multiple goals = no problem!|This is important since
most data miners build models that optimizer for a single goal (e.g. minimize error or least-square error) yet business
users often wnat their data miners to achieve many goals. |
|_Humble_ :|  Can publish succinct certification envelope (so we know when not to trust)| Delivered data mined models
should be able to recognize when new data is out-of-scope of anything they've seen before. This means, at runtime,
having access to the data used to build that model. |
|_Privacy-aware_ :|  Can hide an individual's data|This is essential when XXX | 
|_Shareable_ :|  Knows how to transfer models, data, between contexts|
|_Context-aware_ :|  Knows that local parts of data ⇒ different models. Knows how to find different contexts|
|_Anomaly-aware_ :|  Can detect when new inputs differ from old training data|
|_Self-tuning_ :|  And can do it quickly|
|_Incremental_ :|  Can update old models with new data|


Recently my graduate students starting using  Bayesian Parameter Optimization where instead of using Gaussian
Process Models (which have dimensionality limitations; e.g. 12 vars max), they used
Random Forests.  One of my students, Vivek Nair, tried doing BPO multi-objective optimization
with CART (one tree per  objective). [It worked very well](https://arxiv.org/pdf/1705.05018.pdf).

This code is my attempt to extend and simplify Vivek's system, written in LUA (LUA= SCHEME without brackets).
Why LUA? Cause odds are none of my students have ever coded in LUA  so I can set assignments like
"here is an executable specification, now port it to <yourFavLanguage>".

Lure:

- adds a _domination_ score to each row;
- builds a CART tree to minimize variance of the domination scores;
- builds that tree for, say, 20 examples, 
- uses that tree to guess, say, 128 more examples
- picks the (best,worst) guess from those examples,
- computes the tree error by comparing the guesses to actual
- add those (best,worst) guesses to the training set (which now has 22 examples)
- repeat, until error stabilizes.

So, in theory, that gives us:

- multi-objective optimization, 
- tiny memory footprints
- incremental learning,  
- active learning 
    - only need real scores on the initial pop and the next guesses
- succinct models 
    - tiny trees
- explanation
    - show the trees
- planning
    - using the [Krishna mutator](https://arxiv.org/pdf/1609.03614.pdf), 
      generate plans and monitors from the trees.
- data compression
    - only keep the intial pop and the learned examples
- data sharing
    - only share the compressed data
- data privacy
    - use the [Peters mutator](http://menzies.us/pdf/15lace2.pdf) on the shared data

Also, if ever new data shows up, this also gives us:

- anomaly detector 
    - if new examples fall to leaves in the current tree that are very distant,
  then you've not seen that example before)
- a way to learn when not to learn 
    - of the error rate remains low on newly arrived examples,
- a way to start learning again 
    - if the anomaly detector triggers 
    - if the error rate on new examples spikes, start the learner again

Like I say, in theory. As to what actually happens in practice, well, we shall see.

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

