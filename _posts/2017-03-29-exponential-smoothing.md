---
layout: post
title: "Exponential Smoothing"
author: "Yin-Ting Chou"
date: 2017-03-29
categories: [Methodology]
tags: [Time-Series-Analysis, Automatic-Forecasting]
---
### Overview
This post is about Exponential Smoothing method, a prediction method for time series data. There are [many forms](#forms) of Exponential Smoothing method and the most basic ones are [Single](#single), [Double](#double) and [Triple (Holt-Winters)](#triple). Some of the Exponential Smoothing forms can be written as ARIMA model; some of them can not and vice versa. Compared to ARIMA model, Exponential Smoothing method do not have strong model assumptions and it also can not add explanatory variables in the algorithm. However, it is because of its loose model restrictions, Exponential Smoothing can be calculated really fast which is good when you need to predict the value of the next really small period of time like next minute or next five minutes (the time is so short for you to fit a complete ARIMA model). In the end, I also included the [strengthes and weaknesses](#strweak) of Exponential Smoothing method. 

This post is my note about learning Exponential Smoothing. All the contents in this post are based on my reading on many resources which are listed in the [References](#ref) part.

***

### Details 
* **<font size="4">Notations</font>** <br />
  Define 
  
  $$ 
  \begin{align}
  y_t &: \text{the observed data in time }t \\[5pt]
  \hat{y_t} &: \text{the predicted data in time }t \\[5pt]
  h &: \text{Number of periods for forecasting}
  \end{align}
  $$

<a id="single"> 
* **<font size="4">Single Exponential Smoothing</font>** <br />
  * **Data Assumptions:** <br />
    $$\{y_t,\; t=1,2,...\}$$ is a stationary time series which has properties that $P(Y_{t_1})=P(Y_{t_2}),\; \forall t_1,\,t_2=1,2,...$ and then $E(Y_{t_1})=E(Y_{t_2}),\; \forall t_1,\,t_2=1,2,...$.

    
    ![plot of chunk unnamed-chunk-1](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-1-1.png)![plot of chunk unnamed-chunk-1](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-1-2.png)![plot of chunk unnamed-chunk-1](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-1-3.png)


  * **Algorithm:** <br />
    The original algorithm which was defined by Winters (1960),
      
    $$ 
    \begin{align}
    \hat{y_{t}} &= \alpha y_t + (1-\alpha)\hat{y_{t-1}} \:, 
    \quad 0< \alpha \leq 1 \\
    \end{align}
    $$
      
    The alternative algorithm which has the same property as the original one but makes more sense on explanation,
      
    $$ 
    \begin{align}
    \hat{y_{t}} &= \alpha y_{t-1}+ (1-\alpha)\hat{y_{t-1}} \:, 
    \quad 0< \alpha \leq 1 \\[5pt]
    \hat{y_{t+h}} &= \hat{y_{t+1}} \\[5pt]
            &= \alpha y_{t}+ (1-\alpha)\hat{y_{t}}
    \end{align}
    $$
      
  * **Initial values:** <br />
    To initiate the single exponential smoothing, we should give a initial value, $\hat{y_0}$. There are many methods to choose the initial value, like $\hat{y_0}=y_0$ or the mean value of the first $n$ time points, $\hat{y_0}=\frac{1}{n}\sum_{i=1}^{n}y_i$.
      
  * **Parameters:**<br /> 
    $${\alpha}$$. <br />
    The common method for calculating $\alpha$ is finding the estimates which can minimizing Sum of the Square of Errors (SSE), $\sum_{i=1}^{n}(y_i-\hat{y_i})^2$. 
    
  * **Derivation:** <br />
    The derivation of the original algorithm can be found in Winters (1960). The following is the proof for the alternative one based on Winters's derivation ideas. Here, we can suppose $y_t$ are random variables. 
      
    $$ 
    \begin{align}
    \hat{y_1}  &= \alpha y_0 + (1-\alpha) \hat{y_0} \\[5pt]
    \hat{y_2}  &= \alpha y_1 + (1-\alpha) \hat{y_1} \\[5pt]
    &= \alpha y_1 + (1-\alpha)(\alpha y_0 + (1-\alpha) \hat{y_0}) \\[5pt]
    &= \alpha y_1 + \alpha(1-\alpha)y_0 + (1-\alpha)^2 \hat{y_0} \\[5pt]
    &\quad \quad \quad \vdots \\[5pt]
    \hat{y_t}  &= \alpha y_{t-1} + \alpha (1-\alpha)y_{t-2} + 
              \alpha (1-\alpha)^2 y_{t-3} +\dots + \\[5pt]
    &\qquad \alpha (1-\alpha)^{t-2}y_1 + \alpha(1-\alpha)^{t-1}y_0 +
              (1-\alpha)^t\hat{y_0} \\[5pt]
    &= \alpha\sum_{i=1}^{t} (1-\alpha)^{i-1}y_{t-i} +           
              (1-\alpha)^t\hat{y_0} \\[10pt]
    \text{Then} \quad E(\hat{y_t}) &= \alpha\sum_{i=1}^{t} 
      (1-\alpha)^{i-1}E(y_{t-i}) + (1-\alpha)^tE(\hat{y_0}) \\[5pt]
    \text{(when $t$ is large, $(1-\alpha)^t$ }&\text{will approach to $0$ and $\alpha\sum_{i=1}^{t} (1-\alpha)^{i-1}$ will approach to $1$.)} \\[5pt]
    &\simeq E(y_{t-i}) = E(y_t) \text{ (which meets the assumption of stationary process.)}
    \end{align}
    $$
      
<br />

<a id="double"> 
* **<font size="4">Double Exponential Smoothing</font>**
  * **Data Assumptions:** <br />
    Unlike the data assumption of Single Exponential Smoothing, Double Exponential Smoothing allows data has trend feature. That is, data points has stationary process on a line with trend. 
    
    ![plot of chunk unnamed-chunk-2](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-2-1.png)![plot of chunk unnamed-chunk-2](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-2-2.png)![plot of chunk unnamed-chunk-2](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-2-3.png)

  * **Algorithm:**
      
    $$ 
    \begin{align}
    \text{level:}& &&l_{t} = \alpha y_{t} + (1-\alpha) (l_{t-1}+b_{t-1}) \\[5pt] 
    \text{trend:}& &&b_{t} = \beta (l_t-l_{t-1}) + (1-\beta) b_{t-1} \\[5pt]
    \text{prediction:}& &&\hat{y_{t+1}} = l_{t}+b_{t} \\[5pt]
    & &&\hat{y_{t+h}} = l_t + hb_t
    \end{align}
    $$
    
  * **Initial Values:**<br />
    The inital values are $l_0$ and $b_0$.
      
  * **Parameters:**<br /> 
    $${\alpha, \beta}$$. <br />
    The common method for calculating $\alpha$ is finding the estimates which can minimizing Sum of the Square of Errors (SSE), $\sum_{i=1}^{n}(y_i-\hat{y_i})^2$.
      
<br />
<a id="triple"> 
* **<font size="4">Triple Exponential Smoothing (Holt-Winters Method)</font>**
  * **Data Assumptions:** <br />
    The data has stationary process on a line with not only trend but also seasonality.  
    
    ![plot of chunk unnamed-chunk-3](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-03-29-exponential-smoothing/unnamed-chunk-3-3.png)
    
    
  * **Algorithm:**
  
    $$ 
    \begin{align}
    \quad \text{level:}& &&l_{t} = \alpha (y_{t}-s_{t-m}) + (1-\alpha) (l_{t-1}+b_{t-1}) \\[5pt] 
    \quad \text{trend:}& &&b_{t} = \beta (l_t-l_{t-1}) + (1-\beta) b_{t-1} \\[5pt]
    \text{seasonal:}& &&s_{t} = \gamma(y_{t}-l_{t-1}-b_{t-1})+(1-\gamma)s_{t-m} \\[5pt]
    & &&\text{where $m$ is the length of seasonality} \\[5pt]
    \text{prediction:}&  &&\hat{y_{t+1}} = l_{t}+b_{t}+s_{t-m} \\[5pt]
    & && \hat{y_{t+h}} = l_t + hb_t +s_{t-m+h_m^+}\;, \\[5pt]
    & &&\text{where $h_m^+ = [(h−1) \text{  mod  } m]+1$}
    \end{align}
    $$  

  * **Initial Values:**<br />
    The inital values are $l_0$, $b_0$, $$\{s_0^1, s_0^2, ...s_0^m\}$$.

  * **Parameters:**<br /> 
    $${\alpha, \beta, \gamma}$$. <br />
    The common method for calculating $\alpha$ is finding the estimates which can minimizing Sum of the Square of Errors (SSE), $\sum_{i=1}^{n}(y_i-\hat{y_i})^2$.

<br />
<a id="forms">
* **<font size="4">Other Forms of Exponential Smoothing Methods</font>** <br />
  The above Double and Triple Exponential Smoothing are the simplest case. Prof. Hyndman has listed out all the current 15 forms of Exponential Smoothing models in his book, Forecasting with Exponential Smoothing (2008). The tables are from the p.12 and p.18 of this book. In his book, he also has wonderful explanations for every model. The last table is from his another book, [Forecasting: Principles and practice](https://www.otexts.org/fpp/7/6). The graph is "forecast profile" which I got from Dimitrov (2013) but originated from Garden(1987). <br /><br />
  <img src="{{ site.baseurl }}/assets/image/explist.png" style="width:400px"/>
  <img src="{{ site.baseurl }}/assets/image/expsmooth.png" style="width:800px"/>
  <img src="{{ site.baseurl }}/assets/image/exptable.png" style="width:600px"/>
  <img src="{{ site.baseurl }}/assets/image/forecastprofile.png" style="width:400px"/>

<br />
<a id="strweak">
* **<font size="4">Strengths and Weaknesses</font>**
  * **Strengths**
    1. The alogrithm is explicit and easy to be understood.
    2. Can be computed quick. 
    3. More weight on recent data. 
    4. Good at short-term forecasts. <br />
  * **Weaknesses**
    1. Need to do research on finding initial values. 
    2. Not good at mid-term and long-term forecasts. 
    3. Can not add explanotary variables. 
    4. Can not construct prediction interval but only point prediction. 
    5. It is hard to meet the data assumptions of stationary but it is still a referable method of prediction. 
    
*** 
<a id="ref">
### References
* **Paper**
1. [Winters, Peter R. "Forecasting sales by exponentially weighted moving         averages." Management Science 6, no. 3 (1960): 324-342.](https://www.researchgate.net/publication/227447748_Forecasting_Sales_by_Exponentially_Weighted_Moving_Averages)
2. Dimitrov, Preslav Encontros Científicos. "Long-run forecasting of the number of the ecotourism arrivals in the municipality of Stambolovo, Bulgaria." Tourism & Management Studies, 2013, Issue 1, pp.41-47
3. Gardner, E. S. "Smoothing methods for short-term planning and control." The handbook of forecasting–a manager’s guide (1987): 174-175.

* **Book**
1. [Forecasting with Exponential Smoothing: The State Space Approach](http://www.springer.com/gp/book/9783540719168)
2. [Forecasting: principles and practice](https://www.otexts.org/fpp/7)

* **Online Materials**
1. [Engineering Statistics Handbook - Chapter 6.4.3](http://www.itl.nist.gov/div898/handbook/pmc/section4/pmc43.htm)
2. [Hyndsight - A blog by Rob J Hyndman](http://robjhyndman.com/hyndsight/)
  
