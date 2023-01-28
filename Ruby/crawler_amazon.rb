require 'proxycrawl'
require 'nokogiri'
require 'open-uri'

class Item
  def initialize(name, price, link)
    @item_name = name
    @item_price = price
    @item_link = link
  end

  def name
    @item_name
  end

  def price
    @item_price
  end

  def link
    @item_link
  end
end

def print_scrapped_items(items)
  items.each do |item|
    print(item.name, "\n")
    print(item.price, "\n")
    print(item.link, "\n")
  end
end

def scraping(url)
  api = ProxyCrawl::API.new(token: "dhWWX_tNMHu6T0NEhFcDYw")
  html = api.get(url)
  doc = Nokogiri::HTML.parse(html.body)
  items = doc.css('.a-link-normal').css('.s-underline-text').css(".s-underline-link-text").css(".s-link-style").css(".a-text-normal")
  scrapped_items = []
  links = []
  items.each do |item|
    href = item.attributes["href"]
    if href != nil
      link = "https://www.amazon.com" + href
      unless links.include? link
        item_html = api.get(link)
        item_doc = Nokogiri::HTML.parse(item_html.body)
        begin
          name = item_doc.at('#productTitle').text.strip
          price = item_doc.at('#corePrice_feature_div').css('.a-offscreen').text.strip
        rescue NoMethodError
          print('Poszukiwana nazwa lub cena elementu nie została znalezione, umieszczam sam link do produktu', "\n")
          item = Item.new("Nieznana nazwa", "Nieznana cena", link)
        else
          item = Item.new(name, price, link)
        end
        links.append(link)
        scrapped_items.append(item)
      end
    end
  end
  scrapped_items
end

scrapped_items = scraping('https://www.amazon.com/s?k=computers&crid=1I7ZIIJYIHE8L&sprefix=computer%2Caps%2C199&ref=nb_sb_noss_1')
#print_scrapped_items(scrapped_items)