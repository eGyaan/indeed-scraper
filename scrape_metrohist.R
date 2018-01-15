library(magrittr)
library(rvest)
library(tidyverse)

session = html_session('http://www.metrohistory.com/dbpages/NBsearch.lasso') 

form = html_form(session)[[1]] %>%
  set_values(year = 1900)

current_page = rvest::submit_form(session, form)

costs = current_page %>%
  html_nodes(css = 'td:nth-child(3) div font') %>%
  html_text() %>%
  as_tibble() %>%
  filter(value != 'COST')

bldg_adds = current_page %>%
  html_nodes(css = 'td:nth-child(4)') %>%
  html_text() %>%
  as_tibble() %>%
  filter(value != '',
         !grepl(pattern = 'BUILDING ADDRESS', x = value))

# https://stat4701.github.io/edav/2015/04/02/rvest_tutorial/