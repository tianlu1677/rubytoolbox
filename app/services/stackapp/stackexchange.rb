module Stackapp
  class Stackexchange
    attr_accessor :client_id, :key

    def initialize(client_id = "19403", key = "8qwQOrMcRd*4tfCBkiGJEA((")
      @client_id = client_id
      @key = key
    end

    def client
      cli = SE::API::Client.new(key, site: 'stackoverflow')
    end

    # 39177136
    # https://api.stackexchange.com/docs/posts-by-ids#order=desc&sort=activity&ids=39177136&filter=!--1nZvb-RChP&site=stackoverflow
    # Stackapp::Stackexchange.new.client
    def post_detail(id)
    end

    def answer_detail

    end

    def comment_list

    end

    def post_list

    end

    def answer_list

    end

    def search(tagged: 'ruby', intitle: '', order: 'desc', sort: 'activity')
      Stackapp::Api.new(key, site: 'stackoverflow').search({tagged: tagged, order: order, sort: sort, filter: nil})
    end
  end
end
