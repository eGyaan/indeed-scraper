# I made 2 Indeed web scrapers. The 1st is horrible bcs it grows vectors.
# The 2nd is an attempted improvement. It grows lists.
# Which is more efficient?
# Both scrapers must extract the same data & store it in vector form.

library('profvis')

# First scraper.

profvis(expr = {
  
  library('tidyverse')
  library('rvest')
  
  base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'
  
  num_pages = 5

  current_url = base_url
  
  titles = tibble()
  
  summaries = tibble()
  
  for (i in 1:num_pages) {
    
    current_url_page = read_html(current_url)
    
    ads = current_url_page %>%
      html_nodes('[class="  row  result"]') 
    
    for (j in 1:length(ads)) {
      
      titles = ads[[j]] %>%
        html_nodes('[class=jobtitle]') %>%
        html_text() %>% 
        as.tibble() %>% 
        rbind(titles)
      
      summaries = ads[[j]] %>%
        html_nodes('[class=summary]') %>%
        html_text() %>%
        as.tibble() %>%
        rbind(summaries)
      
    }
    
    current_url = paste0(base_url, '&start=', as.character(i * 10))
    
  }
  
  # Stop here bcs the scraper outputs titles & summaries in vector form already.
  
}, prof_output = 'original_scraper')


# Second Scraper

profvis(expr = {
  
  library('tidyverse')
  library('rvest')
  
  base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'
  
  num_pages = 5
  
  current_url = base_url
  
  titles = list()
  
  summaries = list()
  
  k = 0
  
  for (i in 1:num_pages) {

    current_url_page = read_html(current_url)
    

    ads = current_url_page %>%
      html_nodes('[class="  row  result"]') 
    
    for (j in 1:length(ads)) {
      
      titles[[j + k]] = ads[[j]] %>%
        html_nodes('[class=title]') %>%
        html_text()  # Outputted as a character.
      
      summaries[[j + k]] = ads[[j]] %>%
        html_nodes('[class=summary]') %>%
        html_text() 
      
    }
    
    k = k + j
    
    current_url = paste0(base_url, '&start=', as.character(i * 10))
    
  }
  
  # Put titles & summaries in vector form.
  
  titles = do.call(rbind, titles)
  
  summaries = do.call(rbind, summaries)
  
}, prof_output = 'maybe_better_scraper')


# 2nd scraper's runtime is ~70% that of the 1st scraper.
