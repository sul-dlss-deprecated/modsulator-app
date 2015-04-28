require 'equivalent-xml'
require 'spec_helper'


describe Spreadsheet::ModsulatorAPI do
  def app
    @app ||= Spreadsheet::ModsulatorAPI
  end

  it "handles simple ping requests to /about" do
    get '/v1/about'
    expect(last_response).to be_ok
    expected_version = File.read(File.expand_path('../../VERSION', __FILE__))
    expect(last_response.body).to eq(String.new('modsulator-api version ' + expected_version))
  end

  it "handles simple ping requests to /modsulator_version" do
    get '/v1/modsulator_version'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/\d\.\d\.\d$/)
  end

  it "returns correct XML for a known spreadsheet" do
    post "/v1/modsulator", "file" => Rack::Test::UploadedFile.new(File.join(FIXTURES_DIR, 'crowdsourcing_bridget_1.xlsx'), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    returned_xml = Nokogiri::XML(last_response.body)
    expected_xml = Nokogiri::XML(File.read(File.join(FIXTURES_DIR, 'crowdsourcing_bridget_1.xml')))
    expect(EquivalentXml.equivalent?(returned_xml, expected_xml, opts = { :ignore_attr_values => 'datetime'})).to be_truthy
  end

  it "returns normalized XML" do
    post "/v1/modsulator", "file" => Rack::Test::UploadedFile.new(File.join(FIXTURES_DIR, 'crowdsourcing_bridget_1.xlsx'), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    returned_xml = Nokogiri::XML(last_response.body)
    expected_xml = Nokogiri::XML(File.read(File.join(FIXTURES_DIR, 'crowdsourcing_bridget_1.xml')))
    expect(EquivalentXml.equivalent?(returned_xml, expected_xml, opts = { :ignore_attr_values => 'datetime'})).to be_truthy
  end
end