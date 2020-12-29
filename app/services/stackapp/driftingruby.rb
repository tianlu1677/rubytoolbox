module Stackapp
  class Driftingruby
    def fetch_page(page =1)
      
      path = file_path(page)
      res = Nokogiri.parse(File.read(path))
      item_list = res.css(".container .card")
      item_list.each do |item_res|
        item = {
          title:       item_res.css(".card-body h3").text.to_s.strip,
          desc:        item_res.css('p.text-muted').text.to_s.strip,
          cover_url:   item_res.css(".card-img").attr("src").to_s,
          created_at:  item_res.css(".card-body .episode_light span.ml-3").first.text,
          tags:        item_res.css('.tags').text.split,
          source:      "driftingruby",
          raw_url:     "https://www.driftingruby.com/#{item_res.css('>a').first.attr('href')}"
          video_url:   "",
          raw_uid:     "",
          other_links: [],
        }
        puts item
      end
    end

    def fetch_list
      27.times do |i|
        page = i + 1
        system("wget -O #{file_path(page)}  #{root_path}?page=#{page}")
      end
    end

    def root_path
      "https://www.driftingruby.com/episodes"
    end

    def file_path(page = 1)
      "#{[Rails.root,'doc/content/driftingruby'].join('/')}/driftingruby-page#{page}.html"
    end
  end
end
