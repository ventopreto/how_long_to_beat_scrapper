# frozen_string_literal: true

require 'nokogiri'
require 'faraday'
class WebScrapper
  def hltb_request(game)
    url = 'https://howlongtobeat.com/search_results?page=1'
    body =    {
      'page': '1',
      'queryString': game,
      't': 'games',
      'sorthead': 'popular',
      'sortd': '0',
      'length_type': 'main',
      'randomize': '0'
    }
    headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Referer': 'https://howlongtobeat.com/',
      'User-Agent': 'Mozilla/5.0'
    }
    Faraday.post(url, body, headers)
  end
end
