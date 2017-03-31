---
layout: post
title: 'Jekyll Website with Github, Github Pages and R Markdown'
date: 2017-02-23
author: Yin-Ting
photocredit: Fang-Di Yang
categories: [Website]
tags: [Jekyll, Rmarkdown, Github Pages]
cover: "/assets/post_image/DSC02810.JPG"
---
### Overview
I am a stats person and my programming experience are all about statistical modeling, data manipulating and numerical computing. So, I did not have any idea about setting up a website at first. I started to play with [Wordpress online](https://wordpress.com/start/design-type-with-store). It is easy to use and has very beautiful interface but limited functions. So I tried to do [Wordpress offline](https://wordpress.org/download/). Many wonderful extensions can be added on it but the website structure is too complicated to control. Sometimes, when errors happen, all I get is just a white page without any error codes. It is hard for me to debug. Hence, after doing so many reserch online, I decided to use Jekyll. And, this post record the process I have benn through, the resources I have read and the things I have tried to do and work. 

Hope this post can help anyone who is also new to website setup but has passions for having one. Please feel free to leave any comments. Let's discuss and learn together! 

***

### Details
* **<font size="4">Why Jekyll not Wordpress? </font>** <br />
  There are 3 main reasons why I chose Jekyll not Wordpress. 
  
  **Firstly, Wordpress does not work well with R Markdown.** <br />
  Although we also can use R Markdown to generate posts on Wordpress by using the [package RWordPress](https://yihui.name/knitr/demo/wordpress/), it did not work really well on transforming formats and syntax. The posts on Wordpress are always different from the HTML files you compile in R Markdown. On the contrary, by using [knitr-jekyll](https://github.com/yihui/knitr-jekyll) in my Jekyll website, the formats and contents of posts are almost exactly the same as what I compile in R Markdown. So, writing posts in Jekyll is definitely more fun than in Wordpress. 
  
  **Secondly, the website structure behind Wordpress is far more complicated than Jekyll.** <br />
  The website structure behind Wordpress includes MySQL, PHP and Apache which I am not familiar with and may be too technical for me. On the other hand, a Jekyll website is a directory file consists of many `.html`, `.scss`, `.json`, `.xml` files which you can easily open the files and modify them. Hence, I think Jekyll is more controllable than Wordpress for its simplicity. 
  
  **Finally, many prominent data scientist also choose Jekyll for their personal website for project website.** <br /> 
  For example, [Yihui Xie](https://yihui.name), [Brenda Rocks](https://brendanrocks.com), [Simply Statistics](http://simplystatistics.org), [The caret Package](http://topepo.github.io/caret/index.html), [R for Data Science](http://r4ds.had.co.nz)...etc. 



* **<font size="4">Part I: Jekyll, Github and Github Pages</font>** <br />
  * **Basic ideas** <br />
  Before setting up a Jekyll website and hosting it on Github with Github Pages, I think I should have a rough idea about what they are and what they can do. So, the following is the resources that I have browsed.
  
    * Resources for starting
      1. [Github Guides](https://guides.github.com)
      2. [Github Pages](https://pages.github.com)
      3. [Jekyll](https://jekyllrb.com)
    
  * **Steps for connecting all of them** <br />
  Then, it's time for us to make those three work together on my own computers. The following are the steps to do it with some helpful resources. 
  
    1. Install Jekyll on my computer. [Jekyll Tips - Install Jekyll on Mac OS X](http://jekyll.tips/jekyll-casts/install-jekyll-on-os-x/)
    2. Find a desired Jekyll template. [Jekyll Theme](http://jekyllthemes.org) and [Start Bootstrap Templates](https://startbootstrap.com/template-categories/all/)
    3. Deploy the website on Github. [How to Deploy a Website Using GitHub Desktop by Deep Datta](https://www.youtube.com/watch?v=39hnYDC_o9U) and [Github Pages and Jekyll Tutorial by WebJeda](https://www.youtube.com/channel/UCbOO7d0vVo0kIrkd7m32irg)
    4. Run Jekyll locally. [Building a static website with Jekyll and GitHub Pages](http://programminghistorian.org/lessons/building-static-sites-with-jekyll-github-pages#section3a)
      
        * Change your directory to the website directory. 
        
          ```
          $ cd /path/for/website/dir
          ```
          
        * Install `Jekyll bundler` using `gem`. 
          
          ```
          $ gem install jekyll bundler
          ```
        
        * Install the contents in bundler. 
      
          ```
          $ bundle install 
          ```
      
        * Update the bundler.
          
          ```
          $ bundle update
          ```
      
        * Run the website locally.
          
          ```
          $ bundle exec jekyll serve
          ```
          


          
* **<font size="4">Part II: Change appearances, Add features and R Markdown</font>** <br />
  Afer finishing all the deployment, I started to cutomize my website by modifying some .html and .scss files in the templates. The text editor I used for all the modifications is [Atom](https://atom.io). I also imported some features to ease my way on my future posting and editing. The following are the features I added in my website and some relevant resources. 

  * **Appearance**:
    1. Make my own logo and replace the logo form template. [logomakr](https://logomakr.com)  
    2. Change the color of font, background and hover. [W3School](https://www.w3schools.com/colors/colors_picker.asp) <br />
      Modify codes in `_variables.scss` and `_typography`. 
      
  * **Features**: 
    1. Use R Makdown to publish posts. [knitr-jekyll](https://github.com/yihui/knitr-jekyll) <br /> 
       Download the related files and put them in the website directory. 
    2. Add math syntax by using LaTeX notations in R Markdown. [Mathjax](http://docs.mathjax.org/en/latest/start.html) <br />
       Copy the following codes in `header.html` file. 
       
       ```
       <!-- MathJax -->
       <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
       <script type="text/x-mathjax-config">
          MathJax.Hub.Config({
          tex2jax: {inlineMath: [['$','$'], ['\[','\]']]}
          });</script>
       ```  
    3. Change the order of pages.  [How to change the default order pages in jekyll
from stackoverflow](http://stackoverflow.com/questions/13266369/how-to-change-the-default-order-pages-in-jekyll) 
    4. Add a page with search bar. [How to Make lunr.js and Jekyll Work Together (with Gotchas)](http://rayhightower.com/blog/2016/01/04/how-to-make-lunrjs-jekyll-work-together/) 
    5. Add comment feature by using [Disqus](https://disqus.com). [How to add Disqus comments to Jekyll Blog - Tutorial 9](https://www.youtube.com/watch?v=etvHFmVCvj8)
    6. Highlight syntax and codes. [Highlight.js](https://highlightjs.org) <br />
    Luckily I have this feature in my template, so I do not need to add this again. But if your website template do not have this feature and you want to add it, here is how you may want to do. Copy the following codes into your `header.html` and change the `default.min.css` to the style name you want. [Here are all the styles](https://highlightjs.org/static/demo/). Or, you can download all the Highlight.js library to your website directory by following the [instruction](https://highlightjs.org/usage/). 

{% highlight html %}
{% raw %}
<link rel="stylesheet"  href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/styles/default.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.9.0/highlight.min.js"></script>
{% endraw %}
{% endhighlight %}
      
  

***
