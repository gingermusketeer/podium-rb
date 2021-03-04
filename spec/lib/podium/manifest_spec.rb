require 'spec_helper'

RSpec.describe Podium::Manifest do
  let(:manifest_data) { JSON.parse(File.read("spec/fixtures/header_manifest.json")) }
  subject { described_class.new(manifest_data) }

  it "initializes correctly" do
    expect(subject.name).to eql("header")
    expect(subject.version).to eql("ed246eebf6e6036865e53d92fcfd7f82205c9655")
    expect(subject.content).to eql("/")
    expect(subject.fallback).to eql("/fallback")
    expect(subject.js).to eql([])
    expect(subject.css).to eql([])
    expect(subject.proxy).to eql({"api" => "/api"})
  end
end
