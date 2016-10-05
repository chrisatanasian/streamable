require "minitest/autorun"
require "shoulda"
require "rr"
require "streamable"

class StreamableTest < Minitest::Test
  context "#initialize" do
    [[Streamable::Streamable.new.streamable, "without"],
     [Streamable::Streamable.new(username: "username", password: "password").streamable, "with"]].each do |streamable, with_or_without|
      context "streamable #{with_or_without} an account" do
        should "set builder request to be multipart" do
          assert_equal Faraday::Request::Multipart.inspect, streamable.builder.handlers[0].inspect
        end

        should "set builder adapter to be net_http" do
          assert_equal Faraday::Adapter::NetHttp.inspect, streamable.builder.handlers[1].inspect
        end

        should "set the url prefix to be Streamable's API URL" do
          assert_equal "https://api.streamable.com/", streamable.url_prefix.to_s
        end

        should "set the user agent header to be Faraday" do
          assert_match "Faraday", streamable.headers["User-Agent"]
        end

        if with_or_without == "without"
          should "not have an Authorization header" do
            assert_nil streamable.headers["Authorization"]
          end
        elsif with_or_without == "with"
          should "set the Authorization header" do
            assert_equal 30, streamable.headers["Authorization"].length
          end
        end
      end
    end
  end

  context "#upload_video" do
    should "make a POST request to the Streamable upload endpoint and return its body" do
      @streamable = Streamable::Streamable.new

      video_filename = "test_video.mp4"
      File.open(video_filename, "w").close
      file = Faraday::UploadIO.new(video_filename, "video/mp4")
      File.delete(video_filename)

      response = Faraday::Response.new(body: '{"status": 1, "shortcode": "qw12"}')

      mock(Faraday::UploadIO).new(video_filename, "video/mp4") { file }
      mock(@streamable.streamable).post("/upload", { file: file }) { response }

      video = @streamable.upload_video(video_filename)

      expected_response = { "status"           => 1,
                            "shortcode"        => "qw12",
                            "video_link"       => "http://streamable.com/qw12",
                            "video_embed_link" => "http://streamable.com/e/qw12" }
      assert_equal expected_response, video
    end
  end

  context "links" do
    setup do
      @streamable = Streamable::Streamable.new
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
