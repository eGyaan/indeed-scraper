library(magrittr)
library(rvest)
library(tidyverse)

scrape_indeed = function(base_url, num_pages) {
  
  # This will be the page that the loop works on in each iteration.
  # Set it initially to the base URL, since that's the 1st page we'll scrape.
  current_url = base_url
  
  # Create empty lists to house the scraped data.
  titles = list()
  
  companies = list()
  
  summaries = list()
  
  # Index of the first element edited in each iteration of the loop.
  k = 0
  
  # Loop through each page.
  for (i in 1:num_pages) {
    
    # 1. Navigate to current page & load it into R as XML.
    current_page = read_html(current_url)
    
    # 2. Extract job ads from current page, find the nodes containing job ads, &
    # store them in a list.
    ads = current_page %>%
      html_nodes('[class="  row  result"]')
    
    # 3. Loop through each ad.
    for (j in 1:length(ads)) {
      
      # 3a. Get the job title and add it to a list.
      titles[[j + k]] = ads[[j]] %>%
        html_nodes('[class=jobtitle]') %>%
        html_text()  # Outputted as character.
      
      # 3b. Get the company.
      companies[[j + k]] = ads[[j]] %>%
        html_nodes('[class=company]') %>%
        html_text()
      
      # 3c. Get the job summary.
      summaries[[j + k]] = ads[[j]] %>%
        html_nodes('[class=summary]') %>%
        html_text() 
      
    }
    
    # 4. The lists each have k + j elements. Increase k so that we don't overwrite
    #    the list contents in the next loop iteration.
    k = k + j
    
    # Recap: We've scraped the data we want from every job ad on the current page.
    
    # 5. Change the current URL to be the URL of the next page of search results.
    # Note: Indeed's search result page url's follow a simple pattern. 
    # Page 1 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny'.
    # Page 2 is 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start=10'.
    # Page 3 is ''https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny&start=20'.
    current_url = paste0(base_url, '&start=', as.character(i * 10))
    
    # 6. Wait 1-5 seconds, to look more human.
    Sys.sleep(runif(n = 1, min = 1, max = 5))
    
    # 7. Repeat steps 1-6 for every page of search results.
    
  }
  
  # Combine lists into matrices.
  titles_2 = do.call(rbind, titles)
  
  companies_2 = do.call(rbind, companies)
  
  summaries_2 = do.call(rbind, summaries)
  
  # Combine matrices one tibble.
  scraped = cbind(titles_2, companies_2, summaries_2) %>%
    as.tibble() %>%
    set_colnames(c('title', 'company', 'summary'))
  
  return(scraped)
  
}
