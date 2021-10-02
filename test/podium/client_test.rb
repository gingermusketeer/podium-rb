require "test_helper"

class PodiumClientTest < ActiveSupport::TestCase
  test "it allows for a podlet to be registered" do
    subject = Podium::Client.new
    subject.register("test_podlet", "http://pizza.local/test-podlet")

    url = subject.podlet_mapping.fetch("test_podlet")
    assert_equal("http://pizza.local/test-podlet", url)
  end
end
