# WebScraper
Tracking the processing status of different data sources is an essential feature of any effective ETL (Extract, Transform, Load) system. *WebScraper* is an ETL system built using the [WebCrawler](https://github.com/dsdugal/webcrawler) project that demonstrates one manner in which the processing status of web pages can be accounted for. It is a single-fire system that takes a URL as input and scrapes the content off the page and saves both the URL hash and the content hash in a MongoDB database for further use. Content hashes can be compared to determine whether or not a particular instance of the page has already been processed by the system, which can help reduce unnecessary processing time. *WebScraper* will update the database entry for a particular page if the content hash has changed on a subsequent run.

*Note: This project is intended for educational purposes, and as such is limited in its functionality. A practical ETL solution may want to take into account dynamic content generation rather than hashing the entire page since there may only be a portion of the page that is static.*

#### Stack
------------
- IMAGE Linux/MacOS
- IMAGE [MongoDB](https://www.mongodb.com/)
- IMAGE [Ruby](https://www.ruby-lang.org/en/)
- IMAGE [Bundler](https://bundler.io/)
- [WebCrawler](https://github.com/dsdugal/webcrawler)

#### Installation
------------
1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation)
2. Clone the [WebCrawler](https://github.com/dsdugal/webcrawler) repository to the desired location.
```
git clone https://github.com/dsdugal/webcrawler webcrawler
```
3. Clone the project repository to the same parent directory.
```
git clone https://github.com/dsdugal/webscraper webscraper
```
4. Install the required gems.
```
cd webscraper
bundle install
```
5. Install [MongoDB 6.0 Community Edition](https://www.mongodb.com/docs/manual/administration/install-community).
6. Configure a [MongoDB Database instance](https://www.mongodb.com/basics/create-database).
```
brew services start mongodb/brew/mongodb-community
mongosh
use webscraper
```

#### Usage
------------
Navigate to the project root and execute the **webscraper.rb** script.

Basic run: ```ruby bin/webscraper.rb https://www.google.ca```
Display options: ```ruby bin/webscraper.rb --help```

#### Roadmap
------------
- [x] Develop primary ETL concept
- [ ] Develop comprehensive unit tests
