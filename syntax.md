---
layout: page
title: Writing
permalink: /syntax/
order: 3
---

### Overview
This page include some R markdown syntax that I used a lot for writing new posts and pages of [my website]({{site.baseurl}}). Even though Jekyll only support Markdown not R Markdown, I still can use [knitr-jekyll](https://github.com/yihui/knitr-jekyll) created by Yihui to convert my `.Rmd` file to `.md` file and then work well on Jekyll website. And, in jekyll I chose kramdown as my converter to convert `.md` files to `.html` files. Because of a series of converting process, whenever I have errors on generating my posts or pages I will check the syntax not only from [R Markdown](http://rmarkdown.rstudio.com) but also from [Markdown](https://daringfireball.net/projects/markdown/), [kramdown](https://kramdown.gettalong.org) and [HTML](http://www.w3schools.com/html/default.asp).

***

### Useful Resources
1. [R Markdown Cheat Sheet by RStudio, 2016](https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf)
2. [R Markdown Reference Guide](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)
3. [DARING FIREBALL by John Gruber (the creator of Markdown)](https://daringfireball.net/projects/markdown/)
4. [Quick Reference for kramdown](https://kramdown.gettalong.org/quickref.html)
5. [HTML5 Tutorial in W3Schools](http://www.w3schools.com/html/default.asp)
6. [Chunk options for knitr by Yihui](https://yihui.name/knitr/options/)

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
  * `<span style="color:darkblue">word</span>` : color the word. And [this](https://www.w3schools.com/colors/colors_names.asp) is a list of HTML color names.
  * `<font size="4">word</font>` : change the font size.
  * `` `word` `` : highlight the word or wrap the word by `<code>word</code>`.
  * <code>```language </code>: highlight the code with a certain language. <br />
  However, there are some issues in highlighting HTML code in Jekyll. And this is the [solution in stackflow](http://stackoverflow.com/questions/20568396/how-to-use-jekyll-code-in-inline-code-highlighting).

***
