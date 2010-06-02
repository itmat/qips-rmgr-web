require 'rubygems'
require 'octopussy'

class Role < ActiveRecord::Base
    has_many :farms
    
    validates_presence_of :name
    
    serialize :recipes
    
    def self.get_avail_recipes()
      recipes = Array.new
      client = Octopussy::Client.new(:login => GITHUB_LOGIN, :token => GITHUB_API_TOKEN)
      tree = GITHUB_LOGIN + "/" + GITHUB_REPO
      hmash = client.tree(tree, GITHUB_COOKBOOK_SHA)

      hmash.each do | mash |
              recipes << mash.name if mash.mode == "040000"
      end
      
      return recipes
    end
end
