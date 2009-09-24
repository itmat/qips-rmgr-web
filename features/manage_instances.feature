Feature: Manage Instances
	In order to make a management site for our AWS environment
	As an admin
	I want to manage instances
	
	Background:
	
	Given I start the following instances
		| ami_id | security_group | keypair | roles |
		| ami-820fefeb | compute-prod | admin-systems | TPP |
	
	Given the following user records
		| username | privledge |
		| admin | admin |
		| guest | restricted |
	
	Scenario Outline: Restrict Instance Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of instances | be on the list of instances |
		| guest | the list of instances | not be on the list of instances |
		| guest | the list of resources | see "You must be logged in as an administrator to access this page" |
				
	
	Scenario: List Instances
		Given I am logged in as "admin"
		When I go to the list of instances
		Then I should see "ami-820fefeb"
		
	Scenario: Terminate an Instance
		Given I am logged in as "admin"
		When I go to the list of instances
		And I see "i-1234abcd"
		And I check "action_i-1234abcd"
		And I press "Terminate"
		Then I should not see "i-1234abcd"
		
	Scenario: Start an Instance
		Given I am logged in as "admin"
		When I go to the list of instances
		And I select "ami1234abcd" from "new_ami_id"
		And I select "compute-prod" from "new_security_group"
		And I select "admin-systems" from "new_keypair"
		And I select "TPP" from "new_role"
		And I press "Start"
		Then I should have 2 instances
		