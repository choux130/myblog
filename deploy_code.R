install.packages(c("servr", "knitr"), repos = "http://cran.rstudio.com")

library(servr)
jekyll(dir = ".", input = c(".", "_source", "_posts"),
       output = c(".", "_posts", "_posts"),
       script = c("Makefile", "build.R"),
       serve = TRUE,
       command = "bundle exec jekyll build")
# command = "jekyll build"
# bundle exec jekyll serve? 