---
layout: post
title: 'Human Resource Analytics: Data Exploration'
date: 2017-01-26
author: Yin-Ting 
categories: [Project]
tags: [R, Classification]
---
This project is based on the [dataset](https://www.kaggle.com/ludobenistant/hr-analytics) found in Kaggle. This dataset have employees' information including Employee satisfaction level, Last evaluation, Number of projects, Average monthly hours, Time spent at the company, Whether they have had a work accident, Whether they have had a promotion in the last 5 years, Department, Salary, and Whether the employee has left. The goal of this project is to successfully predict which kind of employees are highly possible to leave in the future. 

## Data Cleaning

{% highlight r %}
# Import Raw Data
dat=read.csv("/Users/chou/Google Drive/websites/github/myblog-master/data_project/HR_analytics.csv", header=TRUE)
data=dat # keep raw data pure

# Rename the variables
names(data)=c("satisf_level","last_eval","num_proj",
              "ave_mon_hrs","time_spend","work_accid",
              "left_or_not","promo_last_5yrs","department",
              "salary")

# Reorder the data
data=data[,c(1:6,8:10,7)]

# Correct variables' attributes
data$work_accid=as.factor(data$work_accid)
data$promo_last_5yrs=as.factor(data$promo_last_5yrs)
data$left_or_not=as.factor(data$left_or_not)
str(data) 
{% endhighlight %}



{% highlight text %}
## 'data.frame':	14999 obs. of  10 variables:
##  $ satisf_level   : num  0.38 0.8 0.11 0.72 0.37 0.41 0.1 0.92 0.89 0.42 ...
##  $ last_eval      : num  0.53 0.86 0.88 0.87 0.52 0.5 0.77 0.85 1 0.53 ...
##  $ num_proj       : int  2 5 7 5 2 2 6 5 5 2 ...
##  $ ave_mon_hrs    : int  157 262 272 223 159 153 247 259 224 142 ...
##  $ time_spend     : int  3 6 4 5 3 3 4 5 5 3 ...
##  $ work_accid     : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
##  $ promo_last_5yrs: Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
##  $ department     : Factor w/ 10 levels "accounting","hr",..: 8 8 8 8 8 8 8 8 8 8 ...
##  $ salary         : Factor w/ 3 levels "high","low","medium": 2 3 3 2 2 2 2 2 2 2 ...
##  $ left_or_not    : Factor w/ 2 levels "0","1": 2 2 2 2 2 2 2 2 2 2 ...
{% endhighlight %}



{% highlight r %}
# Finding NA
which(is.na(data), arr.ind=TRUE) #the indices of NA values
{% endhighlight %}



{% highlight text %}
##      row col
{% endhighlight %}

***

## Data Exploration (Quantitative Explanotary Variables vs. Qualitative Binary Response Variable)
### R functions 
#### Table

{% highlight r %}
t_bygroup=function(d, x, y, n){
  # an elegant way to install a missing package
  if (!require("plyr")) install.packages("plyr")
    t <- ddply(d, y, .fun = function(dd){
               c(Mean = mean(dd[,x],na.rm=TRUE),
               Sd = sd(dd[,x],na.rm=TRUE),
               min=min(dd[,x]), 
               Q1=quantile(dd[,x],0.25),
               Median=quantile(dd[,x],0.5),
               Q3=quantile(dd[,x],0.75), 
               Max=max(dd[,x])) })
  return(t)
}
{% endhighlight %}
#### Histogram

{% highlight r %}
hist_bygroup=function(d,xx,yy,name){
    if (!require("ggplot2")) install.packages("ggplot2")
    ggplot(d, aes_string(x=xx, color=yy, fill=yy))+ 
    geom_histogram(aes(y=..density..), alpha=0.5, 
                 position="identity")+
    geom_density(alpha=.3)+
    ggtitle(name)  
}
{% endhighlight %}

#### Box plot

{% highlight r %}
box_bygroup=function(d,xx,yy,name){
    if (!require("ggplot2")) install.packages("ggplot2")
    ggplot(d, aes_string(x=yy, y=xx, fill=yy)) + 
    geom_boxplot()+
    ggtitle(name) 
}
{% endhighlight %}

### Employee satisfaction level

{% highlight r %}
# Table
t_bygroup(d=data, x="satisf_level", y='left_or_not', n=2)
{% endhighlight %}



{% highlight text %}
##   left_or_not      Mean        Sd  min Q1.25% Median.50% Q3.75%  Max
## 1           0 0.6668096 0.2171038 0.12   0.54       0.69   0.84 1.00
## 2           1 0.4400980 0.2639334 0.09   0.13       0.41   0.73 0.92
{% endhighlight %}



{% highlight r %}
if (!require("Rmisc")) install.packages("Rmisc") # Arrangement for multiple ggplots
# Histogram
hist_sat=hist_bygroup(d=data, xx="satisf_level", yy="left_or_not",
               "Histogram for satisf_level")
# Box plot
box_sat=box_bygroup(d=data, xx="satisf_level", yy="left_or_not",
               "Boxplot for satisf_level")
multiplot(plotlist = list(hist_sat,box_sat), cols = 2) 
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/myblog/figure/source/2017-01-26-HR-Analytics-Exploration/unnamed-chunk-5-1.png)

### Last evaluation

