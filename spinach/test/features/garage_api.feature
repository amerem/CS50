Feature: Testing Garage API, ParkEdge and Parker2 JSON

Scenario: Posetive test. Testing Calculated Type
    Then I cleanup   
    Given I navigate to ParkEdge
    And I click on "Login" button
    Then I login
    And I select test lot
    Then I click "Edit This Facility" button
    And I find LOOKUP_CODE
    Then I find selected "Calculated Type"
    And I memorize original "Calculated Type"
    Then I find "Total Spaces" capacity
    And I find "Handicap" capacity
    When I memorize original "Handicap" capacity
    Then I find "Electric" capacity
    When I memorize original "Electric" capacity
    And I find "Oversize" capacity
    When I memorize original "Oversize" capacity
    Then I find "Monthly" capacity
    When I memorize original "Monthly" capacity
    And I find "Student" capacity
    When I memorize original "Student" capacity
    And I change "Student" capacity based on capacity calculations
    And I select "STUDENT" calculated type, if needed
    Then I click on "Save" button
    And I click on "Availability" tab on left navigation
    Then I verify that "Garage count" shows up
    And I find Auth Key
    Then I select "Real Time" publishing data
    And I click on "Publish" button
    Then I find facility ID
    When I randomize calculated type availability
    And I do counts CURL call
    Then I do lot_totla CURL call
    Then I verify that JSON has expected number of calculated spaces
    And I verify that Parker2 JSON has expected number of calculated spaces
    And I do counts CURL call
    Then I do lot_totla CURL call
    Then I verify that JSON has expected number of calculated spaces
    And I verify that Parker2 JSON has expected number of calculated spaces
    And I do counts CURL call
    Then I do lot_totla CURL call
    Then I verify that JSON has expected number of calculated spaces
    And I verify that Parker2 JSON has expected number of calculated spaces
    Then I cleanup





