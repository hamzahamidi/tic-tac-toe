@uat
Feature: TTT-101: X wins with a full row

  Scenario: X completes the top row
    Given I open the game
    When I play the cells "0,3,1,4,2"
    Then the status reads "X wins"
    And the board is locked
