require "test_helper"

class PodiumResourceTest < ActiveSupport::TestCase
  URI = "http://pizza.localhost"
  MANIFEST_DATA = File.read("test/fixtures/header_manifest.json")
  MAINFEST_VERSION = "v1-yo"

  def setup
    stub_request(:get, "http://pizza.localhost/manifest.json")
      .to_return(body: MANIFEST_DATA)
  end

  def subject
    Podium::Resource.new(URI, :example)
  end

  test "getting the content for the podlet" do
    stub_request(:get, "http://pizza.localhost/")
      .to_return(body: "tomato and cheese", headers: { "podlet-version" => MAINFEST_VERSION })

    assert_equal "tomato and cheese", subject.fetch
  end

  test "error is raised when version does not match" do
    stub_request(:get, "http://pizza.localhost/")
      .to_return(body: "tomato and cheese", headers: { "podlet-version" => "not manifest version" })

    assert_raises(Podium::Resource::VersionMismatchError) do
      subject.fetch
    end
  end

  test "context header params are included" do
    stub_request(:get, "http://pizza.localhost/")
      .with(headers: { "podium-fish-type" => "salmon" })
      .to_return(body: "tomato and cheese", headers: { "podlet-version" => MAINFEST_VERSION })

    assert_equal("tomato and cheese", subject.fetch(fish_type: "salmon"))
  end

  test "ensures that the response encoding is UTF-8" do
    stub_request(:get, "http://pizza.localhost/")
      .to_return(body: "tomato and cheese".force_encoding("ASCII"), headers: { "podlet-version" => MAINFEST_VERSION })

    content = subject.fetch(fish_type: "salmon")
    assert_equal "UTF-8", content.encoding.to_s
    assert_equal "tomato and cheese", content
  end
end
