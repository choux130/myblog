---
layout: post
title: 'Data Exploration (with HRA Data)'
date: 2017-01-26
author: Yin-Ting 
categories: [Visualization]
tags: [ggplot2, table]
---
### Ideas
After knowing the background and the goal of [HRA Data](https://choux130.github.io/myblog//data/2017/01/25/HRA-Data.html), we know this data is about a binary response variable and many numerical and categorical explanatory variables. To get more insights of the dataset, our data exploration process will be seperated into two parts. 

1. the relationship between the response variable _("Whether the employee has left")_ and all the other explanatory variables. 
2. the relationship between all the explanatory variables. 

And, the relationship here is nothing complicated but some graphs, tables or some meaningful values. Briefly, it could be like this: 

|   Variables    |          **Numerical**          |           **Categorical**      |
|:--------------:| :------------------------------:|:------------------------------:|
|  **Numerical** | Scatter Plot <br /> Correlation Coefficient | Side by Side Box Plot <br /> Overlapping Histograms <br />  Summary Table  |            
|------
| **Categorical**| Side by Side Box Plot <br /> Overlapping Histograms <br /> Summary Table | Contingency Table| 
|-------

### Data Cleaning 
Before doing data exploration, we need to make sure that the data is clean and ready to be used. 

**1. Import raw data and keep it pure.**

{% highlight r %}
#########################
#### Import Raw Data ####
#########################
dat=read.csv("https://choux130.github.io/myblog/data/HR_analytics.csv", header=TRUE)
data=dat # keep raw data pure
{% endhighlight %}

{:start="2"} 
**2. Rename the variables and recorder the columns for convenience.**


{% highlight r %}
##############################
#### Rename the variables ####
##############################
names(data)=c("satisf_level","last_eval","num_proj",
              "ave_mon_hrs","time_spend","work_accid",
              "left_or_not","promo_last_5yrs","department",
              "salary")

##########################
#### Reorder the data ####
##########################
data=data[,c(1:6,8:10,7)]
{% endhighlight %}

{:start="3"}
**3. Correct all the variables' attributes.**


{% highlight r %}
#######################################
#### Correct variables' attributes ####
#######################################
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

{:start="4"}
**4. Checking for missing data.**


{% highlight r %}
####################
#### Finding NA ####
####################
which(is.na(data), arr.ind=TRUE) #the indices of NA values
{% endhighlight %}



{% highlight text %}
##      row col
{% endhighlight %}

***

### Categorical Response Variables vs. Numeric Explanotary Variables 

* **Variables:**
  + Response Variables : <br />
      Whether the employee has left _(0="leave", 1="not leave")_ <br />
  + Numeric Explanotary Variables: <br />
      Employee satisfaction level _(between 0 and 1)_ <br />
      Last evaluation _(between 0 and 1)_ <br />
      Number of projects _(integer)_ <br />
      Average monthly hours _(integer)_ <br />
      Time spent at the company _(integer)_
      
* **R functions**
    + Summary Table by the categorical response variable 

{% highlight r %}
################################
#### Summary Table by group ###
###############################
t_bygroup=function(d, x, y, n, round){
 # an elegant way to install a missing package
  if (!require("plyr")) install.packages("plyr")
    t <- ddply(d, y, .fun = function(dd){
              c(Mean = round(mean(dd[,x],na.rm=TRUE),round),
              Sd = round(sd(dd[,x],na.rm=TRUE),round),
              min=round(min(dd[,x]),round), 
              Q1=round(quantile(dd[,x],0.25),round),
              Q2=round(quantile(dd[,x],0.5),round),
              Q3=round(quantile(dd[,x],0.75),round), 
              Max=round(max(dd[,x]),round)) })
 return(t)
}
{% endhighlight %}
    
  + Overlapping Histograms

{% highlight r %}
#########################################
#### Overlapping Histograms by group ####
#########################################
hist_bygroup=function(d,xx,yy,name){
    if (!require("ggplot2")) install.packages("ggplot2")
    ggplot(d, aes_string(x=xx, color=yy, fill=yy))+ 
    geom_histogram(aes(y=..density..), alpha=0.5, 
                 position="identity")+
    geom_density(alpha=.3)+
    ggtitle(name)  
}
{% endhighlight %}
  
  + Side by side Box plot

{% highlight r %}
#######################################
#### Side by side boxplot by group ####
#######################################
box_bygroup=function(d,xx,yy,name){
    if (!require("ggplot2")) install.packages("ggplot2")
    ggplot(d, aes_string(x=yy, y=xx, fill=yy)) + 
    geom_boxplot()+
    ggtitle(name) 
}
{% endhighlight %}

* **Employee satisfaction level**

{% highlight r %}
# Table
t=t_bygroup(d=data, x="satisf_level", y='left_or_not', n=2, round=2)
library(knitr)
kable(t)
{% endhighlight %}



|left_or_not | Mean|   Sd|  min| Q1.25%| Q2.50%| Q3.75%|  Max|
|:-----------|----:|----:|----:|------:|------:|------:|----:|
|0           | 0.67| 0.22| 0.12|   0.54|   0.69|   0.84| 1.00|
|1           | 0.44| 0.26| 0.09|   0.13|   0.41|   0.73| 0.92|



{% highlight r %}
# Histogram
hist_sat=hist_bygroup(d=data, xx="satisf_level", yy="left_or_not",
               "Histogram for satisf_level")
# Box plot
box_sat=box_bygroup(d=data, xx="satisf_level", yy="left_or_not",
               "Boxplot for satisf_level")

if (!require("Rmisc")) install.packages("Rmisc") 
# Arrangement for multiple ggplots
multiplot(plotlist = list(hist_sat,box_sat), cols = 2) 
{% endhighlight %}

![plot of chunk unnamed-chunk-8](/myblogfigure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-8-1.png)

* **Last evaluation**

{% highlight r %}
# Table
t=t_bygroup(data, "last_eval", "left_or_not", round=2)
kable(t)
{% endhighlight %}



|left_or_not | Mean|   Sd|  min| Q1.25%| Q2.50%| Q3.75%| Max|
|:-----------|----:|----:|----:|------:|------:|------:|---:|
|0           | 0.72| 0.16| 0.36|   0.58|   0.71|   0.85|   1|
|1           | 0.72| 0.20| 0.45|   0.52|   0.79|   0.90|   1|



{% highlight r %}
# Histogram
hist_eval=hist_bygroup(d=data, xx="last_eval", yy="left_or_not",
               "Histogram for last_eval")
# Box plot
box_eval=box_bygroup(d=data, xx="last_eval", yy="left_or_not",
               "Boxplot for last_eval")
multiplot(plotlist = list(hist_eval,box_eval), cols = 2) 
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/myblogfigure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-9-1.png)

