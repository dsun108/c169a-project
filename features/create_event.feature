Feature: Create Event

  As a user 
  I want to create an event
  So that I can keep track of the details for it later on

Background: I login and events have been added to database

  Given I am on the login page
  And California exists
  And Alameda County exists
  And I press "Sign in with Google"
  And  I am on the events page
  Then 0 seed events should exist


Scenario: No Foodieland event
  Given an event named "Foodieland" does not exist
  Then I should not see "Foodieland"

Scenario: I make the Foodieland event
  When I follow "Add New Event"
  Then I should see "New event"
  When I fill in "Name of the event..." with "Foodieland"
  And I fill in "Description of the event..." with "A food festival"
  And I select the state "California"
  And I select start date "2025 August 7 22 22"
  And I select end date "2026 September 8 23 23"
  And I press "Save"
  Then I should see "County must exist"