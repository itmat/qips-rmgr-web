Feature: Manage Roles
	In order to make a management site for our AWS environment
	As an admin
	I want to manage roles
	
	Background:
	
	Given I start the following instances
		| ami_id | security_group | keypair | roles |
		| ami-820fefeb | compute-prod | admin-systems | TPP |
	
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
		| admin | the list of instances | be on the list of instances |
		| guest | the list of instances | not be on the list of instances |
		| guest | the list of resources | see "You must be logged in as an administrator to access this page" |