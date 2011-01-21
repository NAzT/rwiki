Feature: Create page

  Background:
    Given I go to the home page
    And I wait for ajax call complete

  @javascript
  Scenario: Create a new page
    When I right click the node with path "./folder"
    And I follow "Create page"
    Then I should see dialog box titled "Create page"

    When I fill in the input with "The new page" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new page"

    When I reload the page
    And I double click the node with path "./folder"
    Then I should see the node titled "The new page"

    When I click the node with path "./folder/The new page.txt"
    Then I should have the following open tabs:
      | The new page |
    And I should see page title "Rwiki ./folder/The new page.txt"
    And I should see "The new page" within "h1"

  @javascript
  Scenario: Create an existing page
    When I right click the node with path "./folder"
    And I follow "Create page"
    Then I should see dialog box titled "Create page"

    When I fill in the input with "test" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "test"

    When I reload the page
    And I double click the node with path "./folder"
    Then I should see the node titled "test"

    When I click the node with path "./folder/test.txt"
    Then I should see "Test 1" within "h3"

  @javascript
  Scenario: Create a folder
    When I right click the node with path "./folder"
    And I follow "Create folder"
    Then I should see dialog box titled "Create folder"

    When I fill in the input with "The new folder" within the dialog box
    And I press "OK" within the dialog box
    Then I should see the node titled "The new folder"

    When I reload the page
    And I double click the node with path "./folder"
    Then I should see the node titled "The new folder"
