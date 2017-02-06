---
layout: post
title: 'Human Resource Analytics: K-fold Cross Validation'
date: 2017-02-01
author: Yin-Ting 
categories: [Project]
tags: [R, Classification, k-fold CV]
---
For the purpose of avoiding overfitting and incresing model stability, K-fold Cross Validation sampling method is applied before all the model fitting. There are two steps for the K-fold Cross Validation. First, decide the proportion for the train, validation and test set[^1]. Second, decide the number of fold, K[^2]. 

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
# This is the test test which will only be used in the model selection part. 
test=cv2(data,0.9)$dat_2 #1499   10
{% endhighlight %}



{% highlight text %}
## Error in sample.int(length(x), size, replace, prob): invalid 'size' argument
{% endhighlight %}

[^2]: Let K


{% highlight r %}
# This is the dataset that we will do k-fold cross validation on. 
dd=cv2(data,0.9)$dat_1 
{% endhighlight %}



{% highlight text %}
## Error in sample.int(length(x), size, replace, prob): invalid 'size' argument
{% endhighlight %}



{% highlight r %}
#13500    10

dd_k1_train=cv2(dd, 0.7/0.9)$dat_1 # 10500    10
{% endhighlight %}



{% highlight text %}
## Error in nrow(data): object 'dd' not found
{% endhighlight %}



{% highlight r %}
dd_k1_val=cv2(dd, 0.7/0.9)$dat_2 # 3000   10
{% endhighlight %}



{% highlight text %}
## Error in nrow(data): object 'dd' not found
{% endhighlight %}