* **Number of projects**

{% highlight r %}
# Table
t= t_bygroup(data, "num_proj", "left_or_not", round=2)
kable(t)
{% endhighlight %}



|left_or_not | Mean|   Sd| min| Q1.25%| Q2.50%| Q3.75%| Max|
|:-----------|----:|----:|---:|------:|------:|------:|---:|
|0           | 3.79| 0.98|   2|      3|      4|      4|   6|
|1           | 3.86| 1.82|   2|      2|      4|      6|   7|



{% highlight r %}
# Histogram
hist_proj=hist_bygroup(d=data, xx="num_proj", yy="left_or_not",
               "Histogram for num_proj")
# Box plot
box_proj=box_bygroup(d=data, xx="num_proj", yy="left_or_not",
               "Boxplot for num_proj")
multiplot(plotlist = list(hist_proj,box_proj), cols = 2) 
{% endhighlight %}

![plot of chunk unnamed-chunk-10](/myblogfigure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-10-1.png)

* **Average monthly hours**

{% highlight r %}
# Table
t=t_bygroup(data, "ave_mon_hrs", "left_or_not",round=2)
kable(t)
{% endhighlight %}



|left_or_not |   Mean|    Sd| min| Q1.25%| Q2.50%| Q3.75%| Max|
|:-----------|------:|-----:|---:|------:|------:|------:|---:|
|0           | 199.06| 45.68|  96|    162|    198|    238| 287|
|1           | 207.42| 61.20| 126|    146|    224|    262| 310|



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

![plot of chunk unnamed-chunk-11](/myblogfigure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-11-1.png)

* **Time spent at the company**

