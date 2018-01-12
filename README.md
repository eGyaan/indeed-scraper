# indeed-scraper

## Intro

This is a simple scraper for "Data Scientist" and "Data Analyst" job postings on Indeed.com. I want to replicate [this analysis](https://dashee87.github.io/data%20science/data-scientists-vs-data-analysts-part-1/) for such jobs in the US; however, applying for a Publisher ID to access the Jobs API didn't work out for me. Thus, I will scrape.

## Issues

* Indeed does not list skills in their results.
* I can only extract short snippets of each job summary.
* Most links lead to non-Indeed sites.

## To-do

* Instead replicate [this](https://medium.com/@msalmon00/web-scraping-job-postings-from-indeed-96bd588dcb4b) analysis.
* Automate crawling, either with Rvest or [RSelenium](https://cran.r-project.org/web/packages/RSelenium/vignettes/RSelenium-basics.html#basic-navigation). 
    * Make list of skills.
    * Search for words from list within each ad.
