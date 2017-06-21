---
layout: post
title: 'How Web Scraping eases my job searching pain? - Part II : Scrape contents from a list of URLs'
author: Yin-Ting 
date: 2017-06-14
photocredit: Yin-Ting Chou
categories: [Python]
tags: [Web Scraping]
cover: "/assets/post_image/IMG_6277.JPG"
---
<style>
ol > li {
  font-weight: bold;
}
span{
   font-weight: normal;
}
</style>

### Overview
**<font color="darkred">The Github repository for this project : </font>** [choux130/webscraping_example](https://github.com/choux130/webscraping_example).

From the previous post, [How Web Scraping eases my job searching pain? - Part I : Scrape contents from one URL]({{ site.baseurl }}{% link _posts/2017-06-05-web-scraping.md %}), we know how to summarize all the job searching results from [Careerbuilder](http://www.careerbuilder.com/) into a `.csv` file with the following features:
  * _From which Job Searching Website_ 
  * _Job ID (related to Job Link)_ 
  * _Job Title_ 
  * _Job Company_ 
  * _Location_ 
  * _Job Link_ 
  <br />
  <a href="{{ site.baseurl }}/assets/image/webscrape/web_jobs2.png">
  <img src="{{ site.baseurl }}/assets/image/webscrape/web_jobs2.png" style="width:100%"/></a>

And, to abtain more details more each jobs, in this post we are going to add few more features by scraping every _Job Link_. Hence, for each Job, we will also know their 
  * _Job Type_ 
  * _Required Skills_ 
  * _Required Education Level_
  * _Preferred Majors_ 
  * _Interesting Keywords_ 
  * _All the Text in the Page_
  <br />
  <a href="{{ site.baseurl }}/assets/image/webscrape/web_jobs3.png">
  <img src="{{ site.baseurl }}/assets/image/webscrape/web_jobs3.png" style="width:100%"/></a>
  <br />
  
Here is a rough idea about how what we are going to do. First, we have to define what are the _Job Type_, _Required Skills_, _Required Education Level_, _Preferred Majors_ and _Interesting Keywords_. These can be based on observations on many job description or personal interest. Then, use code to find out whether the defined terms are included in the job pages. If it is in the pages, pick it up and record it in the `.csv` file. 

*** 

### Details
* **<font size="4">References</font>** <br />
Thank you all so much!
  * [Jesse Steinweg-Woods, Ph.D. - Web Scraping Indeed for Key Data Science Job Skills](https://jessesw.com/Data-Science-Skills/)
  * [7.2. re — Regular expression operations](https://docs.python.org/2/library/re.html)
  
* **<font size="4">Steps</font>** <br />
  1. Read the `.csv` file saved from [Part I]({{ site.baseurl }}{% link _posts/2017-06-05-web-scraping.md %}) and do some preparations. 
      ```python 
      ########################################################
      #################### IMPORT LIBRARY ####################
      ########################################################
      # import bs4
      # import numpy
      # import pandas
      # import re
      # import requests
      # import datetime
      # import stop_words

      # read the csv file
      # path = '/path/output/' + 'job_careerbuilder_' + now_str_name + '.csv'
      job_df_careerbuilder = pandas.DataFrame.from_csv(path)
      
      # define the stop_words for future use
      stop_words = stop_words.get_stop_words('english') # list out all the English stop word
      # print(stop_words)
      ```
  2. Define what are <i>Job Type</i>, <i>Required Skills</i>, <i>Required Education Level</i>, <i>Preferred Majors</i>, <i>Interesting Keywords</i> and <i>All the Text in the Page</i>. 
      * <i>Job Type</i> <br />
        <span>The first `type_lower` are the exact wording showing in the pages (when searching all the words will be in lower cases). It will be mapped to the updated `type` by using dictionary, and then be shown in the cell of the `.csv` file. The purpose for the mapping is mainly for wording consistency which is important to my further text analysis, the similarity between all jobs using [Term Frequency and Inverse Document Frequency (TF - IDF)](https://janav.wordpress.com/2013/10/27/tf-idf-and-cosine-similarity/). </span>
        ```python 
        ####################################################
        ##### DEFINE THE TERMS THAT I AM INTERESTED IN #####
        ####################################################
        
        ##### Job types #####
        type = ['Full-Time', 'Full Time', 'Part-Time', 'Part Time', 'Contract', 'Contractor']
        type_lower = [s.lower() for s in type] # lowercases, the exact wording 
        
        # map the type_lower to type
        type_map = pandas.DataFrame({'raw':type, 'lower':type_lower}) # create a dataframe
        type_map['raw'] = ["Full-Time", "Full-Time", 'Part-Time', 'Part-Time', "Contract", 'Contract'] # modify the mapping
        type_dic = list(type_map.set_index('lower').to_dict().values()).pop() # use the dataframe to create a dictionary
        #print(type_dic)
        ```
        <pre><code class="language-text" data-lang="text"><span>{'full-time': 'Full-Time', 'full time': 'Full-Time', 
        'part-time': 'Part-Time', 'part time': 'Part-Time',
        'contract': 'Contract', 'contractor': 'Contract'}</span></code></pre>

      * <i>Required Skills</i> <br />
        <span>It is also referred to <a href= "https://jessesw.com/Data-Science-Skills/">Web Scraping Indeed for Key Data Science Job Skills</a>.</span>
        ```python
        ##### Skills #####
        skills = ['R', 'Shiny', 'RStudio', 'Markdown', 'Latex', 'SparkR', 'D3', 'D3.js',
            'Unix', 'Linux', 'MySQL', 'Microsoft SQL server', 'SQL',
            'Python', 'SPSS', 'SAS', 'C++', 'C', 'C#','Matlab','Java',
            'JavaScript', 'HTML', 'HTML5', 'CSS', 'CSS3','PHP', 'Excel', 'Tableau',
            'AWS', 'Amazon Web Services ','Google Cloud Platform', 'GCP',
            'Microsoft Azure', 'Azure', 'Hadoop', 'Pig', 'Spark', 'ZooKeeper',
            'MapReduce', 'Map Reduce','Shark', 'Hive','Oozie', 'Flume', 'HBase', 'Cassandra',
            'NoSQL', 'MongoDB', 'GIS', 'Haskell', 'Scala', 'Ruby','Perl',
            'Mahout', 'Stata']
        skills_lower = [s.lower() for s in skills]# lowercases
        skills_map = pandas.DataFrame({'raw':skills, 'lower':skills_lower})# create a dataframe
        skills_map['raw'] = ['R', 'Shiny', 'RStudio', 'Markdown', 'Latex', 'SparkR', 'D3', 'D3',
            'Unix', 'Linux', 'MySQL', 'Microsoft SQL server', 'SQL',
            'Python', 'SPSS', 'SAS', 'C++', 'C', 'C#','Matlab','Java',
            'JavaScript', 'HTML', 'HTML', 'CSS', 'CSS','PHP', 'Excel', 'Tableau',
            'AWS', 'AWS','GCP', 'GCP',
            'Azure', 'Azure', 'Hadoop', 'Pig', 'Spark', 'ZooKeeper',
            'MapReduce', 'MapReduce','Shark', 'Hive','Oozie', 'Flume', 'HBase', 'Cassandra',
            'NoSQL', 'MongoDB', 'GIS', 'Haskell', 'Scala', 'Ruby','Perl',
            'Mahout', 'Stata']
        skills_dic = list(skills_map.set_index('lower').to_dict().values()).pop()# use the dataframe to create a dictionary
        # print(skills_dic)
        ```
        
      * <i>Required Education Level</i> <br />
        ```python
        ##### Education #####
        edu = ['Bachelor', "Bachelor's", 'BS', 'B.S', 'B.S.', 'Master', "Master's", 'Masters', 'M.S.', 'M.S', 'MS',
                'PhD', 'Ph.D.', "PhD's", 'MBA']
        edu_lower = [s.lower() for s in edu]# lowercases
        edu_map = pandas.DataFrame({'raw':edu, 'lower':edu_lower})# create a dataframe
        edu_map['raw'] = ['BS', "BS", 'BS', "BS", 'BS', 'MS', "MS", 'MS', 'MS', 'MS', 'MS',
                'PhD', 'PhD', "PhD", 'MBA'] # modify the mapping
        edu_dic = list(edu_map.set_index('lower').to_dict().values()).pop()# use the dataframe to create a dictionary
        # print(edu_dic)
        ```

      * <i>Preferred Majors</i> <br />
        ```python
        ##### Major #####
        major = ['Computer Science', 'Statistics', 'Mathematics', 'Math','Physics',
            'Machine Learning','Economics','Software Engineering', 'Engineering',
            'Information System', 'Quantitative Finance', 'Artificial Intelligence',
            'Biostatistics', 'Bioinformatics', 'Quantitative']
        major_lower = [s.lower() for s in major]# lowercases
        major_map = pandas.DataFrame({'raw':major, 'lower':major_lower})# create a dataframe
major_map['raw'] = ['Computer Science', 'Statistics', 'Math', 'Math','Physics',
            'Machine Learning','Economics','Software Engineering', 'Engineering',
            'Information System', 'Quantitative Finance', 'Artificial Intelligence',
            'Biostatistics', 'Bioinformatics', 'Quantitative']# modify the mapping
        major_dic = list(major_map.set_index('lower').to_dict().values()).pop()# use the dataframe to create a dictionary
        # print(major_dic)
        ```
        
      * <i>Interesting Keywords</i> <br />
        ```python
        ##### Key Words ######
        keywords = ['Web Analytics', 'Regression', 'Classification', 'User Experience', 'Big Data',
            'Streaming Data', 'Real-Time', 'Real Time', 'Time Series']
        keywords_lower = [s.lower() for s in keywords]# lowercases
        keywords_map = pandas.DataFrame({'raw':keywords, 'lower':keywords_lower})# create a dataframe
keywords_map['raw'] = ['Web Analytics', 'Regression', 'Classification', 'User Experience', 'Big Data',
            'Streaming Data', 'Real Time', 'Real Time', 'Time Series']# modify the mapping
        keywords_dic = list(keywords_map.set_index('lower').to_dict().values()).pop()# use the dataframe to create a dictionary
        # print(keywords_dic)
        ```
  3. Use For Loop to scrape all the URLs and then pick out the interested terms if they are in the page texts. <br />
      * <span>Creat empty lists for storing features of <b>all</b> the jobs. </span>
        ```python 
        ##############################################
        ##### FOR LOOP FOR SCRAPING EACH JOB URL #####
        ##############################################
        # empty list to store details for all the jobs
        list_type = []
        list_skill = []
        list_text = []
        list_edu = []   
        list_major = []
        list_keywords = []
        ```
      * <span>For each loop, create empty lists for storing features of the $i^{th}$ job.</span>
        ```python
        for i in range(len(job_df_careerbuilder)):
            # empty list to store details for each job
            required_type= []
            required_skills = []
            required_edu = []
            required_major = []
            required_keywords = []
        ```
      * <span>Extract the all the meaningful texts from the URL. <br />
      The reason for the `try:` and `except:` in the for loop is to avoid termination from the forbidden pages.</span>
        ```python
            try:
                # get the HTML code from the URL
                job_page = requests.get(job_df_careerbuilder.iloc[i, 5])
                # Choose "lxml" as parser
                soup = bs4.BeautifulSoup(job_page.text, "lxml")

                # drop the chunks of 'script','style','head','title','[document]'
                for elem in soup.findAll(['script','style','head','title','[document]']):
                    elem.extract()
                # get the lowercases of the texts
                texts = soup.getText(separator=' ').lower()
        ```
      * <span>Clean the texts data.</span>
        ```python
                # cleaning the text data
                string = re.sub(r'[\n\r\t]', ' ', texts) # remove "\n", "\r", "\t"
                string = re.sub(r'\,', ' ', string) # remove ","
                string = re.sub('/', ' ', string) # remove "/"
                string = re.sub(r'\(', ' ', string) # remove "("
                string = re.sub(r'\)', ' ', string) # remove ")"
                string = re.sub(' +',' ',string) # remove more than one space
                string = re.sub(r'r\s&\sd', ' ', string) # avoid picking 'r & d'
                string = re.sub(r'r&d', ' ', string) # avoid picking 'r&d'
                string = re.sub('\.\s+', ' ', string) # remove "." at the end of sentences
        ```
      * <span>For each feature, pick out all the interested terms and then save them in a list.</span>
        ```python
                ##### Job types #####
                for typ in type_lower :
                    if any(x in typ for x in ['+', '#', '.']):
                        # make it possible to find out 'c++', 'c#', 'd3.js' without errors
                        typp = re.escape(typ) 
                    else:
                        typp = typ
                    # search the string in a string
                    result = re.search(r'(?:^|(?<=\s))' + typp + r'(?=\s|$)', string) 
                    if result:
                        required_type.append(type_dic[typ]) 
                list_type.append(required_type) 

                ##### Skills #####
                for sk in skills_lower :
                    if any(x in sk for x in ['+', '#', '.']):
                        skk = re.escape(sk)
                    else:
                        skk = sk
                    result = re.search(r'(?:^|(?<=\s))' + skk + r'(?=\s|$)',string)
                    if result:
                        required_skills.append(skills_dic[sk])
                list_skill.append(required_skills)

                ##### Education #####
                for ed in edu_lower :
                    if any(x in ed for x in ['+', '#', '.']):
                        edd = re.escape(ed)
                    else:
                        edd = ed
                    result = re.search(r'(?:^|(?<=\s))' + edd + r'(?=\s|$)', string)
                    if result:
                        required_edu.append(edu_dic[ed])
                list_edu.append(required_edu)

                ##### Major #####
                for maj in major_lower :
                    if any(x in maj for x in ['+', '#', '.']):
                        majj = re.escape(maj)
                    else:
                        majj = maj
                    result = re.search(r'(?:^|(?<=\s))' + majj + r'(?=\s|$)', string)
                    if result:
                        required_major.append(major_dic[maj])
                list_major.append(required_major)

                ##### Key Words #####
                for key in keywords_lower :
                    if any(x in key for x in ['+', '#', '.']):
                        keyy = re.escape(key)
                    else:
                        keyy = key
                    result = re.search(r'(?:^|(?<=\s))' + keyy + r'(?=\s|$)', string)
                    if result:
                        required_keywords.append(keywords_dic[key])
                list_keywords.append(required_keywords)
        
                ##### All text #####
                words = string.split(' ') # transform to a list
                job_text = set(words) - set(stop_words) # drop stop words
                list_text.append(list(job_text))
                
            except: # to avoid Forbidden webpages
                list_type.append('Forbidden')
                list_skill.append('Forbidden')
                list_edu.append('Forbidden')
                list_major.append('Forbidden')
                list_keywords.append('Forbidden')
                list_text.append('Forbidden')
            #print(i) # for tracking purpose
        ```
      * <span>Add all features to the original datafame and update the `.csv` files.</span>
        ```python
        # Add new columns
        job_df_careerbuilder['job_type'] = list_type
        job_df_careerbuilder['job_skills'] = list_skill
        job_df_careerbuilder['job_edu'] = list_edu
        job_df_careerbuilder['job_major'] = list_major
        job_df_careerbuilder['job_keywords'] = list_keywords
        job_df_careerbuilder['job_text'] = list_text

        # reorder the columns 
        cols=['from','date','job_id','job_title','job_company','job_location','job_link','job_type',
        'job_skills', 'job_edu', 'job_major', 'job_keywords','job_text']
        job_df_careerbuilder = job_df_careerbuilder[cols]

        # print the dimenstion of the dataframe
        print(job_df_careerbuilder.shape)
        
        # save the dataframe as a csv file
        # path = '/path/output/' + 'job_careerbuilder_' + now_str_name + '.csv'
        job_df_careerbuilder.to_csv(path)
        ```
        <span>`(26, 13)`</span>
        <br /><br />
        <a href="{{ site.baseurl }}/assets/image/webscrape/web_jobs3.png">
  <img src="{{ site.baseurl }}/assets/image/webscrape/web_jobs3.png" style="width:100%"/></a><br />

* **<font size="4">Troubles</font>** <br />
  Let me know if you have better ideas about how to solve the following problems. 
  1. **Not easy to get the exact text data I want.** <br />
      <span>My desired text data for each job page is only the job description part. However, it is hard to use simple code to seperate them from other chunks nicely. Because of this, my code may pick some terms which are not shown in the job description part and then lower my data quality. 
  2. **Different poeple say different terms.** <br />
      <span>For example, in our case if we click into the link of the following jobs, we will found that the "_CSS_" is just the abbreviation of the company's name and "_GCP_" seems not to mean "_Google Cloud Platform_" at all. This can also lower my data quality.</span>
<a href="{{ site.baseurl }}/assets/image/webscrape/trouble.png">
  <img src="{{ site.baseurl }}/assets/image/webscrape/trouble.png" style="width:100%"/></a>
<a href="{{ site.baseurl }}/assets/image/webscrape/trouble_2.png">
  <img src="{{ site.baseurl }}/assets/image/webscrape/trouble_2.png" style="width:100%"/></a>

* **<font size="4">Part II is done, but the code can be more efficient and neat! Part III is on the way! </font>** <br />
  Now, we know how to generate an informative `.csv` file for the searching results from [Careerbuilder](http://www.careerbuilder.com/). Then, we can just do the same things on [Indeed](https://www.indeed.com/), [Monster](https://www.monster.com/) and [Dice](http://www.dice.com/). Check out my [Github repo - webscraping_example](https://github.com/choux130/webscraping_example) for the example code. 

  If you follow my example code for the above four job searching websites, you will find that the code is repetitive, the `.csv` files are seperated and it is time consuming when searching results are a lot. So, I am trying to create modules and packages, combine all the seperated `.csv` files, and then use parallel computing module, `multiprocessing`, to speed up the running time. All the details will be in my next post, **How Web Scraping eases my job searching pain? - Part III : Make it Efficient**. 

***
