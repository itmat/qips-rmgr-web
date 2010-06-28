@ec2
Feature: Manage Instances (requires ec2)
	In order to manage instances
	As an admin
	I want to view instance information, start & terminate instances, and change their states to manual
	
	Background:
	Given the following role records
		| name |  platform | recipes |
		| Compute |  aki | qips-node-amqp |
		| Sequest |  windows | apache 2

	And the following farm records
		| name | description | ami_id | min | max | role_id | default_user_data | farm_type |
		| TEST | Test Node Server | ami-c544a5ac | 0 | 2 | 2 | test url | compute |
		| TEST_PERSIST | Test Persistent | ami-db57b6b2 | 1 | 1 | 2 | test url | admin |

	And the following instance records
		| instance_id | ruby_cpu_usage | top_pid | state | farm_id |
		| i-1234abcd | 0.00 | sequest-server | idle | 1 |

	Scenario: Start N Instances from farm.  Also tests maximum limit. Also tests custom user data.
		#  Starts 4 instances of the first farm in ec2
		Given I am logged in as "admin"
		When I go to the view TEST farm page
		# should have deleted the rouge test instances
		Then I should have 0 running instances with ami_id "ami-c544a5ac"
		And I should see "test url"
		When I fill in "num_start" with "4"
		And I fill in "user_data" with "custom url"
		And I press "Start"
		Then I should be on the view TEST farm page
		When I run Delayed Jobs
		And I wait for 20 seconds
		# note that that the max is 2 instances, so there should only be 2 instances
		Then I should have 2 running instances with ami_id "ami-c544a5ac"
		When I go to the list of instances
		Then I should see "launched"
		And I should see "custom url"

	Scenario Outline: Restrict Instance List
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	 
	Examples:
	 	| login | page | action |
		| admin | the list of instances | see "manual" |
		| guest | the list of instances | not see "manual" |				
		|       | the list of instances | not see "manual" |	

  Scenario: List instances
    Given I am logged in as "admin"
    When I go to the list of instances
    Then I should have 2 running instances with ami_id "ami-c544a5ac"
    And I should see "manual"


  Scenario: Terminate Instances
    # this serves to test the terminate instance functionality
  	Given I am logged in as "admin"
  	When I go to the list of instances
  	Then I should have 2 running instances with ami_id "ami-c544a5ac"
  	When I follow "Terminate"
  	And I wait for 10 seconds
  	Then I should have 1 running instances with ami_id "ami-c544a5ac"
  	And I should be on the list of instances
  	When I follow "Terminate"
  	And I wait for 10 seconds
  	Then I should have 0 running instances with ami_id "ami-c544a5ac"

	Scenario: Test min limitation. Also confirms delete instance.  Also tests default user data
		# lets reconcile a farm that has persistent instances
		Given I am logged in as "admin"
		When I go to the view TEST_PERSIST farm page
		Then I should have 0 running instances with ami_id "ami-db57b6b2"
		When I press "Reconcile"
		And I run Delayed Jobs
		And I wait for 20 seconds
		Then I should have 1 running instance with ami_id "ami-db57b6b2"
		When I go to the list of instances
		Then I should see "launched"
		And I should see "test url"
		And I should see "ami-db57b6b2"
		When I follow "Terminate"
		And I wait for 10 seconds
		Then I should have 0 running instances with ami_id "ami-db57b6b2"
    And I should see "shutdown"
    
  Scenario: Manual Override for instances
    Given I am logged in as "admin"
	  When I go to the view TEST farm page
	  And I fill in "num_start" with "1"
	  And I press "Start"
	  Then I should be on the view TEST farm page
	  When I run Delayed Jobs
	  And I wait for 20 seconds
	  Then I should have 1 running instances with ami_id "ami-c544a5ac"
	  When I go to the list of instances
	  Then I should see "launched"
    When I follow "Manual Override"
    Then I should be on the list of instances
    And I should see "manual"
  	When I follow "Terminate"
  	And I wait for 10 seconds
  	Then I should have 0 running instances with ami_id "ami-c544a5ac"
  	
  	
    
		
		