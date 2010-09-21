require 'erubis'

class ChefConfigWriter
  
  def self.write_nodes_json(recipe_array, unique_id)
    last_app = "qips-node"
    
    if recipe_array.delete(last_app).eql?(last_app)
      recipe_array.push(last_app)
    end
    
    nodes_json_url = String.new
    if recipe_array
      eruby = Erubis::Eruby.new(File.read(CHEF_NODES_JSON_ERB))
      filename = 'nodes-' + unique_id.to_s + '.json'
      S3Helper.upload(CHEF_BUCKET, filename, eruby.result({:recipe_array => recipe_array}))
      nodes_json_url = 'http://' + CHEF_BUCKET + '.s3.amazonaws.com/' + filename
    end
    return nodes_json_url
  end
  
end