{% highlight r %}
# Table
t_bygroup(data, "last_eval", "left_or_not")
{% endhighlight %}



{% highlight text %}
##   left_or_not      Mean        Sd  min Q1.25% Median.50% Q3.75% Max
## 1           0 0.7154734 0.1620050 0.36   0.58       0.71   0.85   1
## 2           1 0.7181126 0.1976734 0.45   0.52       0.79   0.90   1
{% endhighlight %}



{% highlight r %}
# Histogram
hist_eval=hist_bygroup(d=data, xx="last_eval", yy="left_or_not",
               "Histogram for last_eval")
# Box plot
box_eval=box_bygroup(d=data, xx="last_eval", yy="left_or_not",
               "Boxplot for last_eval")
multiplot(plotlist = list(hist_eval,box_eval), cols = 2) 
{% endhighlight %}



{% highlight text %}
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/myblog/figure/source/2017-01-26-HR-Analytics-Exploration/unnamed-chunk-6-1.png)

### Number of projects

{% highlight r %}
# Table
t_bygroup(data, "num_proj", "left_or_not")
{% endhighlight %}



{% highlight text %}
##   left_or_not     Mean        Sd min Q1.25% Median.50% Q3.75% Max
## 1           0 3.786664 0.9798838   2      3          4      4   6
## 2           1 3.855503 1.8181654   2      2          4      6   7
{% endhighlight %}



{% highlight r %}
# Histogram
hist_proj=hist_bygroup(d=data, xx="num_proj", yy="left_or_not",
               "Histogram for num_proj")
# Box plot
box_proj=box_bygroup(d=data, xx="num_proj", yy="left_or_not",
               "Boxplot for num_proj")
multiplot(plotlist = list(hist_proj,box_proj), cols = 2) 
{% endhighlight %}



{% highlight text %}
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-HR-Analytics-Exploration/unnamed-chunk-7-1.png)

### Average monthly hours

{% highlight r %}
# Table
t_bygroup(data, "ave_mon_hrs", "left_or_not")
{% endhighlight %}



{% highlight text %}
##   left_or_not     Mean       Sd min Q1.25% Median.50% Q3.75% Max
## 1           0 199.0602 45.68273  96    162        198    238 287
## 2           1 207.4192 61.20283 126    146        224    262 310
{% endhighlight %}



{% highlight r %}
# Histogram
hist_hrs=hist_bygroup(d=data, xx="ave_mon_hrs", 
                       yy="left_or_not",
                       "Histogram for ave_mon_hrs")
# Box plot
box_hrs=box_bygroup(d=data, xx="ave_mon_hrs",
                     yy="left_or_not",
                     "Boxplot for ave_mon_hrs")
multiplot(plotlist = list(hist_hrs,box_hrs), cols = 2) 
{% endhighlight %}



{% highlight text %}
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

![plot of chunk unnamed-chunk-8](/myblog/figure/source/2017-01-26-HR-Analytics-Exploration/unnamed-chunk-8-1.png)

### Time spent at the company

{% highlight r %}
# Table
t_bygroup(data, "time_spend", "left_or_not")
{% endhighlight %}



{% highlight text %}
##   left_or_not     Mean        Sd min Q1.25% Median.50% Q3.75% Max
## 1           0 3.380032 1.5623480   2      2          3      4  10
## 2           1 3.876505 0.9776979   2      3          4      5   6
{% endhighlight %}



{% highlight r %}
# Histogram
hist_time=hist_bygroup(d=data, xx="time_spend", 
                       yy="left_or_not",
                       "Histogram for time_spend")
# Box plot
box_time=box_bygroup(d=data, xx="time_spend",
                     yy="left_or_not",
                     "Boxplot for time_spend")
multiplot(plotlist = list(hist_time,box_time), cols = 2) 
{% endhighlight %}



{% highlight text %}
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/myblog/figure/source/2017-01-26-HR-Analytics-Exploration/unnamed-chunk-9-1.png)

***

## Data Exploration (Qualitative Explanotary Variables vs. Qualitative Binary Response Variable)
### R function

### Whether they have had a work accident 

{% highlight r %}
xtabs(~work_accid+left_or_not, data)
{% endhighlight %}



{% highlight text %}
##           left_or_not
## work_accid    0    1
##          0 9428 3402
##          1 2000  169
{% endhighlight %}

### Whether they have had a promotion in the last 5 years

{% highlight r %}
xtabs(~promo_last_5yrs+left_or_not, data)
{% endhighlight %}



{% highlight text %}
##                left_or_not
## promo_last_5yrs     0     1
##               0 11128  3552
##               1   300    19
{% endhighlight %}
### Department

{% highlight r %}
xtabs(~department+left_or_not, data)
{% endhighlight %}



{% highlight text %}
##              left_or_not
## department       0    1
##   accounting   563  204
##   hr           524  215
##   IT           954  273
##   management   539   91
##   marketing    655  203
##   product_mng  704  198
##   RandD        666  121
##   sales       3126 1014
##   support     1674  555
##   technical   2023  697
{% endhighlight %}
### Salary

{% highlight r %}
xtabs(~salary+left_or_not, data)
{% endhighlight %}



{% highlight text %}
##         left_or_not
## salary      0    1
##   high   1155   82
##   low    5144 2172
##   medium 5129 1317
{% endhighlight %}
