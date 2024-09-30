Feature: Representative Profile 
  As a user 
  I want to see a representative's profile 
  So that I can view their contact address and political party and photo

  Scenario: Viewing a representative's profile
  Given a representative named "Kamala" exists 
  When I visit the representative profile page
  Then I should see "Kamala"
  And I should see "President" 
  And I should see "Democratic Party"
  And I should see "987 Coconut Tree driv"
  And I should see "CA"
  And I should see "Context of everything"
  And I should see "12345"
  And I should see the representative photo