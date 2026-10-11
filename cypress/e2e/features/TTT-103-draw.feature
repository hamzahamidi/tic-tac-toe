@uat
Feature: TTT-103: A full board without a line is a draw

  Scenario: Nine moves and no winner
    Given I open the game
    When I play the cells "0,1,2,4,3,5,7,6,8"
    Then the status reads "Draw"
    And the board is locked
