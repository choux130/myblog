---
layout: page
title: Syntax
permalink: /syntax/
---
Usually, I create my data analysis report through R Markdown or R Sweave which can make me unexpectedly easily combine all text, R codes, output and images in one PDF/ Word/ HTML file. However, this is not the most surprising part of it. R Markdown can even help me with publishing posts/ pages in my Jekyll website. Thanks for Yihui's hard work ([knitr-jekyll](https://github.com/yihui/knitr-jekyll)) on converting `.Rmd` file to `.md` file which is supported by Jekyll. And the following are some notes about creating new posts or pages through R Markdown. 

### Writing Posts 

#### YAML Header

Add `comments: false` if **Disqus** is not needed.  

```
---
layout: post
title: 'test title'
date: 2017-01-25
author: Yin-Ting 
categories: [test]
tags: [tag1, tag2]
---
```

#### Steps:
1. Create a `.Rmd` file in `_source` file.
2. Name the file in the form of `yyyy-mm-dd-title`. Ex: `2017-01-01-test-post.Rmd`.
3. Run the following code in R. 
```{r eval=FALSE}
library(servr)
jekyll(dir = ".", input = c(".", "_source", "_posts"),
       output = c(".", "_posts", "_posts"),
       script = c("Makefile", "build.R"),
       serve = TRUE,
       command = "bundle exec jekyll build")  
# command = "jekyll build"
```
{:start="4"}
4. Then the new post is in `_posts` folder. 

***

### Writing Pages
#### YAML Header
```
---
layout: page
title: About
permalink: /about/
---
```

#### Steps
1. Create a `.Rmd` file in `_source` file.
2. Name the file with same name as the one show on the website. Ex: `about.Rmd` 
3. Run the code in R which is the same as above.
4. Move the generated `.md` file in `_posts` to the main directory. 

***

### Syntax 
* New line but in the same paragraph, `<br />`.
* Continue the number list. Ex: `{:start="3"}` : the list start from 3. 
* Highlight words. <br /> 
Use symbol `` ` `` to include the words you want to highlight. Ex: \` word \` : `word`. 
* Hyperlink. <br />
  + `<the hyperlink>` <br />
Ex: `<https://github.com/choux130>` :<https://github.com/choux130> <br />
  + `[the words to show](the link)` <br />
Ex: `[my github](https://github.com/choux130)` : [my github](https://github.com/choux130)
* Add image. <br /> 
`<img src="link_to_the_image" style="width:30px;height:30px;" />` <br />
Ex: `<img src="https://github.com/favicon.ico" style="width:30px;height:30px;" />` : 
<img src="https://github.com/favicon.ico" style="width:30px;height:30px;" />
* Math syntax and equation. Thanks to [Mathjax](http://docs.mathjax.org/en/latest/start.html#tex-and-latex-input)! <br />
Ex:
  + `$\alpha$` : $\alpha$. 
  + <br />
  $$
  \begin{align}
  2+3 &= x \\ 
  x+2 &= 5y
  \end{align}
  $$
```{r eval=FALSE}
$$
\begin{align}
2+3 &= x \\
x+2 &= 5y
\end{align}
$$
```
* Add footnotes. <br />
Ex: ESL [^1]

  ```
  ESL[^1]

  [^1]: English as a second language
  ```

### References 
1. [knitr-jekyll by Yuhui](https://github.com/yihui/knitr-jekyll)
2. [R Markdown Cheat Sheet by RStudio](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)
3. [DARING FIREBALL by John Gruber ](https://daringfireball.net/projects/markdown/)

***

[^1]: English as a second language.


