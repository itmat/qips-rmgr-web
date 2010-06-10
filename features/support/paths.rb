module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
          '/'

    when /list of farms/
      farms_path

    when /list of instances/
      instances_path

    when /new farm page/
      new_farm_path

    when /edit (.+) farm page/
      edit_farm_path(Farm.find_by_name($1))

    when /view (.+) farm page/
      farm_path(Farm.find_by_name($1))

    when /list of roles/
      roles_path

    when /new role page/
      new_role_path

    when /edit (.+) role page/
      edit_role_path(Role.find_by_name($1))

    when /view (.+) role page/
      role_path(Role.find_by_name($1))

    when /list of recipes/
      recipes_path

    when /new recipe page/
      new_recipe_path

    when /edit (.+) recipe page/
      edit_recipe_path(Recipe.find_by_name($1))

    when /view (.+) recipe page/
      recipe_path(Recipe.find_by_name($1))

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
