require 'rubygems'
require 'octopussy'
require 'uri'
require 'git'
require 'zlib'
require 'archive/tar/minitar'
include Archive::Tar

class Role < ActiveRecord::Base
    has_many :farms
    
    validates_presence_of :name
    
    serialize :recipes

    before_save :convert_recipe_to_array
    
    def self.get_avail_recipes()
      recipes = Array.new
      cookbooks_sha = String.new
      client = Octopussy::Client.new(:login => GITHUB_LOGIN, :token => GITHUB_API_TOKEN)
      tree = GITHUB_LOGIN + "/" + GITHUB_REPO
      latest_commit_sha = client.list_commits(tree).first.tree
      hmash = client.tree(tree, latest_commit_sha)

      hmash.each do | mash |
        if mash.name == "cookbooks"
          cookbooks_sha = mash.sha
        end
      end
      
      cb_hmash = client.tree(tree, cookbooks_sha)
          
      cb_hmash.each do | mash |
              recipes << mash.name if mash.mode == "040000"
      end

      return recipes
    end
    
    def self.package_and_post_recipes()
      uri = URI.parse(COOKBOOK_URL)
      cb_filename = uri.path.gsub('/','')
      cb_path = uri.path
      cb_name = cb_filename.split('.').first
      repos_path = TEMP_DIR + "/repos"
      curdir = Dir.getwd
      if (File.exists?(repos_path) && File.directory?(repos_path))
        FileUtils.rmtree(repos_path)
      	Dir.mkdir(repos_path)
      else
        Dir.mkdir(repos_path)
      end
      Dir.chdir(repos_path)
      Git.clone(GIT_COOKBOOK_URL, GIT_REPOS)
      Dir.chdir(repos_path + "/" + GIT_REPOS)
      tgz = Zlib::GzipWriter.new(File.open(TEMP_DIR + cb_path, 'wb'))
      Minitar.pack(cb_name, tgz)
      FileUtils.rmtree(repos_path)
      Dir.chdir(curdir)
      S3Helper.upload(CHEF_BUCKET, cb_filename, File.open(TEMP_DIR + cb_path))
      File.delete(TEMP_DIR + cb_path)
    end
    
    def convert_recipe_to_array
      
      unless self.recipes.class.to_s == 'Array'
        
        if self.recipes.blank?
          self.recipes = Array.new
        else
          self.recipes = [self.recipes.to_s]
        end
        
      end
      
      
    end
    
    
end
