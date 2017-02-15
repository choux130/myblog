---
layout: post
title: 'Data Exploration (with HRA Data)'
date: 2017-01-26
author: Yin-Ting 
categories: [R]
tags: [ggplot2, GGally, gridExtra, plyr, gmodels, magrittr, lapply, mapply]
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
dat=read.csv("https://choux130.github.io/myblog/data/HR_analytics.csv",
             header=TRUE)
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
##################################
#### Correct variables' types ####
##################################
data[,c("work_accid","promo_last_5yrs","left_or_not")]=
  lapply(data[,c("work_accid","promo_last_5yrs","left_or_not")],as.factor)
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
      - Whether the employee has left _(0="leave", 1="not leave")_ <br />
  + Numeric Explanotary Variables: <br />
      - Employee satisfaction level _(between 0 and 1)_ <br />
      - Last evaluation _(between 0 and 1)_ <br />
      - Number of projects _(integer)_ <br />
      - Average monthly hours _(integer)_ <br />
      - Time spent at the company _(integer)_
      
* **R functions**
    + The function, `all_bygroup()` which can show Summary Table, Overlapping Histograms and Side by side Box plot at the same time. 

{% highlight r %}
################################
#### Summary Table by group ###
###############################
t_bygroup=function(d, xx, yy, round){
 # an elegant way to install a missing package
  if (!require("plyr")) install.packages("plyr")
    t <- ddply(d, yy, .fun = function(dd){
              c(Mean = round(mean(dd[,xx],na.rm=TRUE),round),
              Sd = round(sd(dd[,xx],na.rm=TRUE),round),
              min=round(min(dd[,xx]),round), 
              Q1=round(quantile(dd[,xx],0.25),round),
              Q2=round(quantile(dd[,xx],0.5),round),
              Q3=round(quantile(dd[,xx],0.75),round), 
              Max=round(max(dd[,xx]),round)) })
 return(t)
}

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

#######################################
#### Side by side boxplot by group ####
#######################################
box_bygroup=function(d,xx,yy,name){
    if (!require("ggplot2")) install.packages("ggplot2")
    ggplot(d, aes_string(x=yy, y=xx, fill=yy)) + 
    geom_boxplot()+
    ggtitle(name) 
}

######################################################
#### Function for summary table, hist and boxplot ####
######################################################
all_bygroup=function(d, xx, yy, round){
  #the summary table
  t=t_bygroup(d=d, xx, yy, round)
  #the histogram
  hist=hist_bygroup(d=data, xx, yy, paste("Histogram for", xx, "by", yy))
  #the boxplot
  box=box_bygroup(d=data, xx, yy, paste("Boxplot for", xx, "by", yy))
  
  #the package for arrange plots 
  if (!require("gridExtra")) install.packages("gridExtra")
  grid.arrange(hist,box, nrow=1) 
  grid.arrange(tableGrob(data.frame(t))) #make the output table become a plot
}
{% endhighlight %}

* **Draw it** \\
This is an example for using `all_bygroup()` on the explanatory variable, `satisf_level`.

{% highlight r %}
all_bygroup(data, xx="satisf_level", yy="left_or_not", round=2)
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-6-1.png)![plot of chunk unnamed-chunk-6](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-6-2.png)

* **For all the Numeric Variables** \\
By using `lapply()`, I can do `all_bygroup()` on all the numeric variables. 

{% highlight r %}
# list all the numeric explanatory variables
vars_num=c("satisf_level", "last_eval", "num_proj", "ave_mon_hrs", "time_spend")

# the response variable
y="left_or_not"

#the invisible() here is to hide the unwanted output from lapply 
invisible(lapply(vars_num, all_bygroup, d=data, yy=y, round=2))
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-1.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-2.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-3.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-4.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-5.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-6.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-7.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-8.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-9.png)![plot of chunk unnamed-chunk-7](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-7-10.png)

### Categorical Response Variables vs. Categorical Explanotary Variables 

* **Variables:**
  + Response Variables : <br />
      - Whether the employee has left _(0="leave", 1="not leave")_ <br />
  + Categorical Explanotary Variables: <br />
      - Whether they have had a work accident _(0="No", 1="Yes")_ <br />
      - Whether they have had a promotion in the last 5 years _(0="No", 1="Yes")_
      - Department <br />
      _("accounting", "hr", "IT", "management", "marketing", "product_mng",     "RandD", "sales", "support", "technical")_ <br />
      - Salary _("high", "medium", "low")_

* **R function for generate a table similar to SPSS**

