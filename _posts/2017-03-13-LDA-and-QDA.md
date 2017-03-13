---
layout: post
title: "LDA and QDA"
author: "Yin-Ting Chou"
date: 2017-03-13
categories: [Methodology, R]
tags: [Classification, Supervised, MASS]
---
### Overview
LDA and QDA is also a method based on Bayes' Theorem with assumption on conditional Multivariate Normal Distribution. Because of this assumption, LDA and QDA can only be used when all explanotary variables are numeric.

This post is a summary of what I learned about LDA and QDA. To have a clear idea about this topic, I tried my best to write all the mathematical derivations as clear and complete as possible. So, this post may look a little bit scaring. 

***

### Details
* **<font size="4">Name</font>** <br />
  Linear Discriminant Analysis (LDA) <br />
  Quadratic Discriminant Analysis (QDA)

* **<font size="4">Data Type</font>** <br />
  * **Reponse Variable**: Categorical <br />
  * **Explanatory Variable**: Numeric <br />
  
* **<font size="4">Assumptions</font>** <br />
  * **LDA**: <br />
    Given a class $k$, the predictors in this class, $X_k=(X_{1k},X_{2k},\cdots,X_{pk})$, follows multivariate normal distribution with mean $\mu_k$ and covariance matrix $\Sigma$. And, the covariance matrix are all the same for all classes.  

  $$
  \begin{align}
  P(X=x|Y=k) &= N(\mu_k, \Sigma) \\[5pt]
  \text{where    } \mu_k &= 
  \begin{pmatrix}
  \mu_{1k}\\ 
  \mu_{2k}\\ 
  \vdots\\ 
  \mu_{pk}
  \end{pmatrix} \\[5pt]
  \Sigma &=
  \begin{pmatrix}
  \sigma_1^2&  \sigma_{12}&  \cdots& \sigma_{1p} \\ 
  \sigma_{12}&  \sigma_2^2&  \cdots& \sigma_{2p}\\ 
  \vdots&  \vdots&  \ddots& \vdots\\
  \sigma_{1p}& \sigma_{2p} & \cdots & \sigma_p^2
  \end{pmatrix}, \, \forall \,k
  \end{align}
  $$
  
  * **QDA**: <br />
  Given a class $k$, the predictors in this class, $X_k=(X_{1k},X_{2k},\cdots,X_{pk})$, follows multivariate normal distribution with mean $\mu_k$ and covariance matrix $\Sigma_k$. And, the covariance matrix can **NOT** be the same for all classes.  

  $$
  \begin{align}
  P(X=x|Y=k) &= N(\mu_k, \Sigma_k) \\[5pt]
  \text{where    } \mu_k &= 
  \begin{pmatrix}
  \mu_{1k}\\ 
  \mu_{2k}\\ 
  \vdots\\ 
  \mu_{pk}
  \end{pmatrix} \\[5pt]
  \Sigma_k &=
  \begin{pmatrix}
  \sigma_{1_k}^2&  \sigma_{12_k}&  \cdots& \sigma_{1p_k} \\ 
  \sigma_{12_k}&  \sigma_{2_k}^2&  \cdots& \sigma_{2p_k}\\ 
  \vdots&  \vdots&  \ddots& \vdots\\
  \sigma_{1p_k}& \sigma_{2p_k} & \cdots & \sigma_{p_k}^2
  \end{pmatrix} 
  \end{align}
  $$
   
   {% highlight r %}
     if (!require("ggplot2")) install.packages("ggplot2")
     if (!require("MASS")) install.packages("MASS")
     if (!require("grid")) install.packages("grid")
     if (!require("gridExtra")) install.packages("gridExtra")
     
     ########################################
     #### Generate Bivariate Normal Data ####
     ########################################
     set.seed=12345
     bvm=function(m1,m2,sigma1,sigma2,n1,n2){
      d1 <- mvrnorm(n1, mu = m1, Sigma = sigma1 ) 
      d2 <- mvrnorm(n2, mu = m2, Sigma = sigma2 )
      d=rbind(d1,d2)
      colnames(d)=c("X1","X2")
      d=data.frame(d)
      d$group=c(rep("1",n1),rep("2",n2))
      list(data = d)
     }
   
     m_1 <- c(0.5, -0.5) 
     m_2 <- c(-2, 0.7) 
     sigma_1 <- matrix(c(1,0.5,0.5,1), nrow=2)
     sigma_2 <- matrix(c(0.8,-0.7,-0.7,0.8), nrow=2)
   
     p1=ggplot(bvm(m_1,m_2,sigma_1,sigma_1,n1=2000,n2=2000)$data, 
      aes(x=X1, y=X2)) + 
      stat_density2d(geom="density2d", aes(color = group),contour=TRUE)+
      ggtitle("LDA assumption")
     p2=ggplot(bvm(m_1,m_2,sigma_1,sigma_2,n1=2000,n2=2000)$data, 
      aes(x=X1, y=X2)) + 
      stat_density2d(geom="density2d", aes(color = group),contour=TRUE)+
      ggtitle("QDA assumption")
     grid.arrange(p1, p2, ncol = 2)
   {% endhighlight %}
   
   ![plot of chunk unnamed-chunk-1](/myblog/figure/source/2017-03-13-LDA-and-QDA/unnamed-chunk-1-1.png)

