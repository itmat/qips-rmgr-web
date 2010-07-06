@ec2
Feature: Manage Instances (requires ec2)
	In order to manage instances
	I want to view instance information, start & terminate instances, and change their states to manual
	
	Background:
	  Given a role: "role1" exists with name: "Compute", description: "Compute Node Role", platform: "aki", recipes: "qips-node-amqp"
	  And a role: "role2" exists with name: "Sequest", description: "Sequest Node Role", platform: "windows", recipes: "apache2"
	  And a farm: "farm1" exists with name: "TEST_32", description: "Test 32-bit node", ami_id: "ami-69987600", min: 0, max: 2, default_user_data: "", farm_type: "compute", key_pair_name: "admin-systems", security_groups: "compute-prod", ami_spec: "c1.medium", spot_price: 0.5, role: role "role1"
	  And a farm: "farm2" exists with name: "TEST_64", description: "Test 64-bit node", ami_id: "ami-6b987602", min: 1, max: 1, default_user_data: "", farm_type: "admin", key_pair_name: "admin-systems", security_groups: "www-prod", ami_spec: "m1.large", spot_price: 1.0, role: role "role2"
    And a instance exists with instance_id: "i-abcd1234", ruby_cpu_usage: 0.00, top_pid: "ruby", state: "idle", status_updated_at: "2010-05-10 23:08:43", farm: farm "farm1"  

  @selenium
	Scenario: Start N Instances from farm.  Also tests maximum limit. Also tests custom user data.
		#  Starts 4 instances of the first farm in ec2
		When I go to the view TEST_32 farm page
		# should have deleted the rouge test instances
		Then I should have 0 running instances with ami_id "ami-69987600"
		When I fill in "num_start" with "4"
		And I fill in "user_data" with "test again"
		And I press "Start"
		Then I should be on the view TEST_32 farm page
		When I run Delayed Jobs
		And I wait for 180 seconds
		# note that that the max is 2 instances, so there should only be 2 instances
		Then I should have 2 running instances with ami_id "ami-69987600"
		When I go to the list of instances
		Then I should see "launched"

	Scenario Outline: Restrict Instance List
	When I go to <page>
	Then I should <action>
	 
	Examples:
	 	| login | page | action |
		| admin | the list of instances | see "manual" |
		| guest | the list of instances | not see "manual" |				
		|       | the list of instances | not see "manual" |	

  Scenario: List instances
    When I go to the list of instances
    Then I should have 2 running instances with ami_id "ami-69987600"
    And I should see "manual"


  Scenario: Terminate Instances
    # this serves to test the terminate instance functionality
  	When I go to the list of instances
  	Then I should have 2 running instances with ami_id "ami-69987600"
  	When I follow "Terminate"
  	And I wait for 10 seconds
  	Then I should have 1 running instances with ami_id "ami-69987600"
  	And I should be on the list of instances
  	When I follow "Terminate"
  	And I wait for 10 seconds
  	Then I should have 0 running instances with ami_id "ami-69987600"

	Scenario: Test min limitation. Also confirms delete instance.  Also tests default user data
		# lets reconcile a farm that has persistent instances
		When I go to the view TEST_64 farm page
		Then I should have 0 running instances with ami_id "ami-eff51c86"
		When I press "Reconcile"
		And I run Delayed Jobs
		And I wait for 20 seconds
		Then I should have 1 running instance with ami_id "ami-6b987602"
		When I go to the list of instances
		Then I should see "launched"
		And I should see ""
		And I should see "ami-eff51c86"
		When I follow "Terminate"
		And I wait for 10 seconds
		Then I should have 0 running instances with ami_id "ami-6b987602"
    And I should see "shutdown"
    
  Scenario: Manual Override for instances
    Given I am logged in as "admin"
	  When I go to the view TEST_32 farm page
	  And I fill in "num_start" with "1"
	  And I press "Start"
	  Then I should be on the view TEST_32 farm page
	  When I run Delayed Jobs
	  And I wait for 20 seconds
	  Then I should have 1 running instances with ami_id "ami-69987600"
	  When I go to the list of instances
	  Then I should see "launched"
    When I follow "Manual Override"
    Then I should be on the list of instances
    And I should see "manual"
  	When I follow "Terminate"
  	And I wait for 10 seconds
  	Then I should have 0 running instances with ami_id "ami-69987600"
  	
  	
    
		
		