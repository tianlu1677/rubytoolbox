module Stackapp
  class Rubyland
    def fetch_page
      res = Nokogiri.parse(File.read(file_path))
      item_list = res.css("item")
      item_list.each do |item_res|        
        item = {
           title:      item_res.css("title").text,
          desc:        item_res.css("description").text.to_s.strip,
          cover_url:   '',
          created_at:  item_res.css("pubDate"),
          tags:        item_res.css(".tags").text.split,
          source:      "rubyland",
          raw_url:     '',
          video_url:   "",
          raw_uid:     "",
          other_links: [],
        }
        puts item
      end
    end

    def fetch_page_list
      commend = "wget -O #{file_path} #{root_url}"
      system(commend)
    end

    def root_url
      "http://rubyland.news/feed.rss"
    end

    def file_path
      "#{[Rails.root, 'doc/content/rubyland'].join('/')}/rubylandnew-#{Date.today}.rss"
    end
  end
end
