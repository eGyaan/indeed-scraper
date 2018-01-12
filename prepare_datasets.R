

# Scrape data from search of "Data Scientist" near NYC.
data_sci = scrape_indeed(
  base_url = 'https://www.indeed.com/jobs?q=data+scientist&l=new+york%2C+ny',
  num_pages = 5
)

# Scrape data from search of "Data Analyst" near NYC.
data_ana = scrape_indeed(
  base_url = 'https://www.indeed.com/jobs?q=data+analyst&l=New+York%2C+NY',
  num_pages = 5
)

# Transform.
data_sci_2 = data_sci %>%
  filter(
    # Keep only ads w/ "Data Scientist" in the title.
    grepl(pattern = 'data scientist', x = title, ignore.case = TRUE),
    # Remove cases where job title contains "analyst" or seniority level.
    !grepl(pattern = 'analyst|sr.|jr.|senior|junior|lead|intern', 
           x = title, ignore.case = TRUE)
  ) 

data_ana_2 = data_ana %>%
  filter(
    grepl(pattern = 'data analyst', x = title, ignore.case = TRUE),
    !grepl(pattern = 'scientist|sr.|jr.|senior|junior|lead|intern', 
           x = title, ignore.case = TRUE)
  ) 

