library('pacman')
p_load(rvest, tidyverse, magrittr)


################################
### I. Inputs 
################################

# Set "base url," the first page of the search.
base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'

# Set number of pages of search results we want the scraper to parse.
num_pages = 5


################################
### II. Scraper 
################################

# Set "current url" initially to base url. This will be the page that the loop
# works on in each iteration, and then updates to be the next search page.
current_url = base_url

# We want to scrape job titles and brief job descriptions from each search
# result. Create empty data frames to house the scraped data.
titles = tibble()

descriptions = tibble()

# Loop through each page.
for (i in 1:num_pages) {
  
  # 1. Go to Indeed.com, grab current page, and load it into R as an xml document.
  current_url_page = read_html(current_url)

  # 2. Get job ads from current page, find the nodes containing job ads, and
  # store the job ad nodes in a list.
  ads = current_url_page %>%
    html_nodes('[class="  row  result"]') # Job ads are contained in nodes of this class.
  
  # 3. Loop through each job ad node in our list.
  for (j in 1:length(ads)) {
    
    # 3a. Get the job title and add it to our data frame of titles.
    titles = ads[[j]] %>%
      html_nodes('[itemprop=title]') %>%
      html_text() %>% # Outputted as a character.
      as.tibble() %>% # Convert to data frame so it can be appended to our "titles" data frame.
      rbind(titles)
    
    # 3b. Get the job description and add it to our data frame of descriptions.
    descriptions = ads[[j]] %>%
      html_nodes('[itemprop=description]') %>%
      html_text() %>%
      as.tibble() %>%
      rbind(descriptions)
    
  }
  
  # Recap: We've scraped the data we want from every job ad on the current page.
  
  # 4. Change the current url to be the url of the next page of search results.
  # Note: Indeed's search result page url's follow a simple pattern. 
  # Page 1 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'.
  # Page 2 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start10'.
  # Page 3 is ''https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start20'.
  current_url = paste0(base_url, '&start', as.character(i * 10))
  
  # 5. Wait 1 second, to look more human.
  Sys.sleep(1)
  
  # 6. Repeat steps 1-5 for every page of search results.
  
}

# Combine titles and descriptions into one data frame. Each row in titles is
# from the same exact ad as its corresponding row in descriptions. That was the
# whole point of the big loop above.
data_sci = cbind(titles, descriptions) %>%
  set_colnames(c('title', 'description'))

# Filter out cases where job title contains "analyst", implies seniority, or is
# dumb.
data_sci %<>%
  filter(!grepl(pattern = 'data analyst|Sr.|Jr.|senior|junior|lead|machine learning', 
                x = title, ignore.case = TRUE)) 

  


# Set "base url," the first page of the search.
base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'

# Set number of pages of search results we want the scraper to parse.
num_pages = 5

# Set "current url" initially to base url. This will be the page that the loop
# works on in each iteration, and then updates to be the next search page.
current_url = base_url

# We want to scrape job titles and brief job descriptions from each search
# result. Create empty data frames to house the scraped data.
titles = list()

descriptions = list()

k = 0

# Loop through each page.
for (i in 1:num_pages) {
  
  # 1. Go to Indeed.com, grab current page, and load it into R as an xml
  # document.
  current_url_page = read_html(current_url)
  
  # 2. Get job ads from current page, find the nodes containing job ads, and
  # store the job ad nodes in a list.
  ads = current_url_page %>%
    html_nodes('[class="  row  result"]') # Job ads are contained in nodes of this class.
  
  # 3. Loop through each job ad node in our list.
  for (j in 1:length(ads)) {
    
    # 3a. Get the job title and add it to our data frame of titles.
    titles[[j + k]] = ads[[j]] %>%
      html_nodes('[itemprop=title]') %>%
      html_text()  # Outputted as a character.
    
    # 3b. Get the job description and add it to our data frame of descriptions.
    descriptions[[j + k]] = ads[[j]] %>%
      html_nodes('[itemprop=description]') %>%
      html_text() 
    
  }
  
  # 4. 
  k = k + j
  
  # Recap: We've scraped the data we want from every job ad on the current page.
  
  # 5. Change the current url to be the url of the next page of search results.
  # Note: Indeed's search result page url's follow a simple pattern. 
  # Page 1 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'.
  # Page 2 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start10'.
  # Page 3 is ''https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start20'.
  current_url = paste0(base_url, '&start', as.character(i * 10))
  
  # 6. Wait 1 second, to look more human.
  Sys.sleep(1)
  
  # 7. Repeat steps 1-6 for every page of search results.
  
}

