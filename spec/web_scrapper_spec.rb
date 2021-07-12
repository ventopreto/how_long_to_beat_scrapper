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
        response = instance_double(Faraday::Response, body: html, status: 200)
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
        response = instance_double(Faraday::Response, body: html, status: 200)
        allow(time_to_beat).to receive(:hltb_request).with('Fallout 11').and_return(response)
        expect(time_to_beat.hltb_request('Fallout 11').status).to eq(200)
        expect(time_to_beat.hltb_request('Fallout 11').body).to include('No results for <strong>Fallout 11</strong> in <u>games</u>')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Main Story')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Main + Extra')
        expect(time_to_beat.hltb_request('Fallout 11').body).to_not include('Completionis')
      end
    end
  end

  describe 'format_time' do
    let(:time_to_beat) { WebScrapper.new }
    context 'when time is 18½ Hours' do
      it 'should return 18:30:00' do
        expect(time_to_beat.format_time('18½ Hours')).to eq('18:30:00')
      end
    end

    context 'when time is 30 Mins' do
      it 'should return 00:30:00' do
        expect(time_to_beat.format_time('30 Mins')).to eq('00:30:00')
      end
    end

    context 'when no time is --' do
      it 'return --' do
        expect(time_to_beat.format_time('--')).to eq('--')
      end
    end

    context 'when time is 18 Hours' do
      it 'return --' do
        expect(time_to_beat.format_time('18 Hours')).to eq('18:00:00')
      end
    end
  end
end
