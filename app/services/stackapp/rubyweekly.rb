module Stackapp
  class Rubyweekly
    def fetch_page(page = 532)
      res = Nokogiri.parse(File.read(file_path(page)))
      item_list = res.css("table.item")      
      item_list.each do |item_res|        
        item = {
          title:       item_res.css("span.mainlink a").text,
          desc:        item_res.css('p.desc').children.last.text,
          cover_url:   '',
          created_at:  res.css('.el-splitbar p').first.text.split(' — ').last,
          tags:        [],
          source:      "rubyweekly",
          raw_url:     item_res.css('span.mainlink a').attr('href').text,
          video_url:   "",
          raw_uid:     "",
          other_links: [],
        }
        puts item
      end
    end

    def fetch_page_list
      times = 531
      [531].each do |i|
        page = i + 1
        commend = "wget -O #{file_path(page)} #{root_url(page)}"
        system(commend)
      end      
    end

    def root_url(page = 531)
      "https://rubyweekly.com/issues/#{page}"
    end

    def file_path(page = 1)
      "#{[Rails.root, 'doc/content/rubyweekly'].join('/')}/rubyweekly-#{page}.rss"
    end
  end
end
