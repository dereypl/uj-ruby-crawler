require 'httparty'
require 'nokogiri'
require 'byebug'
require 'open-uri'

def crawler
  url = 'https://www.amazon.pl/s?rh=n%3A20788294031%2Cp_72%3A4-&pd_rd_r=4a1022fa-16f6-43cc-a57b-7414de3b2dde&pd_rd_w=gGRNf&pd_rd_wg=Tvj7U&pf_rd_p=9070c810-a109-4d9e-9325-b5cfedb5f7c8&pf_rd_r=390T45J6XHNYXKP72GJ6&ref=Oct_d_otopr_S'
  doc = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'ruby'))

  products = doc.xpath("//div[@data-component-type='s-search-result']")
  parsed_products = Array.new

  products.each do |node|
    product = node.children.children.children.children.children[1]
    title = product.css('span.a-size-base-plus.a-color-base.a-text-normal').text
    price_whole = product.css('span.a-price-whole').text
    price_fraction = product.css('span.a-price-fraction').text

    prod = {
      title: title,
      price_whole: price_whole,
      price_fraction: price_fraction,
    }

    parsed_products << prod
  end

  parsed_products.each do |product|
    puts "Produkt: #{product[:title]}"
    puts "Cena: #{product[:price_whole]}#{product[:price_fraction]}"
    puts "\n\n"
  end

  byebug
end

crawler