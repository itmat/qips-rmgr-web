@ec2
Feature: Manage Farms EC2
	In order to test ec2 with our app
	As an admin
	I want to test ec2 functionality on farms
	
	Background:
	Given the following role records
		| name | recipes | platform |
		| Compute | { "recipes": "TPP" } | aki |
		| Sequest | { "recipes": "Sequest" } | windows |
		| WWW | { "recipes": "WWW" } | aki |
		| DB | { "recipes": "DB" } | aki |

	And the following farm records
		| name | description | ami_id | min | max | role_id |
		| TEST | Test Node Server | ami-c544a5ac | 0 | 3 | 2 |
		| TEST_PERSIST | Test Persistent | ami-db57b6b2 | 0 | 19 | 2 |
		
	And the following instance records
		| instance_id | cpu | top | state | farm_id |
		| i-1234abcd | 0.00 | sequest-server | Busy | 1 |

	Scenario: Start N Instances from farm.  Also tests maximum limit. 
		#  Starts 4 instances of the first farm in ec2
		Given I am logged in as "admin"
		When I go to the view TEST farm page
		And I fill in "Num to Start" with "4"
		And press "Start"
		And I wait for 10 seconds
		# note that that the max is 3 instances, so there should only be 3 instances
		Then there should be 3 instances 
		
	Scenario:  Reconcile a farm
		# ok now that we started 2 instances in the previous scenario, 
		# we want to make sure that reconcile will add those two into a fresh cache
		Given I am logged in as "admin"
		When I view TEST farm
		And I press "Reconcile"
		# Add 2 that were previously started, delete the original dummy one. 3-1 = 2
		Then there should be 2 instances
		
	Scenario: Terminate Instances
		# this serves to test the terminate instance functionality
		Given I am logged in as "admin"
		When I view TEST farm
		And I press "Reconcile"
		Then there should be 2 instances
		When I go to the list of instances
		And I press "Terminate"
		Then I should be on the list of instances
		When I press "Terminate"
		Then there should be 0 instances
		
	Scenario: Test min limitation. Also confirms delete instance.  
		# lets reconcile a farm that has persistent instances
		Given I am logged in as "admin"
		When I view TEST_PERSIST farm
		And I press "Reconcile"
		And I wait for 10 seconds
		Then there should be 1 instance
		When I go to the list of instances
		And I press "Terminate"
		And I wait for 10 seconds
		Then there should be 0 instances
		

