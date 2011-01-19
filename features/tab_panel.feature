Feature: Tab Panel

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Close a tab
    When I click the node with path "./home.txt"
    And I click the node with path "./test.txt"
    And I wait for ajax call complete

    Then I should have the following open tabs:
      | home |
      | test |
    And the node with path "./test.txt" should be selected

    When I close tab for page "./test.txt"
    Then I should have the following open tabs:
      | home |
    And the node with path "./test.txt" should be selected

    When I close tab for page "./home.txt"
    Then I should have no open tabs

  @javascript
  Scenario: Switching a tabs
    When I click the node with path "./home.txt"
    And I click the node with path "./test.txt"
    And I wait for ajax call complete
    Then I should see "This is a test"

    When I click tab for page "./home.txt"
    And I wait for ajax call complete
    Then I should see "Sample page" within "h1"
    And the node with path "./home.txt" should be selected
    And the node with path "./test.txt" should not be selected

    When I click tab for page "./test.txt"
    And I wait for ajax call complete
    Then I should see "This is a test"
    And the node with path "./test.txt" should be selected
    And the node with path "./home.txt" should not be selected

  @javascript
  Scenario: Close tab from context menu

  @javascript
  Scenario: Close other tabs from context menu

  @javascript
  Scenario: Close all tabs from context menu
