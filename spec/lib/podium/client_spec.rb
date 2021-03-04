require "spec_helper"

RSpec.describe Podium::Client do
  describe "#register" do
    it "returns a resource for the URI" do
      resource = subject.register("http://pizza.local/test-podlet")

      expect(resource.uri).to eql("http://pizza.local/test-podlet")
    end
  end
end
