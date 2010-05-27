require 'erubis'

class ChefConfigWriter
  
  def self.write_nodes_json(recipe_array=nil, epoch_time)
    unless recipe_array.nil?
      @nodes_json_file = CHEF_NODES_JSON_DIR + "nodes-" + epoch_time + ".json"
      f_erb = File.open(CHEF_NODES_JSON_ERB)
      eruby = Erubis::Eruby.new(f_erb.read)
      f = File.open(@nodes_json_file, "w+")
      f.write(eruby.result({:recipe_array => recipe_array}))
      f.close
    end
  end
  
end