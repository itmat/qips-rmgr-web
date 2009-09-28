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
		
	Given the following user records
		| username | privledge |
		| admin | admin |
		| guest | restricted |
	
	Scenario Outline: Restrict Role Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of instances | be on the list of roles |
		| guest | the list of instances | not be on the list of roles |
		| guest | the list of resources | see "You must be logged in as an administrator to access this page" |
		
	
	Scenario: List Roles
		Given I am logged in as "admin"
		When I go to the list of roles
		Then I should see "WWW"
		And I should see "DB"
		And I should see "Sequest"
		And I should see "Compute"
				
	Scenario: Create Role
		Given I am logged in as "admin"
		When I go to the new roles
		And I fill in "name" with "Test"
		And I fill in "desc" with "trans-proteomic"
		And I select "tpp::packages" from "recipes"
		And I press "Add Recipe"
		And I press "Create Role"
		Then I should be on list of roles
		And I should see "Test"
		
	Scenario: Remove Role
		Given I am logged in as "admin"
		When I go to the list of roles
		And I press "Remove Role"
		Then I should have 1 role
		
	Scenario: Edit Role
		Given I am logged in as "admin"
		When I go to the list of roles
		And I press "Edit Role"
		Then I should be on edit role
		When I select "r-project::packages" from "recipes"
		And I press "Save"
		Then I should be on list of roles
		And I should see "r-project::packages"
		