require "test_helper"

class PodiumManifestTest < ActiveSupport::TestCase
  test "provides access to the manifest data" do
    manifest_data = JSON.parse(File.read("test/fixtures/header_manifest.json"))
    subject = Podium::Manifest.new(manifest_data)

    assert_equal("header", subject.name)
    assert_equal("v1-yo", subject.version)
    assert_equal("/", subject.content)
    assert_equal("/fallback", subject.fallback)
    assert_equal([], subject.js)
    assert_equal([], subject.css)
    assert_equal({ "api" => "/api" }, subject.proxy)
  end
end