{% highlight r %}
tab_bygroup=function(d, xx, yy, digits, prop.r, prop.c, prop.chisq){
  if (!require("gmodels")) install.packages("gmodels")
  CrossTable(x=d[[xx]], y=d[[yy]], digitd=digits, prop.r=prop.r, 
             prop.c=prop.c, prop.chisq=prop.chisq, format=c("SPSS"),
             dnn=c(xx,yy))
}
{% endhighlight %}

* **Draw it** \\
This is an example for using `tab_bygroup()` on the categorical variable, `work_accid`.

{% highlight r %}
tab_bygroup(data, xx="work_accid", yy="left_or_not", 
                     digits=3, prop.r=T, prop.c=T, prop.chisq=T)
{% endhighlight %}



{% highlight text %}
## 
##    Cell Contents
## |-------------------------|
## |                   Count |
## | Chi-square contribution |
## |             Row Percent |
## |          Column Percent |
## |           Total Percent |
## |-------------------------|
## 
## Total Observations in Table:  14999 
## 
##              | left_or_not 
##   work_accid |        0  |        1  | Row Total | 
## -------------|-----------|-----------|-----------|
##            0 |     9428  |     3402  |    12830  | 
##              |   12.346  |   39.510  |           | 
##              |   73.484% |   26.516% |   85.539% | 
##              |   82.499% |   95.267% |           | 
##              |   62.858% |   22.682% |           | 
## -------------|-----------|-----------|-----------|
##            1 |     2000  |      169  |     2169  | 
##              |   73.029  |  233.709  |           | 
##              |   92.208% |    7.792% |   14.461% | 
##              |   17.501% |    4.733% |           | 
##              |   13.334% |    1.127% |           | 
## -------------|-----------|-----------|-----------|
## Column Total |    11428  |     3571  |    14999  | 
##              |   76.192% |   23.808% |           | 
## -------------|-----------|-----------|-----------|
## 
## 
{% endhighlight %}

* **For all the Categorial Variables** \\
By using `lapply()`, I can do `tab_bygroup()` on all the categorical variables. 

{% highlight r %}
vars_cat=c("work_accid", "promo_last_5yrs", "department", "salary")
invisible(lapply(vars_cat, tab_bygroup, d=data, yy="left_or_not", 
            digits=3, prop.r=TRUE, prop.c=TRUE, prop.chisq=FALSE))
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
##              | left_or_not 
##   work_accid |        0  |        1  | Row Total | 
## -------------|-----------|-----------|-----------|
##            0 |     9428  |     3402  |    12830  | 
##              |   73.484% |   26.516% |   85.539% | 
##              |   82.499% |   95.267% |           | 
##              |   62.858% |   22.682% |           | 
## -------------|-----------|-----------|-----------|
##            1 |     2000  |      169  |     2169  | 
##              |   92.208% |    7.792% |   14.461% | 
##              |   17.501% |    4.733% |           | 
##              |   13.334% |    1.127% |           | 
## -------------|-----------|-----------|-----------|
## Column Total |    11428  |     3571  |    14999  | 
##              |   76.192% |   23.808% |           | 
## -------------|-----------|-----------|-----------|
## 
##  
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
##                 | left_or_not 
## promo_last_5yrs |        0  |        1  | Row Total | 
## ----------------|-----------|-----------|-----------|
##               0 |    11128  |     3552  |    14680  | 
##                 |   75.804% |   24.196% |   97.873% | 
##                 |   97.375% |   99.468% |           | 
##                 |   74.192% |   23.682% |           | 
## ----------------|-----------|-----------|-----------|
##               1 |      300  |       19  |      319  | 
##                 |   94.044% |    5.956% |    2.127% | 
##                 |    2.625% |    0.532% |           | 
##                 |    2.000% |    0.127% |           | 
## ----------------|-----------|-----------|-----------|
##    Column Total |    11428  |     3571  |    14999  | 
##                 |   76.192% |   23.808% |           | 
## ----------------|-----------|-----------|-----------|
## 
##  
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
##              | left_or_not 
##   department |        0  |        1  | Row Total | 
## -------------|-----------|-----------|-----------|
##   accounting |      563  |      204  |      767  | 
##              |   73.403% |   26.597% |    5.114% | 
##              |    4.926% |    5.713% |           | 
##              |    3.754% |    1.360% |           | 
## -------------|-----------|-----------|-----------|
##           hr |      524  |      215  |      739  | 
##              |   70.907% |   29.093% |    4.927% | 
##              |    4.585% |    6.021% |           | 
##              |    3.494% |    1.433% |           | 
## -------------|-----------|-----------|-----------|
##           IT |      954  |      273  |     1227  | 
##              |   77.751% |   22.249% |    8.181% | 
##              |    8.348% |    7.645% |           | 
##              |    6.360% |    1.820% |           | 
## -------------|-----------|-----------|-----------|
##   management |      539  |       91  |      630  | 
##              |   85.556% |   14.444% |    4.200% | 
##              |    4.716% |    2.548% |           | 
##              |    3.594% |    0.607% |           | 
## -------------|-----------|-----------|-----------|
##    marketing |      655  |      203  |      858  | 
##              |   76.340% |   23.660% |    5.720% | 
##              |    5.732% |    5.685% |           | 
##              |    4.367% |    1.353% |           | 
## -------------|-----------|-----------|-----------|
##  product_mng |      704  |      198  |      902  | 
##              |   78.049% |   21.951% |    6.014% | 
##              |    6.160% |    5.545% |           | 
##              |    4.694% |    1.320% |           | 
## -------------|-----------|-----------|-----------|
##        RandD |      666  |      121  |      787  | 
##              |   84.625% |   15.375% |    5.247% | 
##              |    5.828% |    3.388% |           | 
##              |    4.440% |    0.807% |           | 
## -------------|-----------|-----------|-----------|
##        sales |     3126  |     1014  |     4140  | 
##              |   75.507% |   24.493% |   27.602% | 
##              |   27.354% |   28.395% |           | 
##              |   20.841% |    6.760% |           | 
## -------------|-----------|-----------|-----------|
##      support |     1674  |      555  |     2229  | 
##              |   75.101% |   24.899% |   14.861% | 
##              |   14.648% |   15.542% |           | 
##              |   11.161% |    3.700% |           | 
## -------------|-----------|-----------|-----------|
##    technical |     2023  |      697  |     2720  | 
##              |   74.375% |   25.625% |   18.135% | 
##              |   17.702% |   19.518% |           | 
##              |   13.488% |    4.647% |           | 
## -------------|-----------|-----------|-----------|
## Column Total |    11428  |     3571  |    14999  | 
##              |   76.192% |   23.808% |           | 
## -------------|-----------|-----------|-----------|
## 
##  
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
##              | left_or_not 
##       salary |        0  |        1  | Row Total | 
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
### Between Numeric Explanotary Variables 
By using the `ggpairs()` function in `GGally` package, I can draw a scatter matrix with correlation coefficient and overlapping historgrams for all the numeric variables. 

