Feature: Manage Farms
	In order to make a management site for our AWS environment
	As an admin
	I want to manage farms
	
	Background:
	
	Given I have the following farms
		| name | description | ami-id | min | max |
		| WWW | Web Server | ami-99c021f0 | 1 | 1 |
		| MySQL | DB Server | ami-6b53b202 | 1 | 1 |
		| Sequest | Sequest Server | ami-db57b6b2 | 0 | 19 |
		| Compute | Linux Compute Node | ami-db57b6b2 | 0 | 9 |
	
	Given I have the following instances in my farm
		| instance-id | cpu | top | state | farm-id |
		| i-1234abcd | 0.00 | sequest-server | Busy | 3 |
	
	Given the following user records
		| username | privledge |
		| admin | admin |
		| guest | restricted |
	
	Scenario Outline: Restrict Farm Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of farms | be on the list of farms |
		| guest | the list of farms | not be on the list of farms |
		| guest | the list of farms | see "You must be logged in as an administrator to access this page" |
		
		
	Scenario: List Farms
		Given I am logged in as "admin"
		When I go to the list of farms
		Then I should see "MySQL"
		And I should see "WWW"
		And I should see "Compute"
		And I should see "Sequest"

	Scenario: Create Farm
		Given I am logged in as "admin"
		When I go to the add farm page
		And I fill in name "XYZ"
		And I fill in description "Test Farm"
		And I fill in ami-id "ami-015db968"
		And I fill in min "1"
		And I fill in max "1"
		And I select "compute" from "role_id"
		And I press "Create Farm"
		Then I should be on list of farms
		And I should see "XYZ"
		
	Scenario: Delete Farm
		Given I am logged in  as "admin"
		When I go to the list of farms
		And I press "Delete Farm"
		Then I should be on list of farms
		And I should have 3 farms
		
	Scenario: Update Farm
		Given I am logged in as "admin"
		When I go to the update mysql farm page
		And I should see "MySQL"
		And I fill in description "DB Server v2"
		And I fill in ami-id "ami-2cf21645"
		And I fill in min "2"
		And I fill in max "2"
		And I select "DB" from "role_id"
		And I press "Update Farm"
		Then I should be on list of farms
		And I should see "DB Server v2"
		
	Scenario: View Farm
		Given I am logged in as "admin"
		When I go to the view sequest farm page
		Then I should see "Sequest Server"
		And I should see "Sequest"
		And I should see "ami-db57b6b2"
		And I should see "i-1234abcd"
		And I should see "0.00"
		And I should see "sequest-server"
		And I should see "Busy" 