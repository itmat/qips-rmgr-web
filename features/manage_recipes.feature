Feature: Manage Recipes
	In order to make a management site for our AWS environment
	As an admin
	I want to manage recipes
	
	Background:
	Given the following recipes
		| name | description |
		| Sudo | Configures the sudo file for ITMAT admins |
		| Cron | Configures the crontab file for the root user |
		
	Scenario Outline: Restrict Farm Maintenance
	Given I am logged in as "<login>"
	When I go to <page>
	Then I should <action>
	
	Examples:
	 	| login | page | action |
		| admin | the list of recipes | see "Cron" |
		| guest | the list of recipes | not see "Cron" |
		|       | the list of recipes | not see "Cron" |
		
	Scenario: List Recipes
		Given I am logged in as "admin"
		When I go to the list of recipes
		Then I should see "Sudo"
		And I should see "Cron"
		
	Scenario: Create Recipe
		Given I am logged in as "admin"
		When I go to the new recipe page
		And I fill in "name" with "Logwatch"
		And I fill in "description" with "Removes the logwatch service from Cron"
		And I press "Create"
		And I go to the list of recipes
		And I should see "Logwatch"
		
	Scenario: Remove Recipe
		Given I am logged in as "admin"
		When I go to the list of recipes
		And I follow "Destroy"
		Then I should have 1 recipes
		
	Scenario: Edit Role
		Given I am logged in as "admin"
		When I go to the edit Sudo recipe page
		And I fill in "description" with "Configures the sudoers file for ITMAT admins"
		And I press "Update"
		And I go to the list of recipes
		And I should see "sudoers"
		