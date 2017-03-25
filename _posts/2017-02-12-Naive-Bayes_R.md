---
layout: post
title: 'Naive Bayes Classifier (R code)'
date: 2017-02-12
author: Yin-Ting 
categories: [R]
tags: [Classification, Supervised, e1071]
---
### Overview 
This post shows the R code for Naive Bayes Classifier by using 

[try](#123)


### Details
* **<font size="4">Resources for Package 'e1071'</font>** 

  * [CRAN - Package 'e1071'](https://cran.r-project.org/web/packages/e1071/index.html)
  * [Package ‘e1071’ - Reference manual](https://cran.r-project.org/web/packages/e1071/e1071.pdf)

* **<font size="4"> Example Code (e1071::naiveBayes())</font>** <br />

{% highlight r %}
#######################
#### Generate Data ####
#######################
X1=c(rep("yes",10),rep("no",40),rep("yes",70),rep("no",30))
X2=c(rep("yes",10),rep("no",10),rep("unsure",30),
     rep("yes",40),rep("no",50),rep("unsure",10))
train=data.frame(X1,X2, Type=c(rep("A",50),rep("B",100)))
test=data.frame(X1="yes",X2="unsure")

################################
#### Naive Bayes Classifier ####
################################
if (!require("e1071")) install.packages("e1071")
(m=naiveBayes(Type ~ ., data = train))
{% endhighlight %}



{% highlight text %}
## 
## Naive Bayes Classifier for Discrete Predictors
## 
## Call:
## naiveBayes.default(x = X, y = Y, laplace = laplace)
## 
## A-priori probabilities:
## Y
##         A         B 
## 0.3333333 0.6666667 
## 
## Conditional probabilities:
##    X1
## Y    no yes
##   A 0.8 0.2
##   B 0.3 0.7
## 
##    X2
## Y    no unsure yes
##   A 0.2    0.6 0.2
##   B 0.5    0.1 0.4
{% endhighlight %}



{% highlight r %}
(p=predict(m, test))
{% endhighlight %}



{% highlight text %}
## [1] B
## Levels: A B
{% endhighlight %}

<a id="123"/> jhkjhkjh

