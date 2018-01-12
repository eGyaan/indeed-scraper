# indeed-scraper

## Intro

This is a simple scraper for "Data Scientist" and "Data Analyst" job postings on Indeed.com. I want to replicate [this analysis](https://dashee87.github.io/data%20science/data-scientists-vs-data-analysts-part-1/) for such jobs in the US; however, applying for a Publisher ID to access the Jobs API didn't work out for me. Thus, I will scrape.

## Issues

* Indeed does not list skills in their front page results. 
* Most links lead to non-Indeed sites. 
    * I could use Selenium, etc, to click through each link and extract info from the external job ads.

## To-do

* Extract job summaries and replicate [this](https://medium.com/@msalmon00/web-scraping-job-postings-from-indeed-96bd588dcb4b) analysis.
* Make list of skills.
    * Either configure a headless browser or automate crawling with Rvest. Search for words from list within each ad.
