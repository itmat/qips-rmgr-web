Feature: Manage Instances
	In order to make a management site for our AWS environment
	As an admin
	I want to manage instances
	
	Background:
	Given I have the following farms
		| name | description | ami-id | min | max | enabled |
		| WWW | Web Server | ami-99c021f0 | 1 | 1 | Y |
		| MySQL | DB Server | ami-6b53b202 | 1 | 1 | Y | 
		| Sequest | Sequest Server | ami-db57b6b2 | 0 | 19 | Y | 
		| Compute | Linux Compute Node | ami-820fefeb | 0 | 9 | Y |
	
	And I have the following instances
		| instance_id | farm_id | cpu | top | state | security_group | keypair |
		| i-1234abcd | f-4 | 0.00 | xinteract | Busy | compute-prod | admin-systems |
		| i-1235abcd | 4-3 | 0.00 | sequest-master | Busy | sequest-node | admin-systems |
	
	And the following user records
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
		Given I am logged in
		When I go to the list of instances
		Then I should see "i-1234abcd"
		And I should see "f-4"
		And I should see "ami-1234abcd"
		And I should see "0.00"
		And I should see "xinteract"
		And I should see "Busy"
		And I should see "Compute"
		
	Scenario: Terminate an Instance
		Given I am logged in
		When I go to the list of instances
		And I see "i-1234abcd"
		And I check "action_i-1234abcd"
		And I press "Terminate"
		Then I should not see "i-1234abcd"
		
	Scenario: Start an Instance
		Given I am logged in
		When I go to the list of instances
		And I select "ami-1234abcd" from "new_ami_id"
		And I select "compute-prod" from "new_security_group"
		And I select "admin-systems" from "new_keypair"
		And I select "Compute" from "new_role"
		And I press "Start"
		Then I should have 2 instances
		
	Scenario: Update Instance State
		When I update instance 1 with state "Idle"
		And I go to the list of instances
		Then I should see "Idle"
		