Feature: Create a node
  As a developer
  I want to see the created node
  So that I can use it in my application

  Scenario: No nodes exist
    When I execute "CREATE (p:Person { name:"Keanu Reeves", born:1964 }) RETURN p"
    Then the output should contain "Node[1]{name:"Keanu Reeves",born:1964}"
    And the output should contain "1 row"

  @wip
  Scenario: A node exists
    Given I have executed "CREATE ()"
    When I execute "CREATE (p:Person { name:"Keanu Reeves", born:1964 }) RETURN p"
    Then the output should contain "Node[2]{name:"Keanu Reeves",born:1964}"
    And the output should contain "1 row"
