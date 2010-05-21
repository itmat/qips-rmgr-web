require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Role < ActiveRecord::Base
    has_many :farms
    has_and_belongs_to_many :recipes
    
    validates_presence_of :name
    
    def self.get_available_recipes(url)
      doc = Nokogiri::HTML(open(url))

      recipes = Array.new

      doc.xpath('//*[contains(concat( " ", @class, " " ), concat( " ", "content", " " ))]').each do |link|
      	if (link.content.match(/\//))
      		recipes << link.content.gsub(/\//, '').strip
      	end
      end

      return recipes
    end
end
