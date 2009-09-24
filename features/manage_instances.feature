Feature: Manage Instances
	In order to make a management site for our AWS environment
	As an admin
	I want to manage instances
	
	Background:
	Given the following user records
	| username | privledge |
	| admin | admin |
	
	Scenario Outline: Restrict Instance Maintenance
	Given I am logged in as "<login>" with password "secret"
	When I go to <page>
	Then I should see <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of instances | be on the list of instances |
		| guest | the list of instances | not be on the list of instances |
		| guest | the list of resources | see "You must be logged in as an administrator to access this page" |
		
	
	Scenario: List Instances
		Given I have instances named www, db
		When I go to the list of instances
		Then I should see "www"
		And I should see "db"
		
	Scenario: Terminate an Instance
		Given I am logged in as "admin"
		And there are 1 instances left
		When I go to the list of instances
		And I follow "Terminate"
		Then I should have 0 instances left
		
	Scenario: Create an Instance
		Given I am logged in as "admin"
		When I go to the list of instances
		