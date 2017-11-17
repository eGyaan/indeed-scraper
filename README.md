# indeed-scraper

## Intro

This is a simple scraper of Indeed.com job ads for "Data Scientist" and "Data Analyst". I want to replicate [this analysis](https://dashee87.github.io/data%20science/data-scientists-vs-data-analysts-part-1/) for such jobs in the US.

## Issues

1. It appears Indeed no longer lists skills in their front page results.

2. I'm currently scraping only the "front page" version of each ad. That is, I do not "click" each job ad's link and pull skills data from the actual job ad text. Doing so would often lead the scraper to non-Indeed websites.