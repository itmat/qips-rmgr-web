Feature: Manage Farms (CRUD ONLY)
	In order to manage farms
	As an admin
	I want to be able to create, update and delete farms
	
	Background:
	Given the following recipes
		| name | description |
		| Sudo | Configures the sudo file for ITMAT admins |
		| Cron | Configures the crontab file for the root user |
		
	And the following role records
		| name |  platform |
		| Compute |  aki |
		| Sequest |  windows |
		| WWW |  aki |
		| DB |  aki |

	And the following farm records
		| name | description | ami_id | min | max | role_id | farm_type |
		| TEST | Test Node Server | ami-c544a5ac | 0 | 2 | 2 | compute |
		| TEST_PERSIST | Test Persistent | ami-db57b6b2 | 1 | 1 | 2 | admin |

	Scenario Outline: Restrict Farm Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of farms | see "TEST" |
		| guest | the list of farms | not see "TEST" |
		|       | the list of farms | not see "TEST" |
		
		
	Scenario: List Farms
		#Given I am logged in as "admin" with password "admin"
		Given I am logged in as "admin"
		And I go to the list of farms
		Then I should see "TEST"
		And I should see "TEST_PERSIST"

	Scenario: View Farm
		Given I am logged in as "admin"
		When I go to the view TEST_PERSIST farm page
		Then I should see "Test Persistent"
		And I should see "ami-db57b6b2"
    And I should see "admin-systems"
    And I should see "default,sequest"
    And I should see "admin"

	Scenario: Create Farm
		Given I am logged in as "admin"
		When I go to the new farm page
		And I fill in "name" with "XYZ"
		And I fill in "description" with "Test Farm"
		And I fill in "ami" with "ami015db968"
		And I fill in "min" with "1"
		And I fill in "max" with "1"
		And I fill in "Security groups" with "default,sequest"
		And I fill in "Key pair name" with "admin-systems"
		And I select "Compute" from "role"
		And I press "Submit"
		Then I should be on the list of farms
		And I should see "XYZ"
		
	Scenario: Create INVALID Farm
		Given I am logged in as "admin"
		When I go to the new farm page
		And I fill in "name" with ""
		And I fill in "description" with "Test Farm"
		And I fill in "ami" with "ami12345678"
		And I fill in "min" with "1"
		And I fill in "max" with "1"
		And I select "Compute" from "role"
  	And I press "Submit"
  	Then I should not be on the list of farms
  	And I should see "error"
    And I should see "Name can't be blank"
	
	Scenario: Delete Farm
		Given I am logged in as "admin"
		When I go to the list of farms
		And I follow "destroy"
		Then I should be on list of farms
		And I should have 1 farms
		
	Scenario: Update Farm
		Given I am logged in as "admin"
		When I go to the edit TEST_PERSIST farm page
		And I should see "TEST_PERSIST"
		And I fill in "description" with "DB v2"
		And I fill in "ami" with "ami-12345678"
		And I fill in "min" with "2"
		And I fill in "max" with "2"
		And I select "DB" from "role"
		And I press "Submit" 
		Then I should be on the list of farms
		And I should see "DB v2"
		And I should not see "Test Persistent"
		


