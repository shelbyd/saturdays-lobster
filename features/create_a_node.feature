Feature: Create a node
  As a developer
  I want to create a node
  So that I can express my domain concepts

  Scenario: No nodes exist
    When I execute "CREATE (:Movie { title:"The Matrix",released:1997 })"
    Then the output should contain "Nodes created: 1"
    And the output should contain "Properties set: 2"
    And the output should contain "Labels added: 1"
