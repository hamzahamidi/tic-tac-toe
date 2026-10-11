@uat
Feature: TTT-104: Starting a new game clears the board

  Scenario: Reset mid-game
    Given I open the game
    When I play the cells "4,0"
    Then cell 4 shows "X"
    And the status reads "X to move"
    When I start a new game
    Then the board is empty
    And the status reads "X to move"
