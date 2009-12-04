class Role < ActiveRecord::Base
    has_many :farms
    has_and_belongs_to_many :recipes
    
    validates_presence_of :name
end
