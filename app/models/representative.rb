# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    office_division_map = create_office_division_map(rep_info.offices)
    rep_info.officials.each_with_index.map do |official, index|
      create_or_update_representative(rep_info, official, index, office_division_map)
    end
  end

  def self.create_office_division_map(offices)
    office_division_map = {}
    offices.each do |office|
      office.official_indices.each do |index|
        office_division_map[index] = office.division_id
      end
    end
    office_division_map
  end

  def self.create_or_update_representative(rep_info, official, index, office_division_map)
    office_info  = office_func(rep_info.offices, index)
    address_info = address_func(official.address)
    county_fips  = extract_county_fips(office_division_map[index])

    rep = Representative.find_or_initialize_by(
      name:  official.name,
      ocdid: office_info[:ocdid],
      title: office_info[:title]
    )

    rep.update!(
      address:     address_info[:address],
      city:        address_info[:city],
      state:       address_info[:state],
      zip:         address_info[:zip],
      party:       official.party,
      photo_url:   official.photo_url,
      county_fips: county_fips
    )

    rep
  end

  def self.extract_county_fips(division_id)
    division_id&.split(':')&.last
  end

  def self.office_func(offices, index)
    ocdid_temp = ''
    title_temp = ''
    offices.each do |office|
      if office.official_indices.include? index
        title_temp = office.name
        ocdid_temp = office.division_id
      end
    end
    { title: title_temp, ocdid: ocdid_temp }
  end

  def self.address_func(address)
    address_temp = ''
    city_temp    = ''
    state_temp   = ''
    zip_temp     = ''
    if address
      addy = address.first
      address_temp = addy.line1
      city_temp    = addy.city
      state_temp   = addy.state
      zip_temp     = addy.zip
    end
    { address: address_temp, city: city_temp, state: state_temp, zip: zip_temp }
  end

  def self.get_by_county_fips(county_fips)
    where(county_fips: county_fips)
  end
end
