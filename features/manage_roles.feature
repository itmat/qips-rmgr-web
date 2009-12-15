Feature: Manage Roles
	In order to make a management site for our AWS environment
	As an admin
	I want to manage roles
	
	# NOTE: remove log/test/log before running tests!
	
	Background:
	Given the following recipe records
		| name | description |
		| tpp::packages | Configures the TPP program |
		| r-project::packages | Configures the R-Project program |
	
	And the following role records
		| name | platform |
		| Compute | aki |
		| Sequest | windows |
		| WWW | aki |
		| DB | aki |
	
	Scenario Outline: Restrict Role Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of roles | see "Compute" |
		| guest | the list of roles | not see "Compute" |
		|       | the list of roles | not see "Compute" |
		
	
	Scenario: List Roles
		Given I am logged in as "admin"
		When I go to the list of roles
		Then I should see "WWW"
		And I should see "DB"
		And I should see "Sequest"
		And I should see "Compute"
				
	Scenario: Create Role
		Given I am logged in as "admin"
		When I go to the new role page
		And I fill in "name" with "Test"
		And I fill in "description" with "trans-proteomic"
		And I select "tpp::packages" from "role_recipe_ids_"
		And I press "Submit"
		Then I should be on the list of roles
		And I should see "Test"
		
	Scenario: Remove Role
		Given I am logged in as "admin"
		When I go to the list of roles
		And I follow "Destroy"
		Then I should be on the list of roles
		Then I should have 3 roles
		
	Scenario: Edit Role
		Given I am logged in as "admin"
		When I go to the edit WWW role page
		And I select "r-project::packages" from "role_recipe_ids_"
		And I press "Submit"
		Then I should be on the list of roles
		And I should see "r-project::packages"
	