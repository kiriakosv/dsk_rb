# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'

RSpec.describe 'DskRb::Client' do
  let(:client) { DskRb::Client.new(username: 'username', password: 'password', environment: 'uat') }

  describe 'initialization' do
    subject { client }

    it 'accepts username, password and environment as arguments' do
      expect(subject).to be_a(DskRb::Client)

      expect(subject.instance_variable_get(:@username)).to eq('username')
      expect(subject.instance_variable_get(:@password)).to eq('password')
      expect(subject.instance_variable_get(:@environment)).to eq(:uat)
    end

    it 'correctly sets base_url based on environment' do
      expect(subject.instance_variable_get(:@base_url)).to eq('https://uat.dskbank.bg')
    end

    it 'validates that environment is :uat' do
      expect { DskRb::Client.new(username: 'username', password: 'password', environment: 'invalid') }.to raise_error(ArgumentError)
    end
  end

  describe '#payment_registration' do
    subject { client.payment_registration(params) }

    let(:params) do
      {
        amount: 100,
        return_url: 'https://example.com/return',
        description: 'Test payment',
        order_number: '123'
      }
    end

    before do
      stub_request(:post, 'https://uat.dskbank.bg/payment/rest/register.do').
        with(
          body: {
            'amount' => '100',
            'description' => 'Test payment',
            'orderNumber' => '123',
            'password' => 'password',
            'returnUrl' => 'https://example.com/return',
            'userName' => 'username'
          },
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/x-www-form-urlencoded',
            'User-Agent' => 'Faraday v2.12.2'
          }
        ).to_return(
          status: 200,
          body: {
            orderId: '351435f6-d791-74a1-91d7-a4a62eadc91b',
            formUrl: 'https://form.url'
          }.to_json
      )
    end

    context 'when request is successful' do
      it 'returns parsed response body' do
        expect(subject).to eq(
          'orderId' => '351435f6-d791-74a1-91d7-a4a62eadc91b',
          'formUrl' => 'https://form.url'
        )
      end
    end

    context 'when request is unsuccessful' do
      before do
        stub_request(:post, 'https://uat.dskbank.bg/payment/rest/register.do').
          to_return(
            status: 401,
            body: 'Internal Server Error'
        )
      end

      it 'raises an error' do
        expect { subject }.to raise_error(Faraday::UnauthorizedError)
      end
    end
  end
end
