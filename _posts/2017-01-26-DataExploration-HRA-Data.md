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
    + Summary Table by the categorical response variable 

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

  + Show the summary table, histogram and boxplot at the same time

{% highlight r %}
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

* **Draw the plots and tables for each explanotary variables at one time**

{% highlight r %}
vars_num=c("satisf_level", "last_eval", "num_proj", "ave_mon_hrs", "time_spend")
y="left_or_not"
#the invisible() here is to hide the unwanted output from lapply 
invisible(lapply(vars_num, all_bygroup, d=data, yy=y, round=2))
{% endhighlight %}

For each variable, we will have plots and table like this. 

{% highlight r %}
all_bygroup(data, xx="satisf_level", yy="left_or_not", round=2)
{% endhighlight %}

![plot of chunk unnamed-chunk-10](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-10-1.png)![plot of chunk unnamed-chunk-10](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-10-2.png)

***

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

* **Generate tables for each categorical explanotary variables at one time**

{% highlight r %}
vars_cat=c("work_accid", "promo_last_5yrs", "department", "salary")
invisible(lapply(vars_cat, tab_bygroup, d=data, yy="left_or_not", 
            digits=3, prop.r=TRUE, prop.c=TRUE, prop.chisq=FALSE))
{% endhighlight %}

For each variable, we will have a table like this. 

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


***
### Between Numeric Explanotary Variables 

{% highlight r %}
if (!require("GGally")) install.packages("GGally")
ggpairs(data=data, columns = c(1:5), 
      mapping=ggplot2::aes(colour = left_or_not,  alpha=0.9))
{% endhighlight %}

![plot of chunk unnamed-chunk-14](/myblog/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-14-1.png)

***

### Between Categorical Explanotary Variables 
In addition to using the function, `CrossTable()`, to generate contingency table, we also can flexibly use `xtabs()`, `combn()` and `lapply()` to create many contingency tables at one time. 

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
For each paired variables, we will have a table like this. 

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
For each paired variables, we will have a table like this. 

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
