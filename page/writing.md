---
layout: page
title: Writing
permalink: /writing/
order: 3
---

### Overview
This page include some R markdown syntax that I used a lot for writing new posts and pages this website. Even though [Jekyll](https://jekyllrb.com) only support Markdown not R Markdown, I still can use [knitr-jekyll](https://github.com/yihui/knitr-jekyll) created by [Yihui](https://github.com/yihui) to convert my `.Rmd` file to `.md` file and then work well on Jekyll website. And, in Jekyll I chose kramdown as my converter to convert `.md` files to `.html` files. Because of a series of converting process, whenever I have errors on generating my posts or pages I will check the syntax not only from [R Markdown](http://rmarkdown.rstudio.com) but also from [Markdown](https://daringfireball.net/projects/markdown/), [kramdown](https://kramdown.gettalong.org) and [HTML](http://www.w3schools.com/html/default.asp).

***

### Useful Resources
1. [R Markdown Cheat Sheet by RStudio, 2016](https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf)
2. [R Markdown Reference Guide](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)
3. [DARING FIREBALL by John Gruber (the creator of Markdown)](https://daringfireball.net/projects/markdown/)
4. [Quick Reference for kramdown](https://kramdown.gettalong.org/quickref.html)
5. [HTML5 Tutorial in W3Schools](http://www.w3schools.com/html/default.asp)
6. [Chunk options for knitr by Yihui](https://yihui.name/knitr/options/)
7. [HackMD - Features](https://hackmd.io/features#share-notes)
***

### Details
* **<font size="4">YAML Header</font>**
  * <b>Commands on runing website locally</b>
  ```Bash
  $ cd /path/for/website/dir
  $ bundle exec jekyll serve
  ```
  * <b>Page</b>
  ```Bash
  ---
  layout: page
  title: About
  permalink: /about/
  order: 3
  ---
  ```
  The `order:3` is the order that shows on the navigation header. According to [How to change the default order pages in jekyll from stackoverflow](http://stackoverflow.com/questions/13266369/how-to-change-the-default-order-pages-in-jekyll), I can decide the order of my page by adding the following codes in my `header.html` file.
  ```html{% raw %}
  {% assign sorted_pages = site.pages | sort:"order" %}
  {% for page in sorted_pages %}
      {% if page.title and page.main_nav != false %}
      <li class="nav-link"><a href="{{ page.url | prepend: site.baseurl }}">{{ page.title }}</a>
     {% endif %}
  {% endfor %}{% endraw %}
  ```

  * <b>Post</b>
  ```Bash
  ---
  layout: post
  title: 'test title'
  date: 2017-01-25
  author: "Name_1"
  categories: [Cat1, Cat2]
  tags: [tag1, tag2]
  photocredit: "Name_2"
  cover:  "/path/photo.png"
  ---
  ```
  The `photocredit: "Name_2"` is the feature I added which is not included in the template. After mimicing the structure from the template, I added the following code to the `post.html` file. This post , [Jekyll Website with Github, Github Pages and R Markdown]({{ site.baseurl }}{% link _posts/2017-02-23-Jekyll-Website.md %}), shows hot it looks like.
  ```html{% raw %}
  {% if page.photocredit %}
    <p class="info"><font size="2">photo credit  <strong>{{ page.photocredit }}</strong></font></p>
    {% else %}
  {% endif %}{% endraw %}
  ```

* **<font size="4">Editing</font>**
  * `<br />` : <br />
    new line but in the same paragraph.
  * indent : <br />
    the following contents are in the same paragraph with the above contents.
  * `<ol start="3"></ol>` : <br />
    the next number list will start from 3. For example,
    ```html{% raw %}
    <ol start="3">
      <li> the first item </li>
      <li> the second item </li>
    </ol>{% endraw %}
    ```
    <ol start="3">
      <li> the first item </li>
      <li> the second item </li>
    </ol>
  * `<li style="font-weight: bold"></li>` : <br />
    the style of ordered list is **bold**. For example,
    ```html{% raw %}
    <ol start="3">
      <li style="font-weight: bold"> the first item </li>
      <li> the second item </li>
    </ol>{% endraw %}
    ```
    <ol start="3">
      <li style="font-weight: bold"> the first item </li>
      <li> the second item </li>
    </ol>
  * `<hyperlink> ` : <br />
    the hyperlink will be shown like `<https://github.com/choux130>`, <https://github.com/choux130>
  * `[word](the link)` : <br />
    the hyperlink will be shown as `[my github](https://github.com/choux130)`, [my github](https://github.com/choux130).
  * `<img src="link" style="width:30px;height:30px;" />` : <br />
  insert the photo from the link. If the link is from the current website directory, the link format is like this, `{% raw %}{{ site.baseurl }}/path/photo.png{% endraw %}`.
  * `<embed src="link" width="100%" height="400px" />` : <br />
  embed `.pdf` file from the link. <br />
  * `{% raw %}{{ site.baseurl }}{% link _posts/2017-01-01-name-of-post.md %}{% endraw %}`: <br />
    the hyperlink to the post in the current website directory. For example, the hyperlink to [Jekyll Website with Github, Github Pages and R Markdown]({{ site.baseurl }}{% link _posts/2017-02-23-Jekyll-Website.md %}).
  * `$` and `$$` : <br />
  math syntax. `$$` is particular for the equation. For example,
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
  * `<font color="green">word</font>` : <br /> <font color="green">color the word</font>. And [here](https://www.w3schools.com/colors/colors_names.asp) is a list of HTML color names.
  * `<font size="4">word</font>` : <br />
    <font size="5">change the font size.</font>
  * `` `word` `` : <br />
    `highlight the word` or wrap the word by `<code>word</code>`.
  * <code>```language </code>: <br />
    highlight the code with a certain language. <br />
  However, there are some issues in highlighting HTML code in Jekyll. And this is the [solution in stackflow](http://stackoverflow.com/questions/20568396/how-to-use-jekyll-code-in-inline-code-highlighting).
