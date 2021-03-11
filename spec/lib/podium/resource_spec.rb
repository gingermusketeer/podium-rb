require "spec_helper"

RSpec.describe Podium::Resource do
  let(:uri) { "http://pizza.localhost" }
  let(:manifest_str) { File.read("spec/fixtures/header_manifest.json") }
  let(:manifest_version) { JSON.parse(manifest_str).fetch("version") }

  subject { described_class.new(uri) }

  describe "#fetch" do
    it "returns the content for the podlet" do
      stub_request(:get, "http://pizza.localhost/manifest.json")
        .to_return(body: manifest_str)
      stub_request(:get, "http://pizza.localhost/")
        .to_return(body: "tomato and cheese", headers: { "podlet-version" => manifest_version })

      expect(subject.fetch).to eql("tomato and cheese")
    end

    it "raises an error if the podlet-version does not match the manifest version" do
      stub_request(:get, "http://pizza.localhost/manifest.json")
        .to_return(body: manifest_str)
      stub_request(:get, "http://pizza.localhost/")
        .to_return(body: "tomato and cheese", headers: { "podlet-version" => "not manifest version" })

      expect { subject.fetch }.to raise_error(Podium::Resource::VersionMismatchError)
    end
  end
end
