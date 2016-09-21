require "streamable/version"

module Streamable
  require "faraday"

  class Streamable
    attr_accessor :streamable

    STREAMABLE_URL = "http://streamable.com"

    def initialize(username, password)
      @streamable = Faraday.new(url: "https://api.streamable.com") do |builder|
        builder.request(:url_encoded)
        builder.adapter(:net_http)
        builder.basic_auth(username, password)
      end
    end

    def upload_video(filename)
      params   = { file: Faraday::UploadIO.new(filename, "video/mp4") }
      response = @streamable.post("/upload", params)

      response.body
    end

    def video_link(shortcode)
      "#{STREAMABLE_URL}/#{shortcode}"
    end

    def video_embed_link(shortcode)
      "#{STREAMABLE_URL}/e/#{shortcode}"
    end
  end
end
