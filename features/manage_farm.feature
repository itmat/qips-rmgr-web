Feature: Manage Farms
	In order to make a management site for our AWS environment
	As an admin
	I want to manage farms
	
	Background:
	Given the following role records
		| name | recipes | platform |
		| Compute | { "recipes": "TPP" } | aki |
		| Sequest | { "recipes": "Sequest" } | windows |
		| WWW | { "recipes": "WWW" } | aki |
		| DB | { "recipes": "DB" } | aki |

	And the following farm records
		| name | description | ami_id | min | max | role_id |
		| WWW | Web Server | ami-99c021f0 | 1 | 1 | 3 |
		| MySQL | DB Server | ami-6b53b202 | 1 | 1 | 4 |
		| Sequest | Sequest Server | ami-db57b6b2 | 0 | 19 | 2 |
 		| Compute | Linux Compute Node | ami-820fefeb | 0 | 9 | 1 |
	
	And the following instance records
		| instance_id | cpu | top | state | farm_id |
		| i-1234abcd | 0.00 | sequest-server | Busy | 3 |

	Scenario Outline: Restrict Farm Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of farms | see "MySQL" |
		| guest | the list of farms | not see "MySQL" |
		|       | the list of farms | not see "MySQL" |
		
		
	Scenario: List Farms
		#Given I am logged in as "admin" with password "admin"
		Given I am logged in as "admin"
		And I go to the list of farms
		Then I should see "MySQL"
		And I should see "WWW"
		And I should see "Compute"
		And I should see "Sequest"

	Scenario: Create Farm
		Given I am logged in as "admin"
		When I go to the new farm page
		And I fill in "name" with "XYZ"
		And I fill in "description" with "Test Farm"
		And I fill in "ami" with "ami015db968"
		And I fill in "min" with "1"
		And I fill in "max" with "1"
		And I fill in "enabled" with "N"
		And I select "Compute" from "role"
		And I press "Submit"
		And I go to the list of farms
		Then I should see "XYZ"
		
	Scenario: Delete Farm
		Given I am logged in as "admin"
		When I go to the list of farms
		And I follow "destroy"
		Then I should be on list of farms
		And I should have 3 farms
		
	Scenario: Update Farm
		Given I am logged in as "admin"
		When I go to the edit MySQL farm page
		And I should see "MySQL"
		And I fill in "description" with "DB v2"
		And I fill in "ami" with "ami-2cf21645"
		And I fill in "min" with "2"
		And I fill in "max" with "2"
		And I select "DB" from "role"
		And I press "Submit"
		And I go to the list of farms
		Then I should see "DB v2"
		And I should not see "DB Server"
		
	Scenario: View Farm and its instances
		Given I am logged in as "admin"
		When I go to the view Sequest farm page
		Then I should see "Sequest Server"
		And I should see "Sequest"
		And I should see "ami-db57b6b2"
		And I should see "i-1234abcd"
		And I should see "0.0"
		And I should see "sequest-server"
		And I should see "Busy" 
		And I should see "running"
		
		