require 'spec_helper'

describe Exbico do
  let(:exbico) { Exbico.new('fake_login', 'fake_password') }
  let(:empty_params) { { person: {}, document: {}, loan: {} } }
  let(:params) do
    {
      person: {
        lastname: 'Иванов',
        firstname: 'Иван',
        middlename: 'Иванович',
        datebirth: '18.12.1954'
      },
      document: {
        number: '666666',
        series: '4444',
        issuedate: '17.06.2004'
      },
      loan: {
        loantype: '1',
        loanamount: '50000',
        loanduration: '30'
      }
    }
  end
  let(:exbico_with_params) do
    exbico.params = params
    exbico
  end

  it 'has a version number' do
    expect(Exbico::VERSION).not_to be nil
  end

  context 'when object just created' do
    it 'has status "new"' do
      expect(exbico.status).to eq('new')
    end
  end

  describe '#params=' do
    context 'when params not hash' do
      it 'sets error' do
        exbico.params = 1
        expect(exbico.errors).to eq(['params should be hash'])
      end
    end

    context 'when params is invalid hash' do
      it 'sets error' do
        exbico.params = {}
        expect(exbico.errors).to eq(['params should have keys: ' \
                                      'person, document, loan'])
      end
    end

    context 'when params is valid' do
      it 'xml should have login' do
        exbico.params = empty_params
        expect(exbico.xml.css('login').text).to eq('fake_login')
      end

      it 'xml should have password' do
        exbico.params = empty_params
        expect(exbico.xml.css('password').text).to eq('fake_password')
      end

      context 'when params build invalid xml' do
        it 'sets xml errors' do
          exbico.params = empty_params
          expect(exbico.errors).to_not be_nil
        end
      end

      context 'when params has key test' do
        it 'xml should have istest key with value 1' do
          exbico.params = empty_params.merge(test: true)
          expect(exbico.xml.css('istest').text).to eq('1')
        end
      end

      context 'when params doesn\'t have key test' do
        it 'xml should have istest key with value 0' do
          exbico.params = empty_params
          expect(exbico.xml.css('istest').text).to eq('0')
        end
      end

      context 'when test option is true' do
        it 'xml should have istest key with value 1' do
          exbico.params = empty_params
          exbico.test = true
          expect(exbico.xml.css('istest').text).to eq('1')
        end
      end

      context 'when test option is true' do
        it 'xml should have istest key with value 0' do
          exbico.params = empty_params
          exbico.test = false
          expect(exbico.xml.css('istest').text).to eq('0')
        end
      end
    end
  end

  describe '#query' do
    context 'when params invalid' do
      it 'return false' do
        exbico.params = empty_params
        expect(exbico.query).to be_falsey
      end

      it 'has status "invalid"' do
        exbico.params = empty_params
        exbico.query
        expect(exbico.status).to eq('invalid')
      end
    end

    context 'when params valid' do
      it 'have a response' do
        VCR.use_cassette('test') do
          exbico_with_params.query
          expect(exbico_with_params.response).to_not be_nil
        end
      end

      context 'when response status is success' do
        it 'has status "done"' do
          VCR.use_cassette('test') do
            exbico_with_params.query
            expect(exbico_with_params.status).to eq('done')
          end
        end

        it 'return response' do
          VCR.use_cassette('test') do
            expect(exbico_with_params.query).to be(exbico_with_params.response)
          end
        end
      end

      context 'when response status is failure' do
        it 'has status "error"' do
          VCR.use_cassette('fail') do
            exbico_with_params.query
            expect(exbico_with_params.status).to eq('error')
          end
        end

        it 'return false' do
          VCR.use_cassette('fail') do
            expect(exbico_with_params.query).to be_falsey
          end
        end
      end
    end
  end

  describe '#valid?' do
    context 'when errors present' do
      it 'is false' do
        exbico.params = empty_params
        expect(exbico.valid?).to be_falsey
      end
    end

    context 'when errors is nil' do
      it 'is true' do
        expect(exbico_with_params.valid?).to be_truthy
      end
    end
  end

  describe '#test=' do
    it 'set true option' do
      exbico.test = false
      expect(exbico.test).to be_falsey
    end  

    context 'when got parameter not false' do
      it 'set option to true' do
        exbico.test = 'A'
        expect(exbico.test).to be_truthy
      end 
    end
  end  

  describe '#test' do
    it 'false as default' do
      expect(exbico.test).to be_falsey
    end
  end
end
