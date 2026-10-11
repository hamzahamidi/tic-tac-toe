@uat
Feature: TTT-102: O wins with a diagonal

  Scenario: O completes the anti-diagonal
    Given I open the game
    When I play the cells "0,2,1,4,8,6"
    Then the status reads "O wins"
    And the board is locked
