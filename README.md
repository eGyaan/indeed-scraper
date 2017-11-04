# indeed-scrape

## Intro

I'm trying to scrape data from Indeed.com on skills appearing in job ads for "Data Scientist" and "Data Analyst". This has been done before [here](https://dashee87.github.io/data%20science/data-scientists-vs-data-analysts-part-1/). I want to do a similar analysis for such jobs in the NYC and Philadelphia metropolitan areas.

## Issues

I'm currently scraping skills info from the "front page" version of every ad. That is, I do not "click" each job ad's link and pull skills data from the actual job ad text. Instead, I rely on skill info being listed for every ad in the search results page. 

SKills are listed in the search results page for every single "Data Scientist" ad, but not for any "Data Analyst" ads.