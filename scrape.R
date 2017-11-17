library('pacman')
p_load(rvest, tidyverse, magrittr)

# Note: Indeed *frequently* changes their urls & HTML class names.


################################
### I. Inputs 
################################

# Set "base url", the first page of search results.
base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'

# Set number of pages of search results we want the scraper to parse.
num_pages = 5

# Set "current url" initially to base url. This will be the page that the loop
# works on in each iteration.
current_url = base_url

# We want to scrape job titles, companies, & job summaries from each search
# result. Create empty data frames to house the scraped data.
titles = list()

companies = list()

summaries = list()

# We'll grow these lists. Make index for the list element that gets updated 
# in each iteration.
k = 0

# Loop through each page.
for (i in 1:num_pages) {
  
  # 1. Go to Indeed.com, grab current page, and load it into R as an xml document.
  current_page = read_html(current_url)
  
  # 2. Get job ads from current page, find the nodes containing job ads, and
  # store the job ad nodes in a list.
  ads = current_page %>%
    html_nodes('[class="  row  result"]') # Job ads are contained in these nodes.
  
  # 3. Loop through each job ad node in our list.
  for (j in 1:length(ads)) {
    
    # 3a. Get the job title and add it to our data frame of titles.
    titles[[j + k]] = ads[[j]] %>%
      html_nodes('[class=jobtitle]') %>%
      html_text()  # Outputted as a character.
    
    # 3b. Get the company.
    companies[[j + k]] = ads[[j]] %>%
      html_nodes('[class=company]') %>%
      html_text()
    
    # 3c. Get the job summary.
    summaries[[j + k]] = ads[[j]] %>%
      html_nodes('[class=summary]') %>%
      html_text() 
    
  }
  
  # 4. Update list index.
  k = k + j
  
  # Recap: We've scraped the data we want from every job ad on the current page.
  
  # 5. Change the current url to be the url of the next page of search results.
  # Note: Indeed's search result page url's follow a simple pattern. 
  # Page 1 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'.
  # Page 2 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start=10'.
  # Page 3 is ''https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start=20'.
  current_url = paste0(base_url, '&start=', as.character(i * 10))
  
  # 6. Wait 1 second, to look more human.
  Sys.sleep(1)
  
  # 7. Repeat steps 1-6 for every page of search results.
  
}

# Collapse lists into matrices.
titles = do.call(rbind, titles)

companies = do.call(rbind, companies)

summaries = do.call(rbind, summaries)

# Combine titles and summaries into one tibble. Each row in titles is
# from the same exact ad as its corresponding row in summaries. (That was the
# whole point of using list indexes above.)
data_sci = cbind(titles, companies, summaries) %>%
  as.tibble() %>%
  set_colnames(c('title', 'company', 'summary'))

# Filter out cases where job title contains "analyst" or implies seniority.
data_sci %<>%
  filter(!grepl(pattern = 'data analyst|sr.|jr.|senior|junior|lead', 
                x = title, ignore.case = TRUE)) 







# https://dashee87.github.io/data%20science/data-scientists-vs-data-analysts-part-1/
# https://stat4701.github.io/edav/2015/04/02/rvest_tutorial/
# https://github.com/hadley/rvest
# https://medium.com/@msalmon00/web-scraping-job-postings-from-indeed-96bd588dcb4b
# https://jessesw.com/Data-Science-Skills/

# may want to automate my browser w/ Selenium: http://www.seleniumhq.org/

s = html_session('https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny')

s %<>%
  jump_to(url = )
