

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


