class Exbico
  # XML builder for query
  class XML
    def initialize(login, password, params, test)
      @login    = login
      @password = password
      @params   = params
      @test     = test
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
      @is_test = @params.key?(:test) || @test == true
    end

    def build_auth(xml)
      xml.login @login
      xml.password @password
    end

    def build_person(xml)
      xml.lastname lastname
      xml.firstname firstname
      xml.middlename middlename
      xml.datebirth datebirth
    end

    def build_document(xml)
      xml.type document_type
      xml.number number
      xml.series series
      xml.issuedate issuedate
    end

    def build_loan(xml)
      xml.loantype loantype
      xml.loanamount loanamount
      xml.loanduration loanduration
    end

    private

    def lastname
      lastname = @params[:person][:lastname]
      return lastname unless lastname.nil?
      return 'Иванов' if test?
    end

    def firstname
      firstname = @params[:person][:firstname]
      return firstname unless firstname.nil?
      return 'Иван' if test?
    end

    def middlename
      middlename = @params[:person][:middlename]
      return middlename unless middlename.nil?
      return 'Иванович' if test?
    end

    def datebirth
      datebirth = @params[:person][:datebirth]
      return datebirth unless datebirth.nil?
      return '18.12.1954' if test?
    end

    def document_type
      document_type = @params[:document][:type]
      return document_type unless document_type.nil?
      21
    end

    def number
      number = @params[:document][:number]
      return number unless number.nil?
      return '666666' if test?
    end

    def series
      series = @params[:document][:series]
      return series unless series.nil?
      return '4444' if test?
    end

    def issuedate
      issuedate = @params[:document][:issuedate]
      return issuedate unless issuedate.nil?
      return '17.06.2004' if test?
    end

    def loantype
      loantype = @params[:loan][:loantype]
      return loantype unless loantype.nil?
      return '1' if test?
    end

    def loanamount
      loanamount = @params[:loan][:loanamount]
      return loanamount unless loanamount.nil?
      return '50000' if test?
    end

    def loanduration
      loanduration = @params[:loan][:loanduration]
      return loanduration unless loanduration.nil?
      return '30' if test?
    end
  end
end
