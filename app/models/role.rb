require 'rubygems'
require 'octopussy'
require 'git'
require 'zlib'
require 'archive/tar/minitar'
include Archive::Tar

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
    
    def self.package_and_post_recipes()
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
      tgz = Zlib::GzipWriter.new(File.open(TEMP_DIR + "/cookbooks.tgz", 'wb'))
      Minitar.pack('cookbooks', tgz)
      FileUtils.rmtree(repos_path)
      Dir.chdir(curdir)
      S3Helper.upload(CHEF_BUCKET, "cookbooks.tgz", File.open(TEMP_DIR + "/cookbooks.tgz"))
      File.delete(TEMP_DIR + "/cookbooks.tgz")
    end
end
