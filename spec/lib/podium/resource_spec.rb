require "spec_helper"

RSpec.describe Podium::Resource do
  let(:uri) { "http://pizza.localhost" }

  subject { described_class.new(uri) }

  describe "#fetch" do
    it "returns the content for the podlet" do
      stub_request(:get, "http://pizza.localhost/manifest.json")
        .to_return(body: File.read("spec/fixtures/header_manifest.json"))
      stub_request(:get, "http://pizza.localhost/")
        .to_return(body: "tomato and cheese")

      expect(subject.fetch).to eql("tomato and cheese")
    end
  end
end
