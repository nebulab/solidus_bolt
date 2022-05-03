# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusBolt::Transactions::DetailService, :vcr, :bolt_configuration do
  subject(:api) { described_class.new(transaction_reference: reference) }

  let(:transaction) do
    SolidusBolt::Transactions::AuthorizeService.call(
      order: order, credit_card: credit_card_payload, create_bolt_account: false
    )
  end
  let(:credit_card_payload) do
    tokenize_credit_card(credit_card_number: '4111111111111004', cvv: '111').merge(
      expiration: (Time.current + 1.year).strftime('%Y-%m'),
      token_type: 'bolt'
    )
  end
  let(:order) { create(:order_with_line_items) }
  let(:reference) { transaction['transaction']['reference'] }

  describe '#call', vcr: true do
    it 'makes the API call' do
      response = api.call
      body = JSON.parse(response.body)

      expect(response.code).to eq 200
      expect(body['reference']).to eq reference
      expect(body['status']).to eq 'authorized'
    end
  end
end