{% highlight r %}
if (!require("GGally")) install.packages("GGally")
ggpairs(data=data, columns = c(1:5), 
      mapping=ggplot2::aes(colour = left_or_not,  alpha=0.9))
{% endhighlight %}

![plot of chunk unnamed-chunk-11](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-11-1.png)

***

### Between Categorical Explanotary Variables 
In addition to using the function, `CrossTable()`, to generate contingency table, we also can flexibly use `xtabs()`, `combn()` and `mapply()` to create many contingency tables at one time. 

* **Contingency table with count** 

{% highlight r %}
######################################
#### Contingency table with count ####
######################################
tab=function(xx,yy,df){
  formula <- as.formula(paste("~", xx, "+", yy)) 
  xtabs(data=df, formula)
}

# list all the combination of two categorical variables
tt=t(combn(c("work_accid","promo_last_5yrs",
                 "department","salary"),2))

# apply the function to all the combinations
tab_count=mapply(tab, tt[,1], tt[,2], list(data))  
names(tab_count) = c(1:length(tab_count))

# sum of marginals
tab_sum=lapply(tab_count,addmargins)
#print(tab_sum)
{% endhighlight %}
The contingency table for `promo_last_5yrs` and `work_accid `.

{% highlight r %}
tab_sum[[1]]
{% endhighlight %}



{% highlight text %}
##           promo_last_5yrs
## work_accid     0     1   Sum
##        0   12587   243 12830
##        1    2093    76  2169
##        Sum 14680   319 14999
{% endhighlight %}

* **Contingency table with proportion** 

{% highlight r %}
###########################################
#### Contingency table with percentage ####
###########################################
if (!require("magrittr")) install.packages("magrittr")
tab_count %>%
  lapply(., prop.table) %>%
  lapply(., addmargins) %>%
  lapply(., round, 3) ->tab_prop_sum
#print(tab_prop_sum)
{% endhighlight %}

The contingency table with proportion for `promo_last_5yrs` and `work_accid `.

{% highlight r %}
tab_prop_sum[[1]]
{% endhighlight %}



{% highlight text %}
##           promo_last_5yrs
## work_accid     0     1   Sum
##        0   0.839 0.016 0.855
##        1   0.140 0.005 0.145
##        Sum 0.979 0.021 1.000
{% endhighlight %}


*** 
