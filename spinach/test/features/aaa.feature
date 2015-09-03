Feature: Testing Garage API, ParkEdge and Parker2

Scenario: Posetive test. Testing Calculated Type
    Then I cleanup   
    Given I navigate to ParkEdge
    And I click on "Login" button
    Then I login
    And I select "Walgreens Lot" test lot
    Then I click "Edit This Facility" button
    And I find LOOKUP_CODE
    Then I find selected "Calculated Type"
    Then I find "Total Spaces" capacity
    And I find "Handicap" capacity
    Then I find "Electric" capacity
    And I find "Oversize" capacity
    Then I find "Monthly" capacity
    And I change "Student" capacity based on capacity calculations
    And I select "STUDENT" calculated type, if needed
    Then I click on "Save" button
    And I find Auth Key
    Then I select "Real Time" publishing data
    And I click on "Publish" button
    Then I find facility ID
    When I calculate lot total count
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
      
Scenario: Negative test. Facility calculated type missing    
    Then I cleanup   
    Given I navigate to ParkEdge
    And I click on "Login" button
    Then I login
    And I select "Walgreens Lot" test lot
    Then I click "Edit This Facility" button
    And I find LOOKUP_CODE
    When I deselect "Calculated Type"
    Then I click on "Save" button
    And I find Auth Key
    Then I select "Real Time" publishing data
    And I click on "Publish" button
    Then I find facility ID
    And I do counts CURL call
    When I do lot_totla CURL call I should have "Facility calculated type missing" response
    Then I cleanup 
    








