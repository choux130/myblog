---
layout: post
title: 'Naive Bayes Classifier'
date: 2017-02-12
author: Yin-Ting 
categories: [Statistics, R]
tags: [Classification, Supervised]
---
### Overview
This post is my note about Naive Bayes Classifier, a classification teachniques. All the contents in this post are based on my reading on many resources which were listed in the References part at the end of the post.  

Naive Bayes Classifier is a classification method based on Bayes' Theorem[^1] with two assumptions on predictors: 
1. All the predictors have equal importance to the response variable.
2. All the predictors are conditional independent to each other given in any class. 

Even though these assumptions may cause the weakness[^2] of this method, it does not affect its competitive performance on prediction. The ideal data for Naive Bayes Classifier is a categorical response variable and categorical explanatory variables but if we have numeric variables, it still can work by converting them into categorical variables by binning them which needs enough knowledge and experience on data. We also can add some bayesian concept (prior probability) into this method by adding Laplace Estimator in the algorithm[^3]. And in the end of this post, I have a simple example about Naive Bayes Classifier. 

***

### References
* **Books**
1. [The Elements of Statistical Learning:Data Mining, Inference, and Prediction](https://statweb.stanford.edu/~tibs/ElemStatLearn/)
2. [An Introduction to Statistical Learning with Applications in R](http://www-bcf.usc.edu/~gareth/ISL/)
3. [Machine Learning with R](https://github.com/stedy/Machine-Learning-with-R-datasets)

* **Online Materials**

***

### Details

[^1]:
    **Bayes' Theorem** 

[^2]:
    **Strengths and Weaknesses**

[^3]:
    **Laplace Estimator**
    
[^4]:
    **A Simple Example**
    

