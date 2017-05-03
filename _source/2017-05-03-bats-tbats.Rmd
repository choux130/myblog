---
layout: post
title: "BATS and TBATS Model"
author: "Yin-Ting Chou"
date: 2017-05-03
categories: [Methodology]
tags: [Time Series Analysis]
---
### Overview
BATS model is **[State Space Model]({{ site.baseurl }}{% link _posts/2017-05-02-the-state-space-model.md %}) + Box-Cox Transformation + ARMA model for residuals**. The Box-Cox Transformation here is for dealing with non-linear data and ARMA model for residuals can de-correlated the time series data. [Alysha M.(2010)](#ref) has proved that BATS model can improve the prediction performance compared to the simple Sate Space Model. However, BATS model does not do well when the the seaonality is complex and high frequency. So, [Alysha M.(2011)](#ref) propsed TBATS model which is **BATS model + Trigonometric Seasonal**. The trigonometric expression of seasonality terms can not only dramatically reduced the parameters of model when the frequencies of seaonalities are high but also give the model more flexibility to deal with complex seasonality. In a nutshell, this is how the story goes: [Exponential Smoothing Method]({{ site.baseurl }}{% link _posts/2017-03-29-exponential-smoothing.md %}) $\Rightarrow$ [State Spce Model]({{ site.baseurl }}{% link _posts/2017-05-02-the-state-space-model.md %}) $\Rightarrow $ [BATS]({{ site.baseurl }}{% link _posts/2017-05-03-bats-tbats.md %}) $\Rightarrow$ [TBATS]({{ site.baseurl }}{% link _posts/2017-05-03-bats-tbats.md %}). 

This post is my note about learning BATS and TBATS models. All the contents in this post are based on my reading on many resources which are listed in the [References](#ref) part.
 
***
### Details 
* **<font size="4">BATS (Box-Cox Transformation, ARMA residuals, Trend and Seasonality)</font>** <br />
  * **Algorithm** <br />
<img src="{{ site.baseurl }}/assets/image/bats.png" style="width:300px"/>
    
    $$\varepsilon_t \sim NID(0,\sigma^2)$$, where $$i = \text{the } ith \text{ seasonality}$$. If it is double seasonality then $$i = 1, 2$$. 
  
  * **Initial Values:**<br />
    The inital values are $l_0$, $b_0$, $$\{s_0^1, s_0^2, ...s_0^{m_1}\}$$, $$\{s_0^1, s_0^2, ...s_0^{m_2}\}$$, ...$$\{s_0^1, s_0^2, ...s_0^{m_k}\}$$. The $k$ here is the total number of seasonality. 
    [Alysha M.(2010)](#ref) has a thorough explanation about finding initial values for different cases in her paper. <br />
<a id="bats_para">

  * **Parameters:**<br /> 
  $$\omega,\;\phi,\;\alpha,\;\beta,\;\gamma_1,\cdots,\gamma_k,\;\varphi_1,\cdots,\varphi_p\;,\theta_1,\cdots,\theta_q$$. <br />
  Under the Guassian assumption of $\varepsilon _t$, the parameters can be estimated by maximizing the loglikelihood function or minimizing the Mean Square of Errors (MSE), $$\frac{1}{n}\sum_{i=1}^{n}(y_i-\hat{y_i})^2$$ and so on. The $$p,\;q$$ here can be $$0,\;1,\;2,3\;,4,\;5$$. Choose the one by minimizing the $$AIC = 2p + 2ln(L)$$. More information about AIC : [Facts and fallacies of the AIC](http://robjhyndman.com/hyndsight/aic/), [Wikipedia](https://en.wikipedia.org/wiki/Akaike_information_criterion) <br />
 
  <a id="strweak1">
  * **Strengths and Weaknesses**
    * **Strengths**
      1. Box-cox transformation can deal with data with non-linearity and then somewhat makes the variance becomes constant. 
      2. ARMA model on residuals can solve autocorrelation problem.
      3. No need to worry about initial values. 
      4. Can get not only point prediction but also interval prediction.
      5. The performance is better than simple state space model.
  
    * **Weaknesses**
      1. The assumption of $\varepsilon_t \sim NID(0,\sigma^2)$ may not hold.
      2. Can not add explanotary variables. 
      3. The periods of multiseaonality should be nested.
      4. For high frequency seasonality, the parameter will be very large.

<br />
* **<font size="4">TBATS (Trigonometric Seasonal, Box-Cox Transformation, ARMA residuals, Trend and Seasonality)</font>** <br />
  * **Algorithm:**<br /> 
<img src="{{ site.baseurl }}/assets/image/tbats1.png" style="width:300px"/>
<img src="{{ site.baseurl }}/assets/image/tbats2.png" style="width:300px"/>
  $$\varepsilon_t \sim NID(0,\sigma^2)$$, where $$i = \text{the } ith \text{ seasonality}$$. If it is double seasonality then $$i = 1, 2$$.<br /> 
  
  * **Initial Values:**<br />
    [Alysha M.(2011)](#ref) has a thorough explanation about finding initial values after using trigonometric expression to seasonality.<br />
    
  * **Parameters:**<br /> 
    $$\omega,\;\phi,\;\alpha,\;\beta,\;\gamma_1,\cdots,\gamma_k,\;\varphi_1,\cdots,\varphi_p\;,\theta_1,\cdots,\theta_q$$. <br />
    The method to estimate the parameters are similar to the above [BATS model](#bats_para) <br />
    
  <a id="strweak2">
  * **Strengths and Weaknesses**
    * **Strengths**
      1. Can deal with data with non-integer seasonal period, non-nested periods and high frequency data.
      2. Can do multi-seasonality without increasing too much parameters.
      3. All the [strengths that BATS has](#strweak1). 
    * **Weaknesses**
      1. The assumption of $\varepsilon_t \sim NID(0,\sigma^2)$ may not hold.
      2. Can not add explanotary variables. 
      3. The performance for long-term prediction is not very well. 
      4. The computation cost is big if the data size is large. 
      
*** 
<a id="ref">
### References
* **Paper**
  1. De Livera, Alysha M. "Automatic forecasting with a modified exponential smoothing state space framework." Monash Econometrics and Business Statistics Working Papers 10, no. 10 (2010).
  2. De Livera, Alysha M., Rob J. Hyndman, and Ralph D. Snyder. "Forecasting time series with complex seasonal patterns using exponential smoothing." Journal of the American Statistical Association 106, no. 496 (2011): 1513-1527. 
  
* **Books**
  1. [Forecasting with Exponential Smoothing: The State Space Approach (2008)](http://www.springer.com/gp/book/9783540719168)