* **<font size="4">Multivariate Normal Distribution</font>** <br />
  
  $$
  \begin{align}
  X \sim N(\mu, \Sigma) &= \frac{1}{(2\pi)^\frac{p}{2}|\Sigma|^\frac{1}{2}}\exp(-\frac{1}{2}(X-\mu)^T\Sigma^{-1}(X-\mu)) 
  \end{align}
  $$

* **<font size="4">Algorithm</font>** <br />
Given a class variable $$Y= \{ 1, 2,..., K \}, K\geq2$$ and  explanatory variables, $$X=\{ X_1, X_2,..., X_p \}$$, the Bayes' Theorem can be written as: 
  * **LDA**: <br />
  
    $$
    \begin{align}
    P(Y=k|X=x) &= \frac{P(X=x|Y=k)P(Y=k)}{P(X=x)} \\[5pt]
    &= \frac{P(X=x|Y=k)P(Y=k)}{\sum_{i=1}^{K}P(X=x|Y=i)P(Y=i)} 
    \end{align}
    $$
  <br /><br />
    Then, we define a classifier which is a function, $$C \colon \mathbb{R}^p \rightarrow \{ 1, 2,..., K \}$$ and <br /><br />
  
    $$
  \begin{align}
  C(x) &=\underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}P(Y=k|X=x) \\[5pt]
      &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}\log P(Y=k|X=x) \\[5pt] 
      &\propto \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log P(X=x|Y=k) + \log P(Y=k) \\[5pt]
      \quad &(\text{by assuming that } P(X=x|Y=k) \sim N(\mu_k, \Sigma)) \\[5pt]
      &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log N(\mu_k, \Sigma) + \log P(Y=k) \\[5pt]
      &=  \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log [\frac{1}{(2\pi)^\frac{p}{2}|\Sigma|^\frac{1}{2}}\exp(-\frac{1}{2}(X-\mu_k)^T\Sigma^{-1}(X-\mu_k))] + \log P(Y=k) \\[5pt]
      &\propto \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}  -\frac{1}{2}(X-\mu_k)^T\Sigma^{-1}(X-\mu_k) + \log (Y=k) \\[5pt]
      &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}  X^T\Sigma^{-1}\mu_k - \frac{1}{2}\mu_k^T\Sigma\mu_k + \log P(Y=k) \\[5pt]
      &\equiv  \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \delta_k(x)
  \end{align}
   $$
    <br /><br />
    To calculate $C(X)$, we need to plug in the following estimates which are all unbiased. 
    
    $$
    \begin{align}
    \hat{P}(Y=k) &= \frac{n_k}{n}, \quad \sum_{i=1}^{K}n_i = n \\[5pt]
    \hat{\mu_k} &= \begin{pmatrix}
    \hat{\mu_{1k}}\\ 
    \hat{\mu_{2k}}\\ 
    \vdots\\ 
    \hat{\mu_{pk}} 
    \end{pmatrix} = 
    \begin{pmatrix}
    \bar{X}_{1k} = \frac{1}{n_1}\sum_{i=1}^{n_1}x_{ik}\\ 
    \bar{X}_{2k}\\ 
    \vdots\\ 
    \bar{X}_{pk}
    \end{pmatrix} \\[5pt]
    \hat\Sigma &= \text{Pooled Covariance Matrix because of total K classes} \\[5pt]
    &= \frac{1}{n-K} \sum_{i=1}^{K}\sum_{j=1}^{n_k}(x_{jk}-\hat{\mu_k})(x_{jk}-\hat{\mu_k})^T
    \end{align}
    $$
 
  * **QDA**: <br />
    The function of classifier, $C(x)$, is as following. <br />
    
    $$
    \begin{align}
    C(x) &=\underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log P(Y=k|X=x) \\[5pt] 
    &\propto \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log P(X=x|Y=k) + \log P(Y=k) \\[5pt]
    \quad &(\text{by assuming that } P(X=x|Y=k) \sim N(\mu_k, \Sigma_k)) \\[5pt]
    &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log N(\mu_k, \Sigma_k) + \log P(Y=k) \\[5pt]
    &=  \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \log [\frac{1}{(2\pi)^\frac{p}{2}|\Sigma_k|^\frac{1}{2}}\exp(-\frac{1}{2}(X-\mu_k)^T\Sigma_k^{-1}(X-\mu_k))] + \log P(Y=k) \\[5pt]
      &\propto \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}  -\frac{1}{2}(X-\mu_k)^T\Sigma_k^{-1}(X-\mu_k) - \frac{1}{2}|\Sigma_k|+\log (Y=k) \\[5pt]
      &= \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}}  -\frac{1}{2}X^T\Sigma_kX+X^T\Sigma_k^{-1}\mu_k - \frac{1}{2}\mu_k^T\Sigma_k\mu_k - \frac{1}{2}|\Sigma_k| + \log P(Y=k) \\[5pt]
      &\equiv  \underset{k\in \{ 1, 2,..., K \} }{\operatorname{argmax}} \delta_k(x)
    \end{align}
    $$
    <br />
    <br />
    The estimators are the same as ones in LDA except for $\Sigma_k$.<br />
    <br />
    $$
    \begin{align}
    \hat\Sigma_k &= \text{Covariance Matrix in class k} \\[5pt]
    &= \frac{1}{n_k-1} \sum_{j=1}^{n_k}(x_{jk}-\hat{\mu_k})(x_{jk}-\hat{\mu_k})^T
    \end{align}
    $$
  
