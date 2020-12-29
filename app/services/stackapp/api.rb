module Stackapp
  class Api
    API_VERSION = 2.2

    attr_reader :quota, :quota_used
    attr_accessor :params

    def initialize(key = "8qwQOrMcRd*4tfCBkiGJEA((", filter: '!*1_).BnZb8pdvWlZpJYNyauMekouxK9-RzUNUrwiB', log_api_raw: false, log_api_json: false, log_meta: true, **params)
      @key = key
      @params = filter.to_s.size > 0 ? params.merge({ filter: filter }) : params
      @quota = nil
      @quota_used = 0
      @backoff = Time.now
      @logger_raw = Logger.new "api_raw.log"
      @logger_json = Logger.new "api_json.log"
      @logger = Logger.new "se-api.log"
      @logger_raw.level = Logger::Severity::UNKNOWN unless log_api_raw
      @logger_json.level = Logger::Severity::UNKNOWN unless log_api_json
      @logger.level = Logger::Severity::UNKNOWN unless log_meta
    end

    def search(**params)
      json("search", **params)
    end

    private

    def objectify(type, ids = "", uri_prefix: nil, uri_suffix: nil, uri: nil, delimiter: ";", **params)
      return if ids == ""

      uri_prefix = "#{type.to_s.split('::').last.downcase}s" if uri_prefix.nil?
      json([uri_prefix, Array(ids).join(delimiter), uri_suffix].reject(&:nil?).join("/"), **params).map do |i|
        type.new(i)
      end
    end

    def json(uri, **params)
      params = @params.merge(params)
      # byebug
      throw "No site specified" if params[:site].nil?
      backoff_for = @backoff - Time.now
      backoff_for = 0 if backoff_for <= 0
      if backoff_for > 0
        @logger.warn "Backing off for #{backoff_for}"
        sleep backoff_for + 2
        @logger.warn "Finished backing off!"
      end
      params = @params.merge(params).merge({ key: @key }).reject{|k, v| v.nil?}.map { |k, v| "#{k}=#{v}" }.join("&")
      puts "Posting to https://api.stackexchange.com/#{API_VERSION}/#{uri}?#{params}"
      @logger.info "Posting to https://api.stackexchange.com/#{API_VERSION}/#{uri}?#{params}"
      begin
        resp_raw = Net::HTTP.get_response(URI("https://api.stackexchange.com/#{API_VERSION}/#{uri}?#{params}")).body
      rescue Net::OpenTimeout, SocketError => e
        @logger.warn "Got timeout on API request (#{e}). Retrying..."
        puts "Got timeout on API request (#{e}). Retrying..."
        sleep 0.3
        retry
      end
      @logger_raw.info "https://api.stackexchange.com/#{API_VERSION}/#{uri}?#{params} => #{resp_raw}"
      resp = JSON.parse(resp_raw)
      @backoff = Time.now + resp["backoff"].to_i
      @logger_json.info "https://api.stackexchange.com/#{API_VERSION}/#{uri}?#{params} => #{resp}"
      @quota = resp["quota_remaining"]
      @quota_used += 1
      Array(resp["items"])
    end
  end
end
