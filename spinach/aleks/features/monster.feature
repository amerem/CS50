Feature: Opening website

Scenario: Open website
    Then I cleanup
    And I navigate to MONSTER.COM
    And I verify that I land on expected page
    Then I search for SQA 
    Then I cleanup







