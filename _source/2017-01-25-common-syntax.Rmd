---
layout: post
title: "Common Syntax on writing posts"
date: 2017-01-25
author: Yin-Ting
categories: [Website]
tags: [Rmarkdown, Markdown, kramdown, HTML, Jekyll]
---
### Overview
This post is some R markdown syntax that I used for creating new posts and pages of [my website]({{site.baseurl}}). Actually, Jekyll does not support R Markdown to write posts and pages but Markdown. Thanks to Yihui's hard work ([knitr-jekyll](https://github.com/yihui/knitr-jekyll)) on converting `.Rmd` file to `.md` file to work well on Jekyll-base website, like [my website]({{site.baseurl}}). And the converter I used in my Jekyll-base website is kramdown which can convert `.md` files to `.html` files. Because of a series of converting process, whenever I have errors on generating my posts or pages I will check the syntax not only from <span style="color:darkgreen">**R Markdown**</span> but also from <span style="color:darkgreen">**Markdown**</span>, <span style="color:darkgreen">**kramdown**</span> and <span style="color:darkgreen">**HTML**</span>.

***

### Reference
4. [knitr-jekyll by Yuhui](https://github.com/yihui/knitr-jekyll)
5. [Post about Reordering Pages in stackoverflow](http://stackoverflow.com/questions/13266369/how-to-change-the-default-order-pages-in-jekyll)
6. [Post about Highlight HTML Code in stackoverflow](http://stackoverflow.com/questions/20568396/how-to-use-jekyll-code-in-inline-code-highlighting)

***

### Useful Resources
1. [R Markdown Cheat Sheet by RStudio](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)
2. [DARING FIREBALL by John Gruber (the creator of Markdown)](https://daringfireball.net/projects/markdown/)
3. [Quick Reference for kramdown](https://kramdown.gettalong.org/quickref.html)
4. [HTML5 Tutorial in W3Schools](http://www.w3schools.com/html/default.asp)

***

### Details
* **YAML Header**
  * Page
  ```
  ---
  layout: page
  title: About
  permalink: /about/
  order: 3
  ---
  ```
  The `order:3` is the order that shows on the navigation header. According to [this post in stackoverflow](http://stackoverflow.com/questions/13266369/how-to-change-the-default-order-pages-in-jekyll), I can decide the order of my page by adding the following codes in my `header.html` file.
  ```html{% raw %}
  {% assign sorted_pages = site.pages | sort:"order" %}
  {% for page in sorted_pages %}
      {% if page.title and page.main_nav != false %}
      <li class="nav-link"><a href="{{ page.url | prepend: site.baseurl }}">{{ page.title }}</a>
     {% endif %}
  {% endfor %}{% endraw %}
  ```

  * Post
  ```
  ---
  layout: post
  title: 'test title'
  date: 2017-01-25
  author: Name
  categories: [Cat1, Cat2]
  tags: [tag1, tag2]
  cover:  "/path/photo.png"
  ---
  ```

* **Editing**
  * `<br />` : new line but in the same paragraph.
  * indent : the following contents are in the same paragraph with the above contents.
  * `{:start="3"}` : the next number list will start from 3.
  * `<hyperlink> ` : the hyperlink will be shown like <https://github.com/choux130>
  * `[word](the link)` : the hyperlink will be shown as [my github](https://github.com/choux130)
  * `<img src="link" style="width:30px;height:30px;" />` : <br />
  insert the photo from the link. If the link is from the current website directory, the link format is like this, `{% raw %}{{ site.baseurl }}/path/photo.png{% endraw %}`.
  * `$` or `$$` : math syntax. `$$` is particular for the equation. Example,
  ```
  $$
  \begin{align}
  2+3 &= x \\
  x+2 &= 5y
  \end{align}
  $$
  ```
  $$
  \begin{align}
  2+3 &= x \\
  x+2 &= 5y
  \end{align}
  $$
  * `<span style="color:darkblue">word</span>` : color the word. And [this](https://www.w3schools.com/colors/colors_names.asp) is the list of HTML color names.
  * `<font size="4">word</font>` : change the font size. 
  * `` `word ` `` : highlight the word or wrap the word by `<code>word</code>`.
  * <code>```language </code>: highlight the code with a certain language.
  However, according to [this post in stackflow](http://stackoverflow.com/questions/20568396/how-to-use-jekyll-code-in-inline-code-highlighting), there are some issues in highlighting HTML code in Jekyll. So, if we want to highlight HTML code, we have to first wrap the code with `{raw}code{endraw}` and have some `%` in there. Basically, it will have error if we type `{` and `%` together. Check the post for more details.

***