{% highlight r %}
# Table
t=t_bygroup(data, "time_spend", "left_or_not", round=2)
kable(t)
{% endhighlight %}



|left_or_not | Mean|   Sd| min| Q1.25%| Q2.50%| Q3.75%| Max|
|:-----------|----:|----:|---:|------:|------:|------:|---:|
|0           | 3.38| 1.56|   2|      2|      3|      4|  10|
|1           | 3.88| 0.98|   2|      3|      4|      5|   6|



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

![plot of chunk unnamed-chunk-12](/myblogfigure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-12-1.png)

***

### Categorical Response Variables vs. Categorical Explanotary Variables 

* **Variables:**
  + Response Variables : <br />
      Whether the employee has left _(0="leave", 1="not leave")_ <br />
  + Categorical Explanotary Variables: <br />
      Whether they have had a work accident _(0="No", 1="Yes")_
      Whether they have had a promotion in the last 5 years _(0="No", 1="Yes")_
      Department <br />
      _("accounting", "hr", "IT", "management", "marketing", "product_mng",     "RandD", "sales", "support", "technical")_
      Salary _("high", "medium", "low")_

* **Whether they have had a work accident**

{% highlight r %}
if (!require("gmodels")) install.packages("gmodels")
CrossTable(x = data$work_accid, y = data$left_or_not, 
           digits=3, max.width = 5, prop.r=TRUE,
           prop.chisq=FALSE, prop.c=TRUE,format=c("SPSS"))
{% endhighlight %}



{% highlight text %}
## 
##    Cell Contents
## |-------------------------|
## |                   Count |
## |             Row Percent |
## |          Column Percent |
## |           Total Percent |
## |-------------------------|
## 
## Total Observations in Table:  14999 
## 
##                 | data$left_or_not 
## data$work_accid |        0  |        1  | Row Total | 
## ----------------|-----------|-----------|-----------|
##               0 |     9428  |     3402  |    12830  | 
##                 |   73.484% |   26.516% |   85.539% | 
##                 |   82.499% |   95.267% |           | 
##                 |   62.858% |   22.682% |           | 
## ----------------|-----------|-----------|-----------|
##               1 |     2000  |      169  |     2169  | 
##                 |   92.208% |    7.792% |   14.461% | 
##                 |   17.501% |    4.733% |           | 
##                 |   13.334% |    1.127% |           | 
## ----------------|-----------|-----------|-----------|
##    Column Total |    11428  |     3571  |    14999  | 
##                 |   76.192% |   23.808% |           | 
## ----------------|-----------|-----------|-----------|
## 
## 
{% endhighlight %}

* **Whether they have had a promotion in the last 5 years**

{% highlight r %}
CrossTable(x = data$promo_last_5yrs, y = data$left_or_not, 
           digits=3, max.width = 5, prop.r=TRUE,
           prop.chisq=FALSE, prop.c=TRUE,format=c("SPSS"))
{% endhighlight %}



{% highlight text %}
## 
##    Cell Contents
## |-------------------------|
## |                   Count |
## |             Row Percent |
## |          Column Percent |
## |           Total Percent |
## |-------------------------|
## 
## Total Observations in Table:  14999 
## 
##                      | data$left_or_not 
## data$promo_last_5yrs |        0  |        1  | Row Total | 
## ---------------------|-----------|-----------|-----------|
##                    0 |    11128  |     3552  |    14680  | 
##                      |   75.804% |   24.196% |   97.873% | 
##                      |   97.375% |   99.468% |           | 
##                      |   74.192% |   23.682% |           | 
## ---------------------|-----------|-----------|-----------|
##                    1 |      300  |       19  |      319  | 
##                      |   94.044% |    5.956% |    2.127% | 
##                      |    2.625% |    0.532% |           | 
##                      |    2.000% |    0.127% |           | 
## ---------------------|-----------|-----------|-----------|
##         Column Total |    11428  |     3571  |    14999  | 
##                      |   76.192% |   23.808% |           | 
## ---------------------|-----------|-----------|-----------|
## 
## 
{% endhighlight %}

* **Department**

{% highlight r %}
CrossTable(x = data$department, y = data$left_or_not, 
           digits=3, max.width = 5, prop.r=TRUE,
           prop.chisq=FALSE, prop.c=TRUE,format=c("SPSS"))
{% endhighlight %}



