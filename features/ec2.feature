
Feature: Manage Farms EC2
	In order to test ec2 with our app
	As an admin
	I want to test ec2 functionality on farms
	
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
		| name | description | ami_id | min | max | role_id |
		| TEST | Test Node Server | ami-c544a5ac | 0 | 2 | 2 |
		| TEST_PERSIST | Test Persistent | ami-db57b6b2 | 1 | 1 | 2 |
		
	And the following instance records
		| instance_id | cpu | top | state | farm_id |
		| i-1234abcd | 0.00 | sequest-server | idle | 1 |

	Scenario: Start N Instances from farm.  Also tests maximum limit. 
		#  Starts 4 instances of the first farm in ec2
		Given I am logged in as "admin"
		When I go to the view TEST farm page
		# should have deleted the rouge test instances
		Then I should have 0 running instances with ami_id "ami-c544a5ac"
		When I fill in "num_start" with "4"
		And I press "Start"
		And I wait for 10 seconds
		# note that that the max is 2 instances, so there should only be 2 instances
		Then I should have 2 running instances with ami_id "ami-c544a5ac"
		
		
	Scenario: Terminate Instances
		# this serves to test the terminate instance functionality
		Given I am logged in as "admin"
		When I go to the view TEST farm page
		Then I should have 2 running instances with ami_id "ami-c544a5ac"
		When I go to the list of instances
		And I follow "Terminate"
		And I wait for 10 seconds
		Then I should have 1 running instances with ami_id "ami-c544a5ac"
		When I go to the list of instances
		And I follow "Terminate"
		And I wait for 10 seconds
		Then I should have 0 running instances with ami_id "ami-c544a5ac"
		
		@ec2
	Scenario: Test min limitation. Also confirms delete instance.  
		# lets reconcile a farm that has persistent instances
		Given I am logged in as "admin"
		When I go to the view TEST_PERSIST farm page
		Then I should have 0 running instances with ami_id "ami-db57b6b2"
		And I press "Reconcile"
		And I wait for 10 seconds
		Then I should have 1 running instance with ami_id "ami-db57b6b2"
		When I go to the list of instances
		And I follow "Terminate"
		And I wait for 10 seconds
		Then I should have 0 running instances with ami_id "ami-db57b6b2"
		
