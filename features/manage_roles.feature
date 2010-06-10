Feature: Manage Roles
	In order to make a management site for our AWS environment
	As an admin
	I want to manage roles
	
	# NOTE: remove log/test/log before running tests!
	
	Background:
	Given the following role records
		| name | platform | recipes |
		| Compute | aki | qips-node-amqp |
		| Sequest | windows | apache2 |
	

	Scenario: List Roles
		When I go to the list of roles
		Then I should see "Sequest"
		And I should see "Compute"
				
	@selenium			
	Scenario: Create Role
		When I go to the new role page
		And I fill in "Name" with "Test"
		And I fill in "Description" with "qips-node-amqp test"
		And I select "aki" from "Platform"
		And I select index "5" from multiselect
		And I wait for 3 seconds
		And I press "Submit"
		Then I should be on the list of roles
		And I should see "Test"
		
	Scenario: Create INVALID Role
		When I go to the new role page
		And I fill in "Name" with ""
		And I fill in "Description" with "trans-proteomic"
		And I press "Submit"
		Then I should not be on the list of roles
		And I should see "error"
		And I should see "Name can't be blank"
		
	Scenario: Remove Role
		When I go to the list of roles
		And I follow "Destroy"
		Then I should be on the list of roles
		Then I should have 1 roles
		
	Scenario: Edit Role
		When I go to the edit Compute role page
		And I press "Submit"
		Then I should be on the list of roles
	