# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.describe NewsItem, type: :model do
  subject(:news_item) do
    described_class.new(
      title:             'Breaking news',
      link:              'http://link.com',
      description:       'news news news',
      issue:             'Free Speech',
      representative_id: representative.id
    )
  end

  let(:representative) { Representative.create(name: 'kamala') }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(news_item).to be_valid
    end

    it 'is not valid without an issue' do
      news_item.issue = nil
      expect(news_item).not_to be_valid
    end

    it 'is not vaid with an invalid issue' do
      news_item.issue = 'random issue'
      expect(news_item).not_to be_valid
    end

    it 'is valid with a valid issue' do
      NewsItem::ISSUES.each do |issue|
        news_item.issue = issue
        expect(news_item).to be_valid
      end
    end
  end

  # describe 'searching Google News by keyword' do
  #  it 'calls Faraday gem with CS169 domain' do
  #    @representative = double('representative', name: 'Kamala')
  #    allow(Representative).to receive(:find_by).with(id: '1').and_return(@representative)
  #    expect(NewsItem).to receive(:find_in_google)
  #    NewsItem.find_in_google({
  #      'representative_id' => '1',
  #      'issue' => 'Climate Change'
  #    })
  #  end
  # end
end