* **<font size="4">Decision Boundary</font>** <br /> 
  * **LDA**: <br />
    The decision boundary of LDA is a straight line which can be derived as below. 
    $$
    \begin{align}
    &\delta_k(x) - \delta_l(x) = 0 \\[5pt]
    &\Rightarrow X^T\Sigma^{-1}(\mu_k-\mu_l) - \frac{1}{2}(\mu_k+\mu_l)^T\Sigma(\mu_k-\mu_l)+\log \frac{P(Y=k)}{P(Y=l)} = 0 \\[5pt]       
    &\Rightarrow b_1x+b_0=0
    \end{align}
    $$

  * **QDA**: <br />
  The decision boundary of QDA is a quadratic line which can be derived as below. 
    $$
    \begin{align}
    &\delta_k(x) - \delta_l(x) = 0 \\[5pt]
    &\Rightarrow -\frac{1}{2}X^T(\Sigma_k -\Sigma_l)X + X^T(\Sigma_k^{-1}\mu_k-\Sigma_l^{-1}\mu_l)-\frac{1}{2}(\mu_k^T\Sigma_k\mu_k-\mu_l^T\Sigma_l\mu_l)-\frac{1}{2}(|\Sigma_k|-|\Sigma_l|)+\log\frac{P(Y=k)}{P(Y=l)}=0\\[5pt]       
    &\Rightarrow b_2x^2+b_1x+b0=0
    \end{align}
    $$
  <br /><br />
  The following graphs from [The Elements of Statistical Learning:Data Mining, Inference, and Prediction](https://statweb.stanford.edu/~tibs/ElemStatLearn/) gave us a clear idea how the decision bounday looks like in LDA and QDA. 
  
  <img src="{{ site.baseurl }}/assets/image/ldaqda_1.png" style="width:600px"/>
  <img src="{{ site.baseurl }}/assets/image/ldaqda_2.png" style="width:600px"/>

* **<font size="4">Strengths and Weaknesses</font>** <br /> 
  * **Strengths**: <br />
    1. It is a simple and intuitive method. 
  * **Weaknesses**: <br />
    1. In real life, it is really hard to have a dataset fit the assumption of multivariate normal distribution given classes. But we still can use this method even though the assumption is not met. 
    2. It only makes sense when all the predictors are numeric. 

* **<font size="4">R code (package:MASS, function:lda(), qda())</font>** <br />
  
  {% highlight r %}
  if (!require("MASS")) install.packages("MASS")
  #######################
  #### Generate Data ####
  #######################
  m_1 <- c(0.5, -0.5) 
  m_2 <- c(-2, 0.7) 
  sigma_1 <- matrix(c(1,0.5,0.5,1), nrow=2)
  sigma_2 <- matrix(c(0.8,-0.7,-0.7,0.8), nrow=2)
  
  # same covariance matrix
  set.seed(123)
  dd_1=bvm(m_1,m_2,sigma_1,sigma_1,n1=1000,n2=1500)$data
  # different covariance matrix
  dd_2=bvm(m_1,m_2,sigma_1,sigma_2,n1=1000,n2=1500)$data
  
  # the indice for the test data set
  ind_test=sample(1:dim(dd_1)[1],100)
  
  #############
  #### LDA ####
  #############
  m_lda=lda(group~X1+X2, data=dd_1[-ind_test,])
  m_lda
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Call:
  ## lda(group ~ X1 + X2, data = dd_1[-ind_test, ])
  ## 
  ## Prior probabilities of groups:
  ##         1         2 
  ## 0.3979167 0.6020833 
  ## 
  ## Group means:
  ##           X1         X2
  ## 1  0.4923038 -0.4671002
  ## 2 -2.0092639  0.6597143
  ## 
  ## Coefficients of linear discriminants:
  ##           LD1
  ## X1 -1.1162208
  ## X2  0.8287819
  {% endhighlight %}
  
  
  
  {% highlight r %}
  m_lda.pred=predict(m_lda,dd_1[ind_test,])
  table(true=dd_1[ind_test,]$group, pred=m_lda.pred$class)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ##     pred
  ## true  1  2
  ##    1 42  3
  ##    2  1 54
  {% endhighlight %}
  
  
  
  {% highlight r %}
  #############
  #### QDA ####
  #############
  m_qda=qda(group~X1+X2, data=dd_2)
  m_qda
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Call:
  ## qda(group ~ X1 + X2, data = dd_2)
  ## 
  ## Prior probabilities of groups:
  ##   1   2 
  ## 0.4 0.6 
  ## 
  ## Group means:
  ##           X1         X2
  ## 1  0.5463115 -0.4865920
  ## 2 -2.0096011  0.7253056
  {% endhighlight %}
  
  
  
  {% highlight r %}
  m_qda.pred=predict(m_qda,dd_2[ind_test,])
  table(true=dd_2[ind_test,]$group, pred=m_qda.pred$class)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ##     pred
  ## true  1  2
  ##    1 44  1
  ##    2  3 52
  {% endhighlight %}


* **<font size="4">Further topics</font>** <br />
  * **1. Reduced-Rank Linear Discriminant Analysis** ([The Elements of Statistical Learning:Data Mining, Inference, and Prediction](https://statweb.stanford.edu/~tibs/ElemStatLearn/), p.113 - p.119) <br />
  This is about finding a decision bounday in LDA to which can maximized between-class variance relatively to the within-class variance. 
  <img src="{{ site.baseurl }}/assets/image/reduced_lda.png" style="width:600px"/> 

***
### References
* **Books**
1. [The Elements of Statistical Learning:Data Mining, Inference, and Prediction](https://statweb.stanford.edu/~tibs/ElemStatLearn/)
2. [An Introduction to Statistical Learning with Applications in R](http://www-bcf.usc.edu/~gareth/ISL/)
