---
layout: post
title: "Comparisons between ioslides and Slidify in R Markdown Presentation"
author: "Yin-Ting Chou"
date: 2017-05-26
output: html_document
categories: [R]
tags: [R Presentation, ioslides, Slidify, plotly, DT, htmlwidgets ]
---
### Overview
Having an opportunity to give a presentation for my master thesis, I decided to give it a try on [R Markdown Presentation](http://rmarkdown.rstudio.com/lesson-11.html) with interactive graphs and planned to publish it online after the presentation. There are three main choices in R Studio for the R Markdown Presentation: [ioslides](http://rmarkdown.rstudio.com/ioslides_presentation_format.html), [Slidy](http://rmarkdown.rstudio.com/slidy_presentation_format.html), and [Beamer](http://rmarkdown.rstudio.com/beamer_presentation_format.html). Beamer is for `.pdf` file which cannot show the interactive graphs and not meets my need for this time. Both ioslides and Slidy are for `.html` file which can be opened in browser and can insert interactive graphs in it. And, the main reason for me to choose ioslides rather than Slidy is simple. The sample slides for ioslides looks prettier to me! I also did some research online and found that [Slidify](http://slidify.org) has huge online community and popularity. So, as a person who love to explore new and good things, Slidify successfully aroused my interest.

To sum up, this post is about the comparison between ioslides and Slidify from my experience making slides for my master thesis presentation. Well, I think I am not the only one who did this kind of comparison. Check out [Introduction to Presentations in Rmarkdown from Ian Kloo](http://data-analytics.net/cep/Schedule_files/presentations_demo.html). 

***

### Details 
* **<font size="4">Slidy</font>** <br /> 
  * **Pros:**
    1. Already has css file in the template. You can easily customize it to meet your own needs.
    2. It includes so many features which make it easier for user to create fancy slides.
    3. The online communities is big and helpful.
    4. The online documentation and resources is good! <br /> [Slidify](http://slidify.org),[ Slidify and rCharts](http://slidify.github.io/dcmeetup/#1),[ Example slidify - Joseph V. Casillas](http://www.jvcasillas.com/slidify_tutorial/)
    5. It can easily be published to Github Pages.

  * **Cons:**
    1. Though it works well for rendering interactive graphs, it is time consuming. I am not sure the reason, maybe it is because it has too many features. This is also the main reason for me to jump to ioslides.
    2. It takes time to be familiar with its settings and structure. It is just a little bit complicated. 
    3. It can render htmlwidgets but the size and other features can not be adjusted. What a pity! 


* **<font size="4">ioslides</font>** <br /> 
  * **Pros:**
    1. The time for compiling is not too bad especially when we have many interactive graphs in it.
    2. The template is not so complex, so it is easy to understand the structure by looking at the source code.
    3. The document from R Studio is also good! [http://rmarkdown.rstudio.com/ioslides_presentation_format.html](http://rmarkdown.rstudio.com/ioslides_presentation_format.html)
    4. It can be published on the Github Pages. You just need to rename the generated `.html` file to `index.html` and then put the file in the `gh-pages` branch of your github. To see how I did it, [Github repo -  slide_thesis_ioslides](https://github.com/choux130/slide_thesis_ioslides).
    
  * **Cons:**
    1. If you want more features, you have to write your own CSS code. So, it may be overwhelming if you do not have any foundation to CSS and HTML.
    2. Like Slidify, it can render htmlwidgets but the size and other features can not be adjusted. This means that it is useless if you try to adjust the size using this code, `<iframe src="/path/name.html" width="200" height="200"></iframe>`.  
* **<font size="4">Interactive Graphs</font>** <br /> 
  * **R packages**
    1. [Plotly](https://plot.ly/ggplot2/) <br />
        To make ggplot become interactive. 
    2. [DT](https://rstudio.github.io/DT/) <br />
        To make table become interactive. 
    3. [htmlwidgets](http://www.htmlwidgets.org) <br />
        Save the interactive output generated from plotly and DT as HTML widgets and then insert widgets in desired place using code, `<iframe src="/path/name.html"></iframe>`.
  
  * **Examples** <br />
    My final slides : [https://choux130.github.io/slide_thesis_ioslides/#1](https://choux130.github.io/slide_thesis_ioslides/#1) <br />
    All the ioslides files : [Github repo -  slide_thesis_ioslides](https://github.com/choux130/slide_thesis_ioslides)
  

{% highlight r %}
library(ggplot2)
library(plotly)
library(DT)
library(htmlwidgets)

###############
#### GRAPH ####
###############

#### 1. Pepare Data ####
datt=read.csv("/Users/chou/Google Drive/UMN2014-2016/Spring2016/Plan B/final/clean_dat.csv",header=TRUE)
levels(datt$PMD)=list(P="P",M="M",D="D")

#### 2. Generate ggplot ####
hist_PMD_a=ggplot(datt, aes(x=Area, color=PMD, fill=PMD))+
  geom_histogram(aes(y=..density..), alpha=0.5,
                 position="identity")+
  geom_density(alpha=.3)
box_PMD_a=ggplot(datt, aes(x=PMD, y=Area, fill=PMD)) + 
  geom_boxplot(outlier.shape=NA, outlier.colour = NA) +
  geom_point(position = position_jitter(h=0,w=0.3))

#### 3. Convert to interactive plots using plotly ####
p1 = plotly_build(hist_PMD_a)
p2 = plotly_build(box_PMD_a)
p = subplot(p1,p2, margin=0.05) 

#### 4. Convert to a HTML widget using htmlwidgets ####
path = paste("/Users/chou/Google Drive/websites/github/myblog-master", "/widget/", "area.html", sep="")
saveWidget(as_widget(p), file = path)

###############
#### TABLE ####
###############

#### 1. Prepare Data ####
dat = datt[,-c(1,4,5)]
names(dat) = c("Sample ID", "# in image", "image No.", 
                "image name", "location", "PMD", "SI", 
                "Area", "Perimeter", "Circularity",
                "Aspect Ratio")

#### 2. Convert to interactive table using DT ####
d=datatable(dat)

#### 3. Convert to HTML widget using htmlwidgets ####
path <- paste("/Users/chou/Google Drive/websites/github/myblog-master", "/widget/", "dat.html", sep="")
saveWidget(as_widget(d), file = path)
{% endhighlight %}

Click the tags at the right! 
<div style='position: relative; width: 100%; height: 0px; padding-bottom: 50%;'>
  <iframe style='position: absolute; left: 0px; top: 0px; width: 100%; height: 100%' src="{{ site.baseurl }}/widget/area.html" frameborder="0" allowfullscreen="allowfullscreen" ></iframe>
</div>
<br />
Scroll the bar at the right to see all the dataset!
<div style='position: relative; width: 100%; height: 0px; padding-bottom: 50%;'>
  <iframe style='position: absolute; width: 100%; height: 100%' src="{{ site.baseurl }}/widget/dat.html" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
</div>

<br />

