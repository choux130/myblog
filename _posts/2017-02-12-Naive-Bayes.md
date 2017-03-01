---
layout: post
title: 'Naive Bayes Classifier'
date: 2017-02-12
author: Yin-Ting 
categories: [Methodology, R]
tags: [Classification, Supervised, e1071]
---
### Overview
Naive Bayes Classifier is a simple and intuitive method for the classification. The algorithm is based on Bayes' theorem with two assumptions on predictors: conditionally independent and equal importance. This technique mainly works on categorical response and explanatory variables. But it still can work on numeric explanatory variables as long as it can be transformed to categorical variables. 

This post is my note about Naive Bayes Classifier, a classification teachniques. All the contents in this post are based on my reading on many resources which are listed in the References part.  

***

### Details
* **<font size="4">Name</font>** <br />
  Naive Bayes Classifier

* **<font size="4">Data Type</font>** <br />
  * **Reponse Variable**: Categorical <br />
  * **Explanatory Variable**: Categorical and Numeric <br />
  (The numeric variables need to be discretized by binning or using probability density function.) <br />
  The below picture originated from : [here](http://www.saedsayad.com/naive_bayesian.htm)
<img src="{{ site.baseurl }}/assets/image/numeric.png"/>

* **<font size="4">Assumptions</font>** <br />
  1. All the predictors have equal importance to the response variable.
  2. All the predictors are conditional independent to each other given in any class. 


* **<font size="4"> Bayes' Theorem</font>** 

  $$
  \begin{align}
  P(A|B) &= \frac{P(A \cap B)}{P(B)} \\
  &= \frac{P(B|A)P(A)}{P(B)} \\
  &= \frac{P(B|A)P(A)}{\sum_{i}^{}P(B|{A}_{i})P({A}_{i})}      
  \end{align}
  $$

* **<font size="4">Algorithm</font>** <br />
Given a class variable $$Y= \{ 1, 2,..., K \}, K\geq2$$ and  explanatory variables, $$X=\{ X_1, X_2,..., X_p \}$$, the Bayes' Theorem can be written as: 

  $$
  \begin{align}
  P(Y=k|X=x) &= \frac{P(X=x|Y=k)P(Y=k)}{P(X=x)} \\
  &= \frac{P(X=x|Y=k)P(Y=k)}{\sum_{i=1}^{K}P(X=x|Y=i)P(Y=i)}
  \end{align}
  $$
  
  The Naive Bayes Classifier is a function, $$C \colon \mathbb{R}^p \rightarrow \{ 1, 2,..., K \}$$ defined as 
  
  $$
  \begin{align}
  C(x) &=\underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}P(Y=k|X=x) \\
      &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}P(X=x|Y=k)P(Y=k) \\
      \quad &(\text{by assuming that } X_1,...,X_p \text{ are conditionally independent when given } Y=k, \forall k\in \{ 1, 2,..., K \}) \\
      &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}P(X_1=x_1|Y=k)P(X_2=x_2|Y=k)\cdots P(X_p=x_p|Y=k)P(Y=k) 
  \end{align}
  $$
  
* **<font size="4">Strengths and Weaknesses</font>** <br /> 
  * **Strengths**: <br />
    1. simple and effective 
  * **Weaknesses**: <br />
    1. hard to meet the assumptions of eaqual important and mutual independence on predictors. 
    2. not good to deal with many numeric predictors. 

* **<font size="4">Key Points</font>** <br />
    1. the boundary line for the naive bayes classfier is linear and can be derived from its algorithm. 
$$
\begin{align}
    
\end{align}
$$


* **<font size="4">A Simple Example</font>** <br />
Suppose we have a contingency table like this: 
<img src="{{ site.baseurl }}/assets/image/table.png">
  
  And, what will be our guess on type if we have a data has X1="Yes" and X2="Unsure"? <br />
  Our guess is Type B. 

$$
\begin{align}
P(A|X_1=\text{"Yes"}, X_2=\text{"Unsure"}) &\propto P(X_1=\text{"Yes"}, X_2=\text{"Unknown"}|A)P(A) \\
  &= P(X_1=\text{"Yes"}|A)P(X_2=\text{"Unsure"}|A)P(A) \\
  &= \frac{10}{50} \cdot \frac{30}{50} \cdot \frac{50}{150} \\
  &= \frac{1}{25} \\
\\  
P(B|X_1=\text{"Yes"}, X_2=\text{"Unsure"}) &\propto P(X_1=\text{"Yes"}, X_2=\text{"Unsure"}|B)P(B) \\
  &= P(X_1=\text{"Yes"}|B)P(X_2=\text{"Unsure"}|B)P(Type=B) \\
  &= \frac{70}{100} \cdot \frac{10}{100} \cdot \frac{100}{150} \\
  &= \frac{14}{300} \\
\\
C(X_1=\text{"Yes"}, X_2=\text{"Unsure"}) &= \underset{k\in \{ A, B \} }{\operatorname{argmax}}P(Y=k|X_1=\text{"Yes"}, X_2=\text{"Unsure"}) \\
      &= B 
\end{align}
$$

* **<font size="4">R code (e1071::naiveBayes())</font>** <br />

{% highlight r %}
X1=c(rep("yes",10),rep("no",40),rep("yes",70),rep("no",30))
X2=c(rep("yes",10),rep("no",10),rep("unsure",30),
     rep("yes",40),rep("no",50),rep("unsure",10))
train=data.frame(X1,X2, Type=c(rep("A",50),rep("B",100)))
test=data.frame(X1="yes",X2="unsure")

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

* **<font size="4">Further topics</font>** <br />
  * **Laplace Estimator** ([Machine Learning with R](http://shop.oreilly.com/product/9781784393908.do), Chapter 4) <br />
  Adding a small number to the frequency table to avoid zero probability for the Naive Bayes Classifier. 

***

### References
* **Books**
1. [The Elements of Statistical Learning:Data Mining, Inference, and Prediction)](https://statweb.stanford.edu/~tibs/ElemStatLearn/)
2. [An Introduction to Statistical Learning with Applications in R](http://www-bcf.usc.edu/~gareth/ISL/)
3. [Machine Learning with R](http://shop.oreilly.com/product/9781784393908.do)

* **Online Materials**
1. [An image about transforming numeric variables](http://www.saedsayad.com/naive_bayesian.htm)
2. [Package ‘e1071’](https://cran.r-project.org/web/packages/e1071/e1071.pdf)

***
