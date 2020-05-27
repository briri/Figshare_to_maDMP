# Figshare_to_maDMP
Convert FigShare JSON to RDA Common Standard maDMP JSON

## Requirements
Ruby >= 2.6.3
A Figshare user account and an application defined for API access

## Installation
- Clone the repository
- Run `bundle install`

## Running the prototype
- Run `ruby figshare_to_madmp.rb`
- Open `127.0.0.1:4567` in a browser
- Enter a search term like 'DMP'
  - Click on the Figshare link on the results page to see the Figshare JSON
  - Click on the RDA Common Standard link on the results page to see the RDA maDMP JSON
