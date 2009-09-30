class Farm < ActiveRecord::Base
  has_many :instances
  belongs_to :role

end