titles = do.call(rbind, titles)

descriptions = do.call(rbind, descriptions)

# Combine titles and descriptions into one data frame. Each row in titles is
# from the same exact ad as its corresponding row in descriptions. That was the
# whole point of the big loop above.
data_sci = cbind(titles, descriptions) %>%
  set_colnames(c('title', 'description'))

# Filter out cases where job title contains "analyst", implies seniority, or is
# dumb.
data_sci %<>%
  filter(!grepl(pattern = 'data analyst|Sr.|Jr.|senior|junior|lead|machine learning', 
                x = title, ignore.case = TRUE)) 


# profiled both chunks. latter is 38% faster!


# Set "base url," the first page of the search.
base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'

# Set number of pages of search results we want the scraper to parse.
num_pages = 5

# Set "current url" initially to base url. This will be the page that the loop
# works on in each iteration, and then updates to be the next search page.
current_url = base_url

# We want to scrape job titles and brief job descriptions from each search
# result. Create empty data frames to house the scraped data.
titles = list()

descriptions = list()

k = 0

# Loop through each page.
for (i in 1:num_pages) {
  
  # 1. Go to Indeed.com, grab current page, and load it into R as an xml
  # document.
  current_url_page = read_html(current_url)
  
  # 2. Get job ads from current page, find the nodes containing job ads, and
  # store the job ad nodes in a list.
  ads = current_url_page %>%
    html_nodes('[class="  row  result"]') # Job ads are contained in nodes of this class.
  
  # 3. Loop through each job ad node in our list.
  for (j in 1:length(ads)) {
    
    # 3a. Get the job title and add it to our data frame of titles.
    titles[[j + k]] = ads[[j]] %>%
      html_nodes('[itemprop=title]') %>%
      html_text()  # Outputted as a character.
    
    # 3b. Get the job description and add it to our data frame of descriptions.
    descriptions[[j + k]] = ads[[j]] %>%
      html_nodes('[itemprop=description]') %>%
      html_text() 
    
  }
  
  # 4. 
  k = k + j
  
  # Recap: We've scraped the data we want from every job ad on the current page.
  
  # 5. Change the current url to be the url of the next page of search results.
  # Note: Indeed's search result page url's follow a simple pattern. 
  # Page 1 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'.
  # Page 2 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start10'.
  # Page 3 is ''https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start20'.
  current_url = paste0(base_url, '&start', as.character(i * 10))
  
  # 6. Wait 1 second, to look more human.
  Sys.sleep(1)
  
  # 7. Repeat steps 1-6 for every page of search results.
  
}

titles = do.call(rbind, titles)

descriptions = do.call(rbind, descriptions)

# Combine titles and descriptions into one data frame. Each row in titles is
# from the same exact ad as its corresponding row in descriptions. That was the
# whole point of the big loop above.
data_sci = cbind(titles, descriptions) %>%
  set_colnames(c('title', 'description'))

# Filter out cases where job title contains "analyst", implies seniority, or is
# dumb.
data_sci %<>%
  filter(!grepl(pattern = 'data analyst|Sr.|Jr.|senior|junior|lead|machine learning', 
                x = title, ignore.case = TRUE)) 









  
  xp = read_html(current_url) %>%
    html_nodes(css = '.snip .experienceList') %>%
    html_text() %>%
    as.tibble() %>%
    rbind(xp)
  



  

base_url_page = read_html('https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny')

title = base_url_page %>%
  html_nodes(css = "a.turnstileLink") %>%
  html_attr("title") %>%
  as.tibble() %>%
  filter(!is.na(value),
         !grepl(pattern = 'reviews|analyst|Sr.|Jr.|senior|junior|lead', 
                x = value, ignore.case = TRUE))

# https://dashee87.github.io/data%20science/data-scientists-vs-data-analysts-part-1/
# https://stat4701.github.io/edav/2015/04/02/rvest_tutorial/
# https://github.com/hadley/rvest
# https://medium.com/@msalmon00/web-scraping-job-postings-from-indeed-96bd588dcb4b
# https://jessesw.com/Data-Science-Skills/

# may want to automate my browser w/ Selenium: http://www.seleniumhq.org/

s = html_session('https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny')

s %<>%
  jump_to(url = )

read_html(current_url) %>%
  html_nodes(css = '.jobtitle .turnstileLink') %>%
  html_attr('title') %>%
  as.tibble() 
