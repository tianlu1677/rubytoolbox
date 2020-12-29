module Stackapp
  class Gorails
    def fetch_page(page = 1)      
      path = file_path(page)
      res = Nokogiri.parse(File.read(path))
      item_list = res.css(".bg-white .rounded-md.group")
      item_list.each do |item_res|
        next if item_res.css("h5").blank?

        item = {
          title:           item_res.css("h5").text.to_s.strip,
          desc:            item_res.css("p.text-muted").text,
          cover_url:       item_res.css(".episode-thumbnail img").attr("src").value,
          created_at:      item_res.css("time").text,
          tags:            [],
          source:          "gorails",
          raw_url:         "https://www.gorails.com#{item_res.css('a').first.attr('href')}",
          video_url:       "",
          raw_uid:         "",
          other_links:     [],
          video_reduction: item_res.css(".episode-length").text.to_s,
        }
        puts item
      end
    end

    def fetch_page_list
      37.times do |i|
        page = i + 1
        commend = "wget -O #{file_path(page)} #{root_path}?page=#{page}"
        system(commend)
      end
    end

    def root_path
      "https://gorails.com/episodes"
    end

    def file_path(page = 1)
      "#{[Rails.root,'doc/content/gorails'].join('/')}/gorails-page#{page}.html"
    end

  end
end
