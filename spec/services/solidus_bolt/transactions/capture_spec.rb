# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusBolt::Transactions::Capture, :vcr, :bolt_configuration do
  subject(:api) { described_class.new(transaction_reference: reference, amount: amount, currency: currency) }

  let(:transaction) do
    SolidusBolt::Transactions::Authorize.call(
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
  let(:amount) { 10 }
  let(:currency) { 'USD' }

  describe '#call', vcr: true do
    it 'returns status 200' do
      expect(api.call.code).to eq 200
    end

    it 'receives the correct response' do
      response = JSON.parse(api.call.body)
      expect(response['reference']).to eq(reference)
    end

    it 'receives the correct capture status' do
      response = JSON.parse(api.call.body)
      expect(response['capture']['status']).to eq 'succeeded'
    end
  end
end
