---
layout: post
title: 'Data Exploration with a categorical response variable (HRA Data)'
date: 2017-01-26
author: Yin-Ting 
categories: [R]
tags: [Data Visualization, ggplot2]
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
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Warning in file(file, "rt"): URL 'http://yintingchou.com/data/
  ## HR_analytics.csv': status was '404 Not Found'
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in file(file, "rt"): cannot open connection
  {% endhighlight %}
  
  
  
  {% highlight r %}
  data=dat # keep raw data pure
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in eval(expr, envir, enclos): object 'dat' not found
  {% endhighlight %}
  
  
  
  {% highlight r %}
  #################################
  #### 2. Rename the variables ####
  #################################
  names(data)=c("satisf_level","last_eval","num_proj",
              "ave_mon_hrs","time_spend","work_accid",
              "left_or_not","promo_last_5yrs","department",
              "salary")
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in names(data) = c("satisf_level", "last_eval", "num_proj", "ave_mon_hrs", : names() applied to a non-vector
  {% endhighlight %}
  
  
  
  {% highlight r %}
  #############################
  #### 3. Reorder the data ####
  #############################
  data=data[,c(1:6,8:10,7)]
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in data[, c(1:6, 8:10, 7)]: object of type 'closure' is not subsettable
  {% endhighlight %}
  
  
  
  {% highlight r %}
  #####################################
  #### 4. Correct variables' types ####
  #####################################
  data[,c("work_accid","promo_last_5yrs","left_or_not")]=
  lapply(data[,c("work_accid","promo_last_5yrs","left_or_not")],as.factor)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in data[, c("work_accid", "promo_last_5yrs", "left_or_not")]: object of type 'closure' is not subsettable
  {% endhighlight %}
  
  
  
  {% highlight r %}
  str(data) 
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## function (..., list = character(), package = NULL, lib.loc = NULL, 
  ##     verbose = getOption("verbose"), envir = .GlobalEnv)
  {% endhighlight %}
  
  
  
  {% highlight r %}
  #######################
  #### 5. Finding NA ####
  #######################
  which(is.na(data), arr.ind=TRUE) #the indices of NA values
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Warning in is.na(data): is.na() applied to non-(list or vector) of
  ## type 'closure'
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## integer(0)
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
  
  
  
  {% highlight text %}
  ## Error in if (empty(.data)) return(.data): missing value where TRUE/FALSE needed
  {% endhighlight %}
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
  ## Error in d[[xx]]: object of type 'closure' is not subsettable
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
  
  
  
  {% highlight text %}
  ## Error in 1:dim(data)[2]: argument of length 0
  {% endhighlight %}
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
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in terms.formula(formula, data = data): 'data' argument is of the wrong type
  {% endhighlight %}
  
  
  
  {% highlight r %}
  names(tab_count) = c(1:length(tab_count))
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in eval(expr, envir, enclos): object 'tab_count' not found
  {% endhighlight %}
  
  
  
  {% highlight r %}
  # sum of marginals
  tab_sum=lapply(tab_count,addmargins)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in lapply(tab_count, addmargins): object 'tab_count' not found
  {% endhighlight %}
  
  
  
  {% highlight r %}
  print(tab_sum)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in print(tab_sum): object 'tab_sum' not found
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
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in eval(expr, envir, enclos): object 'tab_count' not found
  {% endhighlight %}
  
  
  
  {% highlight r %}
  print(tab_prop_sum)
  {% endhighlight %}
  
  
  
  {% highlight text %}
  ## Error in print(tab_prop_sum): object 'tab_prop_sum' not found
  {% endhighlight %}
*** 
