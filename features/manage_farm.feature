Feature: Manage Farms (CRUD ONLY)
	In order to manage farms
	As an admin
	I want to be able to create, update and delete farms
	
	Background:
	  Given a role: "role1" exists with name: "Compute", description: "Compute Node Role", platform: "aki", recipes: "qips-node"
    And a role: "role2" exists with name: "Sequest", description: "Sequest Node Role", platform: "windows", recipes: "apache2"
    And a farm: "farm1" exists with name: "TEST_32", description: "Test 32-bit node", ami_id: "ami-69987600", min: 0, max: 2, default_user_data: "test again", farm_type: "compute", key_pair_name: "admin-systems", security_groups: "compute-prod", ami_spec: "c1.medium", spot_price: 0.5, role: role "role1"
		
	Scenario: List Farms
		When I go to the list of farms page
		Then I should see "TEST_32"
		And I should see "Test 32-bit node"
		And I should see "ami-69987600"
		And I should see "admin-systems"
		And I should see "compute-prod"
		And I should see "Compute"
		And I should see "compute"

	Scenario: View Farm
	  When I go to the list of farms page
	  And I follow "Show"
	  Then I should see "TEST_32"
		And I should see "Test 32-bit node"
		And I should see "ami-69987600"
		And I should see "admin-systems"
		And I should see "compute-prod"
		And I should see "Compute"
		And I should see "compute"
		And I should see "Min: 0"
		And I should see "Max: 2"
		
	Scenario: Create Farm. Also tests destroy farm link.
		When I go to the new farm page
		And I fill in "Name" with "XYZ"
		And I fill in "Description" with "Test Farm"
		And I fill in "Ami" with "ami-6b987602"
		And I fill in "Min" with "1"
		And I fill in "Max" with "1"
		And I fill in "Security groups" with "default,sequest"
		And I fill in "Key pair name" with "admin-systems"
		And I fill in "Kernel" with "test kernel"
		And I select "Compute" from "Role"
		And I select "admin" from "Farm type"
		And I fill in "Default user data" with "blah blah"
		And I press "Submit"
	  Then 2 farms should exist
		And I should be on the list of farms page
		And I should see "XYZ"
		And I should see "Test Farm"
		And I should see "ami-6b987602"
		And I should see "default,sequest"
		And I should see "admin-systems"
		And I should see "Compute"
		When I follow "Destroy"
		Then 1 farms should exist
		And I should be on the list of farms page
		When I follow "Show"
		And I should see "XYZ"
		And I should see "Test Farm"
		And I should see "ami-6b987602"
		And I should see "default,sequest"
		And I should see "admin-systems"
		And I should see "Compute"
		And I should see "Kernel: test kernel"
		And I should see "Min: 1"
		And I should see "Max: 1"
		And I should see "admin"
		And I should see "blah blah"
		
	Scenario: Create INVALID Farm
		Given I am logged in as "admin"
		When I go to the new farm page
		And I fill in "Name" with ""
		And I fill in "Description" with "Test Farm"
		And I fill in "Ami" with ""
		And I fill in "Min" with ""
		And I fill in "Max" with ""
		And I fill in "Security groups" with ""
		And I fill in "Key pair name" with ""
		And I press "Submit"
  	Then I should not be on the list of farms page
  	And I should see "error"
    And I should see "Name can't be blank"
    And I should see "Ami can't be blank"
    And I should see "Min can't be blank"
    And I should see "Max can't be blank"
    And I should see "Key pair name can't be blank"
    And I should see "Security groups can't be blank"
	
	Scenario: Delete Farm
	  When I go to the list of farms page 
		And I follow "Destroy"
		Then I should be on the list of farms page
		And 0 farms should exist
		
	Scenario: Update Farm
	  When I go to the list of farms page
	  And I follow "Edit" 
	  And I fill in "Name" with "TEST3"
	  And I fill in "Description" with "DB v2"
		And I press "Submit" 
		Then I should be on the list of farms page
		And I should see "TEST3"
		And I should see "DB v2"
		And I should not see "Test Persistent"
		And I should not see "TEST_32"
		


