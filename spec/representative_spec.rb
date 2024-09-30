# frozen_string_literal: true

require 'rails_helper'

Official = Struct.new(:name, :address, :party, :photo_url)
Office = Struct.new(:name, :division_id, :official_indices)
RepInfo = Struct.new(:officials, :offices)

RSpec.describe Representative do
  # task 1.1
  describe 'converting civic api info to representative' do
    before do
      officials = [
        Official.new('Bob', [OpenStruct.new(line1: '123 Main St', city: 'Anytown', state: 'CA', zip: '12345')],
                     'Democratic Party', 'http://via.placeholder.com/150'),
        Official.new('Bobby', [OpenStruct.new(line1: '456 Elm St', city: 'Othertown', state: 'TX', zip: '67890')],
                     'Republican Party', 'http://via.placeholder.com/150'),
        Official.new('Bobbert', [OpenStruct.new(line1: '789 Oak St', city: 'Anycity', state: 'NY', zip: '10112')],
                     'Independent', 'http://via.placeholder.com/150')
      ]
      offices = [
        Office.new('President', '123', [0]),
        Office.new('Vice President', '123', [1]),
        Office.new('Secretary', '123', [2])
      ]

      @rep_info = RepInfo.new(officials, offices)
    end

    it 'creates a new representative when they do not exist' do
      expect { described_class.civic_api_to_representative_params(@rep_info) }.to change(described_class, :count).by(3)
    end

    it 'does not create a duplicate representative who already exists' do
      described_class.create!({ name: 'Bob', ocdid: '123', title: 'President' })
      expect { described_class.civic_api_to_representative_params(@rep_info) }.to change(described_class, :count).by(2)
    end
  end

  # task 1.2
  describe 'valid attributes' do
    let(:valid_pres) do
      {
        name:      'Kamala',
        ocdid:     'IDK',
        title:     'President',
        address:   '987 Coconut Tree drive',
        city:      'Context of everything',
        state:     'CA',
        zip:       '12345',
        party:     'Democratic Party',
        photo_url: 'http://idk.com/photo.jpg'

      }
    end

    it 'is valid after valid attributes' do
      pres = described_class.new(valid_pres)
      expect(pres).to be_valid
    end
  end
end
