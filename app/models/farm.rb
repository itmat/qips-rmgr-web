class Farm < ActiveRecord::Base
  has_many :instances
  belongs_to :role

  # start N instances from farm. mind upper limits
  def start(num_start=1)
    #TODO
    # based on upper limits need to insert logic here to figure out how many we need to start
    
    #finally start appropriate amount of instances. and return that amount
    
  end


  #reconcile with ec2.  start / stop based on min / max. clean up, etc. 
  def reconcile
    #TODO
    
    #First sync, then make sure this farm is operating withing limits.  
    
    
    # shutdown what we can 
    
    
  end


end
