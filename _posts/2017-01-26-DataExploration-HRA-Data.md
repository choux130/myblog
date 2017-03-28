---
layout: post
title: 'Data Exploration with a categorical response variable (HRA Data)'
date: 2017-01-26
author: Yin-Ting 
categories: [R]
tags: [Visualization, ggplot2, GGally-ggpairs(), gridExtra, plyr-ddply(), gmodels, magrittr-%>%, lapply, mapply]
---
### Overview 
This post is about how I do data exploration when response variable is categorical and explanotary variables are both continuous and categorical. I used [HRA Data]({{ site.baseurl }}{% link _posts/2017-01-25-HRA-Data.md %}) as an example to show how to do it in R. In the beginning, I summarize a [general idea](#idea) about doing data exploration. Then, I will show how to do [data cleaning](#clean) and then create an [efficient function](#function) to create tables and graphs at one time using HRA Data as an example. 

### Details 

<a id="idea" />
* **<font size="4">General Ideas</font>**  
  When we are doing data exploration, generally, there are two things we are interested in: <br />
  1. the relationship **between the response variable and all the other explanatory variables**. 
  2. the relationship **between all the explanatory variables**. 
  
  And, the relationship here can be shown by using tables or graphs which can give us enough insights of data before we start to do modeling. 
  
  |   **Variables**    |          **Numerical**          |           **Categorical**      |
  |:--------------:| :------------------------------:|:------------------------------:|
  |  **Numerical** | Correlation Coefficient<br />Scatter Plot  | Summary Table <br /> Side by Side Box Plot <br /> Overlapping Histograms |            
  |------
  | **Categorical**| Summary Table <br /> Side by Side Box Plot <br /> Overlapping Histograms | Contingency Table|  
  |-------

<br />
<a id="clean" />
* **<font size="4">Data Cleaning</font>** <br />
  Before doing data exploration, we need to make sure that the data is clean and ready to be used. 
  
  
  {% highlight r %}
  ############################ 
  #### 1. Import Raw Data ####
  ############################
  dat=read.csv("https://choux130.github.io/myblog/data/HR_analytics.csv",
             header=TRUE)
  data=dat # keep raw data pure
  
  #################################
  #### 2. Rename the variables ####
  #################################
  names(data)=c("satisf_level","last_eval","num_proj",
              "ave_mon_hrs","time_spend","work_accid",
              "left_or_not","promo_last_5yrs","department",
              "salary")
  
  #############################
  #### 3. Reorder the data ####
  #############################
  data=data[,c(1:6,8:10,7)]
  
  #####################################
  #### 4. Correct variables' types ####
  #####################################
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
  
  
  
  {% highlight r %}
  #######################
  #### 5. Finding NA ####
  #######################
  which(is.na(data), arr.ind=TRUE) #the indices of NA values
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ##      row col
  {% endhighlight %}
<br />
<a id="function" />
### Self-defined R functions

* **<font size="4"> Categorical Response Variables vs. Numeric Explanotary Variables </font>** 
  * **Variables:**
    + Response Variables : <br />
      - Whether the employee has left --- _(0="leave", 1="not leave")_ 
    + Numeric Explanotary Variables: <br />
      - Employee satisfaction level --- _(between 0 and 1)_ <br />
      - Last evaluation --- _(between 0 and 1)_ <br />
      - Number of projects --- _(integer)_ <br />
      - Average monthly hours --- _(integer)_ <br />
      - Time spent at the company --- _(integer)_ <br />
    
  * **Introduction** <br />
      The self-defined function, `all_bygroup()` which can show Summary Table, Overlapping Histograms and Side by side Box plot. 
  
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
    ggplot(d, aes_string(x=xx, color=yy, fill=yy)) + 
    geom_histogram(aes(y=..density..), alpha=0.5, position="identity") +
    geom_density(alpha=.3)+
    ggtitle(name)  
  }
  
  #######################################
  #### Side by side boxplot by group ####
  #######################################
  box_bygroup=function(d,xx,yy,name){
    if (!require("ggplot2")) install.packages("ggplot2")
    ggplot(d, aes_string(x=yy, y=xx, fill=yy)) + 
    geom_boxplot() + ggtitle(name) 
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
  
  * **Draw it out at one time** <br />
    By using `lapply()`, I can do `all_bygroup()` on all the numeric variables. 
  
  {% highlight r %}
  # list all the numeric explanatory variables
  vars_num=c("satisf_level", "last_eval", "num_proj", "ave_mon_hrs", "time_spend")
  
  # the response variable
  y="left_or_not"
  
  #the invisible() here is to hide the unwanted output from lapply 
  invisible(lapply(vars_num, all_bygroup, d=data, yy=y, round=2))
  {% endhighlight %}
  
  ![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-3.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-4.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-5.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-6.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-7.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-8.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-9.png)![plot of chunk unnamed-chunk-3](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-3-10.png)
<br />
* **<font size="4"> Categorical Response Variables vs. Categorical Explanotary Variables </font>** 
  * **Variables:**
    + Response Variables : <br />
      - Whether the employee has left --- _(0="leave", 1="not leave")_ <br />
    + Categorical Explanotary Variables: <br />
      - Whether they have had a work accident --- _(0="No", 1="Yes")_ <br />
      - Whether they have had a promotion in the last 5 years --- _(0="No", 1="Yes")_
      - Department --- <br />
      _("accounting", "hr", "IT", "management", "marketing", "product_mng",     "RandD", "sales", "support", "technical")_ <br />
      - Salary --- _("high", "medium", "low")_
  * **Introduction** <br />
    The self-defined function, `tab_bygroup()` which can show two-way table similar to tables in SPSS.
  
  {% highlight r %}
  tab_bygroup=function(d, xx, yy, digits, prop.r, prop.c, prop.chisq){
    if (!require("gmodels")) install.packages("gmodels")
    CrossTable(x=d[[xx]], y=d[[yy]], digitd=digits, prop.r=prop.r, 
             prop.c=prop.c, prop.chisq=prop.chisq, format=c("SPSS"),
             dnn=c(xx,yy))
  }
  {% endhighlight %}
  
  * **Generate tables at one time** <br />
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
<br />
* **<font size="4"> Between Numeric Explanotary Variables </font>** 
  * **Introduction** <br />
    By using the `ggpairs()` function in `GGally` package, I can draw a scatter matrix with correlation coefficient and overlapping historgrams for all the numeric variables. 
  * **Draw it out at one time** 
  
  {% highlight r %}
  if (!require("GGally")) install.packages("GGally")
  ggpairs(data=data, columns = c(1:5), 
    mapping=ggplot2::aes(colour = left_or_not,  alpha=0.9))
  {% endhighlight %}
  
  ![plot of chunk unnamed-chunk-6](/figure/source/2017-01-26-DataExploration-HRA-Data/unnamed-chunk-6-1.png)
<br />
* **<font size="4"> Between Categorical Explanotary Variables </font>** 
  * **Introduction** <br />
    In addition to using the function, `CrossTable()`, to generate contingency table, we also can flexibly use `xtabs()`, `combn()` and `mapply()` to create many contingency tables at one time. 
  * **Generate tables at one time** 
  
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
  print(tab_sum)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## $`1`
  ##           promo_last_5yrs
  ## work_accid     0     1   Sum
  ##        0   12587   243 12830
  ##        1    2093    76  2169
  ##        Sum 14680   319 14999
  ## 
  ## $`2`
  ##           department
  ## work_accid accounting    hr    IT management marketing product_mng
  ##        0          671   650  1063        527       720         770
  ##        1           96    89   164        103       138         132
  ##        Sum        767   739  1227        630       858         902
  ##           department
  ## work_accid RandD sales support technical   Sum
  ##        0     653  3553    1884      2339 12830
  ##        1     134   587     345       381  2169
  ##        Sum   787  4140    2229      2720 14999
  ## 
  ## $`3`
  ##           salary
  ## work_accid  high   low medium   Sum
  ##        0    1045  6276   5509 12830
  ##        1     192  1040    937  2169
  ##        Sum  1237  7316   6446 14999
  ## 
  ## $`4`
  ##                department
  ## promo_last_5yrs accounting    hr    IT management marketing
  ##             0          753   724  1224        561       815
  ##             1           14    15     3         69        43
  ##             Sum        767   739  1227        630       858
  ##                department
  ## promo_last_5yrs product_mng RandD sales support technical   Sum
  ##             0           902   760  4040    2209      2692 14680
  ##             1             0    27   100      20        28   319
  ##             Sum         902   787  4140    2229      2720 14999
  ## 
  ## $`5`
  ##                salary
  ## promo_last_5yrs  high   low medium   Sum
  ##             0    1165  7250   6265 14680
  ##             1      72    66    181   319
  ##             Sum  1237  7316   6446 14999
  ## 
  ## $`6`
  ##              salary
  ## department     high   low medium   Sum
  ##   accounting     74   358    335   767
  ##   hr             45   335    359   739
  ##   IT             83   609    535  1227
  ##   management    225   180    225   630
  ##   marketing      80   402    376   858
  ##   product_mng    68   451    383   902
  ##   RandD          51   364    372   787
  ##   sales         269  2099   1772  4140
  ##   support       141  1146    942  2229
  ##   technical     201  1372   1147  2720
  ##   Sum          1237  7316   6446 14999
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
  print(tab_prop_sum)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## $`1`
  ##           promo_last_5yrs
  ## work_accid     0     1   Sum
  ##        0   0.839 0.016 0.855
  ##        1   0.140 0.005 0.145
  ##        Sum 0.979 0.021 1.000
  ## 
  ## $`2`
  ##           department
  ## work_accid accounting    hr    IT management marketing product_mng
  ##        0        0.045 0.043 0.071      0.035     0.048       0.051
  ##        1        0.006 0.006 0.011      0.007     0.009       0.009
  ##        Sum      0.051 0.049 0.082      0.042     0.057       0.060
  ##           department
  ## work_accid RandD sales support technical   Sum
  ##        0   0.044 0.237   0.126     0.156 0.855
  ##        1   0.009 0.039   0.023     0.025 0.145
  ##        Sum 0.052 0.276   0.149     0.181 1.000
  ## 
  ## $`3`
  ##           salary
  ## work_accid  high   low medium   Sum
  ##        0   0.070 0.418  0.367 0.855
  ##        1   0.013 0.069  0.062 0.145
  ##        Sum 0.082 0.488  0.430 1.000
  ## 
  ## $`4`
  ##                department
  ## promo_last_5yrs accounting    hr    IT management marketing
  ##             0        0.050 0.048 0.082      0.037     0.054
  ##             1        0.001 0.001 0.000      0.005     0.003
  ##             Sum      0.051 0.049 0.082      0.042     0.057
  ##                department
  ## promo_last_5yrs product_mng RandD sales support technical   Sum
  ##             0         0.060 0.051 0.269   0.147     0.179 0.979
  ##             1         0.000 0.002 0.007   0.001     0.002 0.021
  ##             Sum       0.060 0.052 0.276   0.149     0.181 1.000
  ## 
  ## $`5`
  ##                salary
  ## promo_last_5yrs  high   low medium   Sum
  ##             0   0.078 0.483  0.418 0.979
  ##             1   0.005 0.004  0.012 0.021
  ##             Sum 0.082 0.488  0.430 1.000
  ## 
  ## $`6`
  ##              salary
  ## department     high   low medium   Sum
  ##   accounting  0.005 0.024  0.022 0.051
  ##   hr          0.003 0.022  0.024 0.049
  ##   IT          0.006 0.041  0.036 0.082
  ##   management  0.015 0.012  0.015 0.042
  ##   marketing   0.005 0.027  0.025 0.057
  ##   product_mng 0.005 0.030  0.026 0.060
  ##   RandD       0.003 0.024  0.025 0.052
  ##   sales       0.018 0.140  0.118 0.276
  ##   support     0.009 0.076  0.063 0.149
  ##   technical   0.013 0.091  0.076 0.181
  ##   Sum         0.082 0.488  0.430 1.000
  {% endhighlight %}
*** 
