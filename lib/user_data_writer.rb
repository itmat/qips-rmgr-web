require 'erubis'

class UserDataWriter
  
  def self.write_user_data(chef_json_url, unique_id)
    eruby = Erubis::Eruby.new(File.read(USER_DATA_ERB))
    return eruby.result({:aws_cred_url => Farm.get_aws_cred_url(), :chef_json_url => chef_json_url})
  end
  
end