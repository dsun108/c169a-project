# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class MapController < ApplicationController
  # Render the map of the United States.
  def index
    @states = State.all
    @states_by_fips_code = @states.index_by(&:std_fips_code)
  end

  # Render the map of the counties of a specific state.
  def state
    @state = State.find_by(symbol: params[:state_symbol].upcase)
    handle_state_not_found && return if @state.nil?

    @county_details = @state.counties.index_by(&:std_fips_code)
  end

  # Render the map of a specific county.
  def county
    @state = State.find_by(symbol: params[:state_symbol].upcase)
    handle_state_not_found && return if @state.nil?

    @county = @state.counties.find_by(fips_code: params[:std_fips_code])
    handle_county_not_found && return if @county.nil?

    # Fetch representatives using the Google Civic Information API
    service = Google::Apis::CivicinfoV2::CivicInfoService.new
    service.key = Rails.application.credentials[:GOOGLE_API_KEY]
    result = service.representative_info_by_address(address: "#{@county.name}, #{@state.name}")
    @representatives = Representative.civic_api_to_representative_params(result)

    @county_details = @state.counties.index_by(&:fips_code)

    render 'map/county'
  end

  private

  def handle_state_not_found
    state_symbol = params[:state_symbol]
    redirect_to root_path, alert: "State '#{state_symbol}' not found."
  end

  def handle_county_not_found
    state_symbol = params[:state_symbol]
    std_fips_code = params[:std_fips_code]
    redirect_to root_path, alert: "County with code '#{std_fips_code}' not found for #{state_symbol}"
  end

  def get_requested_county(state_id)
    County.find_by(
      state:         state_id,
      std_fips_code: params[:std_fips_code].to_i(10)
    )
  end
end
