---
layout: post
title: "Parallel Computing in R"
date: 2017-11-16
author: Yin-Ting 
output: html_document
categories: [Others]
tags: [R, foreach, doParallel, doSNOW]
---
### Overview
In my work, I usually deal with dataset of products from different customers across different market places. Basically, each product has its own time series dataset. The size of each dataset is not big but we have millions of them. Before finding any convincing reasons to combine dataset from different products, now we just treat them all as independent dataset. And, since they are all independent, it is definitely a good idea to use parallel computing to push the limit of our machine and to make code executed efficiently. This post is a lite version about how I do parallel computing in R. 


### Details
* **<font size="4">References</font>** <br />
  1. [Getting Started with doParallel and foreach](https://cran.r-project.org/web/packages/doParallel/vignettes/gettingstartedParallel.pdf)
  2. [Using The foreach Package](https://cran.r-project.org/web/packages/foreach/vignettes/foreach.pdf)
  3. [Monitoring progress of a foreach parallel job](http://blog.revolutionanalytics.com/2015/02/monitoring-progress-of-a-foreach-parallel-job.html)
  4. [Package 'foreach'](https://cran.r-project.org/web/packages/foreach/foreach.pdf)
  5. [Package 'doParallel'](https://cran.r-project.org/web/packages/doParallel/doParallel.pdf)
  6. [Package 'doSNOW'](https://cran.r-project.org/web/packages/doSNOW/doSNOW.pdf)
  
* **<font size="4">Run in Parallel</font>** <br />

{% highlight r %}
#### Import Libraries ####
.packages = c("foreach","doParallel", "doSNOW")
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst], repos = "http://cran.us.r-project.org")
notshow = lapply(.packages, require, character.only=TRUE)

#### Define the function ####
CreateDataFrame = function(value, times){
  d = rep(value, times = times)
  return(d)
}

#### Run Parallelly ####
num_core = detectCores() - 2 # detect # of CPU cores 
cl = makeCluster(num_core, outfile = "") # define the clusters
registerDoSNOW(cl)

# print out the progress for every iteration
progress <- function(n) cat(sprintf("task %d is complete\n", n))
opts <- list(progress=progress)

start.time = proc.time() # calculate the execution time
output_par = 
  foreach(i = 1:5, .options.snow = opts, .errorhandling = 'pass') %dopar% 
  # the default .combine = list 
  {
    out = CreateDataFrame(c(1:i), 3)
    out
  }
{% endhighlight %}



{% highlight text %}
## task 1 is complete
## task 2 is complete
## task 3 is complete
## task 4 is complete
## task 5 is complete
{% endhighlight %}



{% highlight r %}
stopCluster(cl) # stop the cluster in the end
(end.time = proc.time() - start.time) # total execution time
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.059   0.002   0.080
{% endhighlight %}



{% highlight r %}
output_par
{% endhighlight %}



{% highlight text %}
## [[1]]
## [1] 1 1 1
## 
## [[2]]
## [1] 1 2 1 2 1 2
## 
## [[3]]
## [1] 1 2 3 1 2 3 1 2 3
## 
## [[4]]
##  [1] 1 2 3 4 1 2 3 4 1 2 3 4
## 
## [[5]]
##  [1] 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
{% endhighlight %}
