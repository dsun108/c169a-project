# frozen_string_literal: true

Given('a representative named {string} exists') do |name|
  Representative.create!(
    name:      name,
    ocdid:     'IDK',
    title:     'President',
    address:   '987 Coconut Tree drive',
    city:      'Context of everything',
    state:     'CA',
    zip:       '12345',
    party:     'Democratic Party',
    photo_url: 'http://idk.com/photo.jpg'
  )
end

When('I visit the representative profile page') do
  pres = Representative.find_by(name: 'Kamala')
  visit representative_path(pres)
end
Then('I should see the representative photo') do
  expect(page).to have_css("img[src*='http://idk.com/photo.jpg']")
end
