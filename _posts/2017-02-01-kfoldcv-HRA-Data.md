---
layout: post
title: 'Human Resource Analytics: K-fold Cross Validation'
date: 2017-02-01
author: Yin-Ting 
categories: [Project]
tags: [R, Classification, k-fold CV]
---
For the purpose of avoiding overfitting and incresing model stability, K-fold Cross Validation sampling method should be applied before all the model fitting. There are two steps for the K-fold Cross Validation. First, decide the proportion for the train, validation and test set[^1]. Second, decide the number of fold, K[^2]. 

[^1]: In this project, I subjectively decide to set 70% for the train set; 20% for the validation and 10% for the test set. 

### The function for seperate data into two parts based on proportion

{% highlight r %}
cv2=function(data, prop1){
  N = nrow(data)
  n = ceiling(N*prop1)
  ind = sample(N,n)
  sep1= data[ind,]
  sep2= data[-ind,]
  
  list(dat_1=sep1, dat_2=sep2)
}
{% endhighlight %}


{% highlight r %}
# This is the test set which will only be used in the model selection part. 
test=cv2(data,0.9)$dat_2 #1499   10
{% endhighlight %}



{% highlight text %}
## Error in sample.int(length(x), size, replace, prob): invalid 'size' argument
{% endhighlight %}

[^2]: Let K=10


{% highlight r %}
k=10
data$cv_group=sample(rep(1:k, length.out=nrow(data)), 
                     nrow(data), replace=FALSE)
{% endhighlight %}



{% highlight text %}
## Warning in rep(1:k, length.out = nrow(data)): first element used of
## 'length.out' argument
{% endhighlight %}



{% highlight text %}
## Error in sample.int(length(x), size, replace, prob): invalid 'size' argument
{% endhighlight %}



{% highlight r %}
# the fold 1 validation set
first_val=data[data$cv_group=="1",]
{% endhighlight %}



{% highlight text %}
## Error in data$cv_group: object of type 'closure' is not subsettable
{% endhighlight %}



{% highlight r %}
# the fold 1 train set 
first_train=data[data$cv_group!="1",]
{% endhighlight %}



{% highlight text %}
## Error in data$cv_group: object of type 'closure' is not subsettable
{% endhighlight %}
