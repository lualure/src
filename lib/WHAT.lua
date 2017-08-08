-- -------
--
-- [Why](WHY) | [Install](INSTALL) | What | [Guide](GUIDE) | [Style](STYLE) 
--
-- ------
-- 
-- I claim data science is about science; i.e. it is about 
-- a community carefully curating and improving a collecting of idea. So, in my view,  it is not
-- enough to merely make conclusions. Rather, those conclusions need to be monitoried and updated (when appropriate).
--
-- So LURE implements the following set of operators that I say need to be part of any data mining toolkit that supports
-- science. 
-- THere is no claim here of completeness of these tools. 
-- You should be very critical of the technical
-- choices I made in that implementation. What simplifications did I
-- make? What better technologies should I use? What did I overlook?
-- If you think you can handle the above in (e.g.)
-- [TensorFlow](https://www.tensorflow.org/)
--   or [Torch](http://torch.ch/) or using 100 other methods,  I would
-- lean forward and say "yes? really? show me how".
--
--
-- _Comprehension_:
-- 
-- - Something we can read, argue with 
-- - Essential for communities critiquing ideas. If the only person reading a model is a carburetor, then we can expect little push back. But if your models are about policies that humans have to implement, then I take it as axiomatic that humans will want to read and critique the models.
-- 
-- _Fast_:
-- 
-- -   Not a CPU hog 
-- -  Reproducing  and improving an old ideas means that you can reproduce that old result. Also, certifying that new ideas often means multiple runs over many sub-samples of the data. Such  reproducibility and certification is impractical when such reproduction is impractically slow
-- 
-- _Light_:
-- 
-- -  Small memory footprint 
-- - Again, reproducing an old data mining experiment or certifying a new result means that the resources required for reproduction are not exorbitant. 
-- 
-- _Goal-aware_:
-- 
-- -  Different goals means different models. AND multiple goals = no problem!
-- - This is important since most data miners build models that optimizer for a single goal (e.g. minimize error or least-square error) yet business users often want their data miners to achieve many goals. 
-- 
-- _Humble_ :
-- 
-- -   Can publish succinct certification envelope (so we know when not to trust)
-- -  Delivered data mined models should be able to recognize when new data is out-of-scope of anything they've seen before. This means, at runtime, having access to the data used to build that model. Note that phrase _succinct_ here: certification envelopes cannot include all the data relating to a model, otherwise every hard drive in the world will soon fill up.  
-- 
-- _Privacy-aware_:
-- 
-- -   Can hide an individual's data
-- - This is essential when sharing a certification envelope 
-- 
-- _Shareable_:
-- 
-- -   Knows how to transfer models, data, between contexts. 
-- -  Such transfer usually requires some transformation of the source data to the target data.
-- 
-- _Context-aware_:
-- 
-- -   Knows that local parts of data generate different models. 
-- -  While general principles are good, so too is how to handle particular contexts. For example, in general, exercise is good for maintaining healthy. However, in the particular context of  patients who have just had cardiac surgery, then that general principle has to be carefully tailored to particular patients. 
--   ideas need to be updated. 
-- 
-- _Self-tuning_:
-- 
-- -   And can do it quickly
-- -  Many experiments show that we can't just use data miners off-the-shelf.  Rather, if their control parameters are tuned, then we can get much better data mining results.
-- 
-- _Anomaly-aware_:
-- 
-- -   Can detect when new inputs differ from old training data
-- -  This is the trigger for when old
-- 
-- 
-- _Incremental_:
-- 
-- -   Can update old models with new data
-- -  Anomaly detectors tell us something has to change.  Incremental learners tell us what to change.
-- 
-- 
