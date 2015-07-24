class Exbico
  # XML builder for query
  class XML
    def initialize(login, password, params)
      @login = login
      @password = password
      @params  = params
    end

    def build
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.credit_rating do
          xml.auth { build_auth(xml) }
          xml.person { build_person(xml) }
          xml.document { build_document(xml) }
          xml.loan { build_loan(xml) }
          xml.istest test? ? 1 : 0
        end
      end
      Nokogiri::XML(builder.to_xml)
    end

    private

    def test?
      @is_test unless @is_test.nil?
      @is_test = @params.key?(:test)
    end

    def build_auth(xml)
      xml.login @login
      xml.password @password
    end

    def build_person(xml)
      xml.lastname test? ? 'Иванов' : @params[:person][:lastname]
      xml.firstname test? ? 'Иван' : @params[:person][:firstname]
      xml.middlename test? ? 'Иванович' : @params[:person][:middlename]
      xml.datebirth test? ? '18.12.1954' : @params[:person][:datebirth]
    end

    def build_document(xml)
      xml.type 21
      xml.number test? ? '666666' : @params[:document][:number]
      xml.series test? ? '4444' : @params[:document][:series]
      xml.issuedate test? ? '17.06.2004' : @params[:document][:issuedate]
    end

    def build_loan(xml)
      xml.loantype test? ? '1' : @params[:loan][:loantype]
      xml.loanamount test? ? '50000' : @params[:loan][:loanamount]
      xml.loanduration test? ? '30' : @params[:loan][:loanduration]
    end
  end
end
