require 'exbico/version'
require 'exbico/xml'
require 'httparty'
require 'nokogiri'

# Ruby library for API http://exbico.ru/
class Exbico
  require 'nokogiri'
  include HTTParty
  base_uri 'http://api.exbico.ru/se/crm_v3_1'
  attr_accessor :login, :params
  attr_writer :password
  attr_reader :errors, :response, :xml, :status

  def initialize(login, password)
    @login = login
    @password = password
    @status = 'new'
  end

  def valid?
    @errors.nil?
  end

  def query
    @response = nil
    if valid?
      @response = self.class.post('/', body: @xml.to_s)
      if @response.key?('result') && @response['result']['status'] == '1'
        @status = 'done'
        @response
      else
        @status = 'error'
        false
      end
    else
      @status = 'invalid'
      false
    end
  end

  def params=(hash)
    @errors = nil
    @params = hash
    validate_params
  end

  private

  def validate_params
    if !@params.is_a?(Hash)
      @errors = ['params should be hash']
    elsif !hash_valid?
      @errors = ['params should have keys: person, document, loan']
    else
      build_xml
    end
    @errors.nil?
  end

  def hash_valid?
    [:person, :document, :loan].all? do |k|
      @params.key?(k) && @params[k].is_a?(Hash)
    end
  end

  def build_xml
    @xml = Exbico::XML.new(@login, @password, @params).build
    validate_xml
  end

  def validate_xml
    xsd_file = File.read(File.expand_path('../request_schema.xsd', __FILE__))
    xsd = Nokogiri::XML::Schema(xsd_file)
    @errors = ['xml is invalid'] unless xsd.valid?(@xml)
    xsd.validate(@xml).each do |error|
      @errors << error.message
    end
  end
end
