

class IpAccessWriter
  
    @hosts_filename = HOSTS_FILENAME  ||= '/etc/hosts.qips'
  
  def initialize(h_file=nil)
  
    @hosts_filename = h_file ||= HOSTS_FILENAME
    
  end 
  
  
  
  def self.write_access_file(ip_array=nil)
    
    unless ip_array.nil?
      f = File.open(@hosts_filename, "w+") 
      
      f.write("######\n")
      f.write("## HOSTS ALLOW FOR QIPS\n")
      f.write("######\n")
      
      ip_array.each do |ip|
        
        f.write("ALL:#{ip}\n") unless ip.empty?
        
      end
      
      f.close
      
    end
    
    
    
  end
  
  def self.parse_ip(str)
    if str =~ /ip-(\d+)-(\d+)-(\d+)-(\d+)\..+/
      return "#{$1}.#{$2}.#{$3}.#{$4}"   
    else
      return ''
    end
    
  end
  
end