{% highlight text %}
## 
##    Cell Contents
## |-------------------------|
## |                   Count |
## |             Row Percent |
## |          Column Percent |
## |           Total Percent |
## |-------------------------|
## 
## Total Observations in Table:  14999 
## 
##                 | data$left_or_not 
## data$department |        0  |        1  | Row Total | 
## ----------------|-----------|-----------|-----------|
##      accounting |      563  |      204  |      767  | 
##                 |   73.403% |   26.597% |    5.114% | 
##                 |    4.926% |    5.713% |           | 
##                 |    3.754% |    1.360% |           | 
## ----------------|-----------|-----------|-----------|
##              hr |      524  |      215  |      739  | 
##                 |   70.907% |   29.093% |    4.927% | 
##                 |    4.585% |    6.021% |           | 
##                 |    3.494% |    1.433% |           | 
## ----------------|-----------|-----------|-----------|
##              IT |      954  |      273  |     1227  | 
##                 |   77.751% |   22.249% |    8.181% | 
##                 |    8.348% |    7.645% |           | 
##                 |    6.360% |    1.820% |           | 
## ----------------|-----------|-----------|-----------|
##      management |      539  |       91  |      630  | 
##                 |   85.556% |   14.444% |    4.200% | 
##                 |    4.716% |    2.548% |           | 
##                 |    3.594% |    0.607% |           | 
## ----------------|-----------|-----------|-----------|
##       marketing |      655  |      203  |      858  | 
##                 |   76.340% |   23.660% |    5.720% | 
##                 |    5.732% |    5.685% |           | 
##                 |    4.367% |    1.353% |           | 
## ----------------|-----------|-----------|-----------|
##     product_mng |      704  |      198  |      902  | 
##                 |   78.049% |   21.951% |    6.014% | 
##                 |    6.160% |    5.545% |           | 
##                 |    4.694% |    1.320% |           | 
## ----------------|-----------|-----------|-----------|
##           RandD |      666  |      121  |      787  | 
##                 |   84.625% |   15.375% |    5.247% | 
##                 |    5.828% |    3.388% |           | 
##                 |    4.440% |    0.807% |           | 
## ----------------|-----------|-----------|-----------|
##           sales |     3126  |     1014  |     4140  | 
##                 |   75.507% |   24.493% |   27.602% | 
##                 |   27.354% |   28.395% |           | 
##                 |   20.841% |    6.760% |           | 
## ----------------|-----------|-----------|-----------|
##         support |     1674  |      555  |     2229  | 
##                 |   75.101% |   24.899% |   14.861% | 
##                 |   14.648% |   15.542% |           | 
##                 |   11.161% |    3.700% |           | 
## ----------------|-----------|-----------|-----------|
##       technical |     2023  |      697  |     2720  | 
##                 |   74.375% |   25.625% |   18.135% | 
##                 |   17.702% |   19.518% |           | 
##                 |   13.488% |    4.647% |           | 
## ----------------|-----------|-----------|-----------|
##    Column Total |    11428  |     3571  |    14999  | 
##                 |   76.192% |   23.808% |           | 
## ----------------|-----------|-----------|-----------|
## 
## 
{% endhighlight %}

* **Salary**

{% highlight r %}
CrossTable(x = data$salary, y = data$left_or_not, 
           digits=3, max.width = 5, prop.r=TRUE,
           prop.chisq=FALSE, prop.c=TRUE,format=c("SPSS"))
{% endhighlight %}



