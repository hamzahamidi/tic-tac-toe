@uat
Feature: TTT-105: The page shows which build it is

  Scenario: Environment banner matches the deployment target
    Given I open the game
    Then the environment banner shows the target environment

  Scenario: Build version is stamped into the page
    Given I open the game
    Then the build version is shown
