# frozen_string_literal: true

Given('an event named {string} does not exist') do |name|
  expect(Event.exists?(name: name)).to be_falsey
end

Given /the following events exist/ do |events_table|
  events_table.hashes.each do |event|
    state = State.find_by(symbol: event[:state_symbol])
    state = State.find_by(symbol: 'CA') if state.nil?
    county = County.find_by(state_id: state.id, fips_code: event[:fips_code])
    county = County.find_by(state_id: state.id, fips_code: event[:fips_code]) if county.nil?
    Event.create(
      name:        event[:name],
      description: event[:description],
      county:      county,
      start_time:  event[:start_time],
      end_time:    event[:end_time]
    )
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that event to the database here.
  end
end

Then /^I should (not )?see the following events: (.*)$/ do |no, events_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  events_list.split(', ').each do |event|
    if no
      expect(page).not_to have_content(event)
    else
      expect(page).to have_content(event)
    end
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body).to match(/#{e1}.*#{e2}/m)
end

Then /(.*) seed events should exist/ do |n_seeds|
  expect(Event.count).to eq n_seeds.to_i
end

When(/^I select the state "([^"]*)"$/) do |state|
  select(state, from: 'actionmap-event-state')
end

When(/^I select the county "([^"]*)"$/) do |county|
  expect(page).to have_select('actionmap-event-county', with_options: [county])
  select(county, from: 'actionmap-event-county')
end

When(/^I select (start|end) date "([^"]*)"$/) do |type, date_str|
  # Split the date_str into components based on spaces
  parts = date_str.split

  # Assign each part to the corresponding variable
  year = parts[0]
  month = parts[1]
  day = parts[2]
  hour = parts[3]
  minute = parts[4]

  # Select the year, month, day, hour, and minute in the form
  case type
  when 'start'
    select(year, from: 'event_start_time_1i')
    select(month, from: 'event_start_time_2i')
    select(day, from: 'event_start_time_3i')
    select(hour, from: 'event_start_time_4i')
    select(minute, from: 'event_start_time_5i')
  when 'end'
    select(year, from: 'event_end_time_1i')
    select(month, from: 'event_end_time_2i')
    select(day, from: 'event_end_time_3i')
    select(hour, from: 'event_end_time_4i')
    select(minute, from: 'event_end_time_5i')
  end
end

Given('California exists') do
  @cali = State.create(
    name:         'California',
    symbol:       'CA',
    fips_code:    '06',
    is_territory: 0,
    lat_min:      '-124.409591',
    lat_max:      '-114.131211',
    long_min:     '32.534156',
    long_max:     '-114.131211'
  )
end

Given('Alameda County exists') do
  @ala = @cali.counties.create!(
    fips_code:  '001',
    name:       'Alameda County',
    fips_class: 'H1'
  )
end