{% highlight text %}
## 
##    Cell Contents
## |-------------------------|
## |                   Count |
## |             Row Percent |
## |          Column Percent |
## |           Total Percent |
## |-------------------------|
## 
## Total Observations in Table:  14999 
## 
##              | data$left_or_not 
##  data$salary |        0  |        1  | Row Total | 
## -------------|-----------|-----------|-----------|
##         high |     1155  |       82  |     1237  | 
##              |   93.371% |    6.629% |    8.247% | 
##              |   10.107% |    2.296% |           | 
##              |    7.701% |    0.547% |           | 
## -------------|-----------|-----------|-----------|
##          low |     5144  |     2172  |     7316  | 
##              |   70.312% |   29.688% |   48.777% | 
##              |   45.012% |   60.823% |           | 
##              |   34.296% |   14.481% |           | 
## -------------|-----------|-----------|-----------|
##       medium |     5129  |     1317  |     6446  | 
##              |   79.569% |   20.431% |   42.976% | 
##              |   44.881% |   36.880% |           | 
##              |   34.196% |    8.781% |           | 
## -------------|-----------|-----------|-----------|
## Column Total |    11428  |     3571  |    14999  | 
##              |   76.192% |   23.808% |           | 
## -------------|-----------|-----------|-----------|
## 
## 
{% endhighlight %}

***



{% highlight r %}
if (!require("GGally")) install.packages("GGally")
{% endhighlight %}



{% highlight text %}
## Loading required package: GGally
{% endhighlight %}



{% highlight r %}
#ggpairs(data=data, columns = c(1:10), 
#        mapping=ggplot2::aes(colour = left_or_not,  alpha=0.9))
#ggpairs(data=data, columns = c(1,2,4,5,3,10), 
#        mapping=ggplot2::aes(colour = left_or_not,  alpha=0.8))
#ggpairs(data=data, columns = c(6:9,10),
#        mapping=ggplot2::aes(colour = left_or_not,  alpha=0.8))
{% endhighlight %}

***


{% highlight r %}
# Use list techniques to create all the tables at once.  
# Count
list_xtab=
  lapply(data[,c("work_accid","promo_last_5yrs",
                 "department","salary")], 
  function(x) xtabs(~ x + data$left_or_not))
(list_xtab_sum=lapply(list_xtab,addmargins))
{% endhighlight %}



{% highlight text %}
## $work_accid
##      data$left_or_not
## x         0     1   Sum
##   0    9428  3402 12830
##   1    2000   169  2169
##   Sum 11428  3571 14999
## 
## $promo_last_5yrs
##      data$left_or_not
## x         0     1   Sum
##   0   11128  3552 14680
##   1     300    19   319
##   Sum 11428  3571 14999
## 
## $department
##              data$left_or_not
## x                 0     1   Sum
##   accounting    563   204   767
##   hr            524   215   739
##   IT            954   273  1227
##   management    539    91   630
##   marketing     655   203   858
##   product_mng   704   198   902
##   RandD         666   121   787
##   sales        3126  1014  4140
##   support      1674   555  2229
##   technical    2023   697  2720
##   Sum         11428  3571 14999
## 
## $salary
##         data$left_or_not
## x            0     1   Sum
##   high    1155    82  1237
##   low     5144  2172  7316
##   medium  5129  1317  6446
##   Sum    11428  3571 14999
{% endhighlight %}



{% highlight r %}
# Proportion
list_prop=lapply(list_xtab, prop.table)
list_prop=lapply(list_prop,round,3)
(list_prop_sum=lapply(list_prop, addmargins))
{% endhighlight %}



{% highlight text %}
## $work_accid
##      data$left_or_not
## x         0     1   Sum
##   0   0.629 0.227 0.856
##   1   0.133 0.011 0.144
##   Sum 0.762 0.238 1.000
## 
## $promo_last_5yrs
##      data$left_or_not
## x         0     1   Sum
##   0   0.742 0.237 0.979
##   1   0.020 0.001 0.021
##   Sum 0.762 0.238 1.000
## 
## $department
##              data$left_or_not
## x                 0     1   Sum
##   accounting  0.038 0.014 0.052
##   hr          0.035 0.014 0.049
##   IT          0.064 0.018 0.082
##   management  0.036 0.006 0.042
##   marketing   0.044 0.014 0.058
##   product_mng 0.047 0.013 0.060
##   RandD       0.044 0.008 0.052
##   sales       0.208 0.068 0.276
##   support     0.112 0.037 0.149
##   technical   0.135 0.046 0.181
##   Sum         0.763 0.238 1.001
## 
## $salary
##         data$left_or_not
## x            0     1   Sum
##   high   0.077 0.005 0.082
##   low    0.343 0.145 0.488
##   medium 0.342 0.088 0.430
##   Sum    0.762 0.238 1.000
{% endhighlight %}


*** 
