Feature: Manage Roles
	In order to make a management site for our AWS environment
	As an admin
	I want to manage roles
	
	# NOTE: remove log/test.log before running tests!
	# This test assumes apache2 is the first selection on the recipe multi-select!

	Scenario: List Roles
	  Given a role exists with name: "Compute", description: "test compute description", platform: "aki", recipes: "test2"
  	And a role exists with name: "Sequest", description: "test sequest description", platform: "windows"
		When I go to the list of roles page
		Then I should see "Compute"
		And I should see "test compute description"
		And I should see "aki"
		And I should see "test2"
		And I should see "Sequest"
		And I should see "test sequest description"
		And I should see "windows"
				
	@selenium	
	Scenario: Create Role
		When I go to the new role page
		And I fill in "Name" with "Test"
		And I fill in "Description" with "qips-node-amqp test"
		And I select "aki" from "Platform"
		And I select index 0 from multiselect
		And I press "Submit"
		Then 1 roles should exist
		And I should be on the list of roles page
		And I should see "Test"
		And I should see "qips-node-amqp test"
		And I should see "apache2"
		And I should see "aki"
		
	Scenario: Create INVALID Role
		When I go to the new role page
		And I fill in "Name" with ""
		And I fill in "Description" with "qips-node-amqp test"
		And I select "aki" from "Platform"
		And I press "Submit"
		Then 0 roles should exist
		And I should see "Name can't be blank"
		
	Scenario: Remove Role
    Given a role exists with name: "Compute", description: "test compute description", platform: "aki", recipes: "test2"
		When I go to the list of roles page
		And I follow "Destroy"
		Then 0 roles should exist
		And I should be on the list of roles page
	
	@selenium
	Scenario: Edit Role
	  Given a role exists with name: "Compute", description: "test compute description", platform: "aki"
		When I go to the edit page for that role
		And I fill in "Name" with "Compute test"
		And I fill in "Description" with "test des"
		And I select "windows" from "Platform"
		And I select index 0 from multiselect
		And I press "Submit"
		Then I should be on the list of roles page
		And I should see "Compute test"
		And I should see "test des"
	  And I should see "windows"
	  And I should see "apache2"