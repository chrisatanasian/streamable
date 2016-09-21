require "minitest/autorun"
require "shoulda"
require "rr"
require "streamable"

class StreamableTest < Minitest::Test
  context "#initialize" do
    setup do
      @streamable = Streamable::Streamable.new("username", "password")
      @builder_handlers = @streamable.streamable.builder.handlers
      @url_prefix       = @streamable.streamable.url_prefix.to_s
    end

    should "set builder request to be multipart" do
      assert_equal Faraday::Request::Multipart.inspect, @builder_handlers[0].inspect
    end

    should "set builder adapter to be net_http" do
      assert_equal Faraday::Adapter::NetHttp.inspect, @builder_handlers[1].inspect
    end

    should "set the url prefix to be Streamable's API URL" do
      assert_equal "https://api.streamable.com/", @url_prefix
    end
  end

  context "#upload_video" do
    should "make a POST request to the Streamable upload endpoint and return its body" do
      video_filename = "test_video.mp4"
      @streamable = Streamable::Streamable.new("username", "password")
      File.open(video_filename, "w").close

      file     = Faraday::UploadIO.new(video_filename, "video/mp4")
      response = Faraday::Response.new(body: "body")

      mock(Faraday::UploadIO).new(video_filename, "video/mp4") { file }
      mock(@streamable.streamable).post("/upload", { file: file }) { response }

      video = @streamable.upload_video(video_filename)
      assert_equal "body", video

      File.delete(video_filename)
    end
  end

  context "links" do
    setup do
      @streamable = Streamable::Streamable.new("username", "password")
    end

    context "#video_link" do
      should "return the video link given a shortcode" do
        assert_equal "http://streamable.com/shortcode", @streamable.video_link("shortcode")
      end
    end

    context "#video_embed_link" do
      should "return the video embed link given a shortcode" do
        assert_equal "http://streamable.com/e/shortcode", @streamable.video_embed_link("shortcode")
      end
    end
  end
end
