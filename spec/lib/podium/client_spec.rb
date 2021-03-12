require "spec_helper"

RSpec.describe Podium::Client do
  describe "#register" do
    it "adds the podlet to the registry" do
      subject.register("test_podlet", "http://pizza.local/test-podlet")

      url = subject.podlet_mapping.fetch("test_podlet")
      expect(url).to eql("http://pizza.local/test-podlet")
    end
  end
end
