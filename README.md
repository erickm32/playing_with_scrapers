# playing_with_scrapers

Both ruby files are tiny web scrapers to look for my name on pdf publications on that specific public selection (concurso) on the AOCP site or to look for related publications on the DOU page.

To run, just install

`gem install 'selenium-webdriver'`

`gem install 'httparty'`

`gem install 'pdf-reader'`

on ruby 3+ and run

`ruby aocp_scraper.rb`
or
`ruby dou_scraper.rb`
