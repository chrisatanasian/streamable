require "streamable/version"

module Streamable
  require "faraday"
  require "json"

  class Streamable
    attr_accessor :streamable

    STREAMABLE_URL = "http://streamable.com"

    def initialize(username: username, password: password)
      @streamable = Faraday.new(url: "https://api.streamable.com") do |builder|
        builder.request(:multipart)
        builder.adapter(:net_http)

        if username && password
          builder.basic_auth(username, password)
        end
      end
    end

    def upload_video(filename)
      params   = { file: Faraday::UploadIO.new(filename, "video/mp4") }
      response = @streamable.post("/upload", params)

      response_json = JSON.parse(response.body)
      shortcode     = response_json["shortcode"]

      response_json.merge("video_link"       => video_link(shortcode),
                          "video_embed_link" => video_embed_link(shortcode))
    end

    def video_link(shortcode)
      "#{STREAMABLE_URL}/#{shortcode}"
    end

    def video_embed_link(shortcode)
      "#{STREAMABLE_URL}/e/#{shortcode}"
    end
  end
end
