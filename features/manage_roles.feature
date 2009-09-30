Feature: Manage Roles
	In order to make a management site for our AWS environment
	As an admin
	I want to manage roles
	
	Background:
	Given I have the following roles
		| name | recipes | platform |
		| Compute | { "recipes": "TPP" } | aki |
		| Sequest | { "recipes": "Sequest" } | windows |
		| WWW | { "recipes": "WWW" } | aki |
		| DB | { "recipes": "DB" } | aki |
	
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
		Given I am logged in "admin"
		When I go to the new role page
		And I fill in "name" with "Test"
		And I fill in "description" with "trans-proteomic"
		And I select "tpp::packages" from "recipes"
		And I press "Add Recipe"
		And I press "Submit"
		Then I should be on list of roles
		And I should see "Test"
		
	Scenario: Remove Role
		Given I am logged in "admin"
		When I go to the list of roles
		And I press "Destroy"
		Then I should have 1 role
		
	Scenario: Edit Role
		Given I am logged in
		When I go to the edit WWW role page
		And I select "r-project::packages" from "recipes"
		And I press "Add Recipe"
		And I press "Submit"
		Then I should be on list of roles
		And I should see "r-project::packages"
	