# frozen_string_literal: true

describe WebScrapper do
  describe 'hltb_request' do
    context 'when success' do
      it 'should return 200' do
        expect(WebScrapper.hltb_request('Fallout 2').status).to eq(200)
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Fallout 2')
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Main Story')
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Main + Extra')
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Completionis')
      end

      it 'using stub should return 200' do
        html = File.read('spec/fixtures/success_response.html')
        response = instance_double(Faraday::Response, body: html, status: 200)
        allow(WebScrapper).to receive(:hltb_request).with('Fallout 2').and_return(response)
        expect(WebScrapper.hltb_request('Fallout 2').status).to eq(200)
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Fallout 2')
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Main Story')
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Main + Extra')
        expect(WebScrapper.hltb_request('Fallout 2').body).to include('Completionis')
      end
    end

    context 'when fail' do
      it 'should return 200 and no results' do
        expect(WebScrapper.hltb_request('Fallout 11').status).to eq(200)
        expect(WebScrapper.hltb_request('Fallout 11').body).to include('No results for <strong>Fallout 11</strong> in <u>games</u>')
        expect(WebScrapper.hltb_request('Fallout 11').body).to_not include('Main Story')
        expect(WebScrapper.hltb_request('Fallout 11').body).to_not include('Main + Extra')
        expect(WebScrapper.hltb_request('Fallout 11').body).to_not include('Completionis')
      end

      it 'using stub should return 200 and no results' do
        html = File.read('spec/fixtures/fail_response.html')
        response = instance_double(Faraday::Response, body: html, status: 200)
        allow(WebScrapper).to receive(:hltb_request).with('Fallout 11').and_return(response)
        expect(WebScrapper.hltb_request('Fallout 11').status).to eq(200)
        expect(WebScrapper.hltb_request('Fallout 11').body).to include('No results for <strong>Fallout 11</strong> in <u>games</u>')
        expect(WebScrapper.hltb_request('Fallout 11').body).to_not include('Main Story')
        expect(WebScrapper.hltb_request('Fallout 11').body).to_not include('Main + Extra')
        expect(WebScrapper.hltb_request('Fallout 11').body).to_not include('Completionis')
      end
    end
  end

  describe 'hltb_parse' do
    context 'when success' do
      it 'should return a json' do
        html = File.read('spec/fixtures/success_response.html')
        json = File.read('spec/fixtures/fallout_2.json')
        response = instance_double(Faraday::Response, body: html, status: 200)
        expect(WebScrapper.hltb_parse(response)).to eq(json)
      end
    end

    context 'when fail' do
      it 'should return a message error' do
        html = File.read('spec/fixtures/fail_response.html')
        response = instance_double(Faraday::Response, body: html, status: 200)
        expect(WebScrapper.hltb_parse(response)).to include('Não é possivel parsear uma resposta vazia')
      end
    end
  end

  describe 'format_time' do
    context 'when time is 18½ Hours' do
      it 'should return 18:30:00' do
        expect(WebScrapper.format_time('18½ Hours')).to eq('18:30:00')
      end
    end

    context 'when time is 30 Mins' do
      it 'should return 00:30:00' do
        expect(WebScrapper.format_time('30 Mins')).to eq('00:30:00')
      end
    end

    context 'when no time is --' do
      it 'return --' do
        expect(WebScrapper.format_time('--')).to eq('--')
      end
    end

    context 'when time is 18 Hours' do
      it 'return --' do
        expect(WebScrapper.format_time('18 Hours')).to eq('18:00:00')
      end
    end
  end
end
