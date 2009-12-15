Feature: Manage Instances
	In order to make a management site for our AWS environment
	As an admin
	I want to manage instances
	
	Background:
	Given I have the following farms
		| name | description | ami-id | min | max | farm_type |
		| TEST_PERSISTENT | Persistent Server | ami-db57b6b2 | 1 | 1 | admin |
		| Test_node | Sequest Server | ami-b96586d0 | 0 | 3 | compute |
	
	And I have the following instances
		| instance_id | farm_id | state | 
		| i-1234abcd | 2 | launched | 
		| i-abcd1234 | 2 | busy | 
	
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
		And I should see "TEST_PERSISTENT"
		And I should see "launched"
		And I should see "ami-b96586d0"
    And I should see "i-abcd1234"   
		And I should see "busy"
		
	Scenario: Terminate an Instance
		Given I am logged in
		When I go to the list of instances
		And I see "i-1234abcd"
		And I press "Terminate"
		And I press "OK"
		Then I should see "shutdown"
		
	Scenario: Update Instance State
		When I update instance 1 with state "Idle"
		And I go to the list of instances
		Then I should see "Idle"
		