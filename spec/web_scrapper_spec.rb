# frozen_string_literal: true

require 'spec_helper'

describe WebScrapper do
  let(:time_to_beat) { WebScrapper.new }
  describe 'hltb_request' do
    context 'when success' do
      it 'should return 200' do
        expect(time_to_beat.hltb_request('Fallout 2').status).to eq(200)
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Fallout 2')
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Main Story')
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Main + Extra')
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Completionis')
      end

      it 'using stub should return 200' do
        html = File.read('spec/fixtures/success_response.html')
        response = double('faraday_response', body: html, status: 200)
        allow(time_to_beat).to receive(:hltb_request).with('Fallout 2').and_return(response)
        expect(time_to_beat.hltb_request('Fallout 2').status).to eq(200)
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Fallout 2')
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Main Story')
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Main + Extra')
        expect(time_to_beat.hltb_request('Fallout 2').body).to include('Completionis')
      end
    end

    context 'when fail' do
      it 'should return 200 and no results' do
        expect(time_to_beat.hltb_request('Fallout 11').status).to eq(200)
        expect(time_to_beat.hltb_request('Fallout 11').body).to include('No results for <strong>Fallout 11</strong> in <u>games</u>')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Main Story')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Main + Extra')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Completionis')
      end

      it 'using stub should return 200 and no results' do
        html = File.read('spec/fixtures/fail_response.html')
        response = double('faraday_response', body: html, status: 400)
        allow(time_to_beat).to receive(:hltb_request).with('Fallout 11').and_return(response)
        expect(time_to_beat.hltb_request('Fallout 11').status).to eq(400)
        expect(time_to_beat.hltb_request('Fallout 11').body).to include('No results for <strong>Fallout 11</strong> in <u>games</u>')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Main Story')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Main + Extra')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Completionis')
      end
    end
  end
end
