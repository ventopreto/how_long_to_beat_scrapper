# frozen_string_literal: true

require './config/boot'

class WebScrapper
  def self.hltb_request(game)
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

  def self.hltb_parse(response)
    return 'Não é possivel parsear uma resposta vazia' if response.body.include?('No results for')

    doc = Nokogiri::HTML(response.body)
    JSON.pretty_generate({
                           'title' => doc.css('div.search_list_details > h3 > a')[0].text.strip,
                           'main_story' => doc.css('div.search_list_details > div > div > div:nth-child(2)')[0].text.strip,
                           'main_+_extra' => doc.css('div.search_list_details > div > div > div:nth-child(4)')[0].text.strip,
                           'completionist' => doc.css('div.search_list_details > div > div > div:nth-child(6)')[0].text.strip
                         })
  end

  def self.format_time(time)
    if time.include?('½')
      time.gsub(/(\d+)(½)? (Hours?|Mins?)/, '\1:30:00')
    elsif time.include?('Mins')
      time.gsub(/(\d+)(½)? (Hours?|Mins?)/, '00:\1:00')
    elsif time == '--'
      time
    else
      time.gsub(/(\d+)(½)? (Hours?|Mins?)/, '\1:00:00')
    end
  end
end
