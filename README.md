# LURE

<img align=right src="https://avatars6.githubusercontent.com/u/30064709?v=4&s=200">

LURE is a set of minimal data mining tools designed with the goal of letting their students "roll their sleeves up"
to much around inside data miners. The idea here is that data miners are just another kind of software. So just
as we do test-driven software development, we should also build our data miners such that
person2 might be able to critique and improve the models build by person1.

(Note: in terms of deliverting on the following grandiose promises, LURE  is about one-third
built and about one-tenth tested. But its good to have dreams since 
["a man's (sic) reach should exceed his grasp, Or what's a heaven for?"](https://www.poetryfoundation.org/poems/43745/andrea-del-sarto).

## Trust issues (with software)

<img src="http://www.publicdomainpictures.net/pictures/80000/t2/silhouette-boy-with-hands-up.jpg" align=left width=300>
Put your hand up if you are worried about the
increasing use of of
software (and especially data mining software) to control, well, everything; e.g.

- Nobel-prize winning chemists use software  [to make their discoveries](http://goo.gl/Lwensc); 
- Engineers use software to [designs many thing]( http://goo.gl/qBMyIZ)
  including optical tweezers, radiation therapy, remote sensing,  chip design;  
- Web analysts use software  to analyze clickstreams to [improve sales and marketing strategies](http://goo.gl/b26CfY);
- Stock traders write software to [simulate trading strategies](http://www.quantopian.com);
- Analysts write software  to mine   labor statistics data to [review proposed gov policies](http://goo.gl/X4kgnc);
- Journalists use software   to analyze economic data, make visualizations [of their news stories](http://fivethirtyeight.com);
- In London or New York,  ambulances wait for your call at a location [determined by a software model](http://goo.gl/8SMd1p).
- Etc etc etc  


In this century, much of what we can see and what we can do is selected and mediated and
controlled  and restricted by software.  This is a worry since
humans screw things up, [all the
time](https://en.wikipedia.org/wiki/List_of_cognitive_biases),
particualrly when [designing or building or using
software](http://seclists.org/risks/).
So how can we  trust  all that software?
How can
we tune it to our specific needs? How can we recognize when we should not use it?


## Trusting what we learn from data miners

In the general case of all softwware, I have little to say since "all software" is a very wide range of stuff.
But in the specific case of data mining software, there are very specific (and simple and general) things
we can do to increase the odds that person2 can critique and improve the models build my person1.


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

